# syntax=docker/dockerfile:1
# GitHub's browser uploader can publish the reviewed source as one root-level ZIP.
# An ordinary unpacked Git checkout uses the same build without an archive.
FROM python:3.12-slim-bookworm AS source
WORKDIR /input
COPY . ./
RUN mkdir /source \
    && if [ -f /input/sarwatch-source.zip ]; then \
         python -m zipfile -e /input/sarwatch-source.zip /source; \
       else cp -a /input/. /source/; fi
RUN python - <<'PY'
from pathlib import Path
root = Path('/source')
private_names = {'.env', '.venv', '.git', '.aws', '.codex', '.agents', 'node_modules', '.pnpm-store'}
bad = [p.relative_to(root).as_posix() for p in root.rglob('*')
       if p.name in private_names or p.name.startswith('.env.')]
if bad:
    raise SystemExit('Private/local inputs must be removed from source archive: ' + ', '.join(bad[:10]))
for name in ['pyproject.toml', 'requirements.lock.txt', 'sarwatch/api.py', 'frontend/package.json',
             'frontend/pnpm-lock.yaml', 'frontend/pnpm-workspace.yaml', 'cases']:
    if not (root/name).exists():
        raise SystemExit('Source root is missing ' + name)
PY

# The frontend build has no Earthdata token and calls the API on the same origin.
FROM node:24-bookworm-slim AS frontend
WORKDIR /app/frontend
RUN npm install --global pnpm@11.25.0
COPY --from=source /source/frontend/package.json /source/frontend/pnpm-lock.yaml /source/frontend/pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY --from=source /source/frontend/ ./
COPY --from=source /source/cases/ /app/cases/
COPY --from=source /source/sarwatch/assets/presets.json /app/sarwatch/assets/presets.json
RUN pnpm build

FROM python:3.12-slim-bookworm AS runtime
WORKDIR /app
RUN apt-get update \
    && apt-get install --yes --no-install-recommends libexpat1 \
    && rm -rf /var/lib/apt/lists/*
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    OPENBLAS_NUM_THREADS=1 \
    OMP_NUM_THREADS=1 \
    GDAL_NUM_THREADS=1 \
    GDAL_CACHEMAX=32 \
    MALLOC_ARENA_MAX=2 \
    SARWATCH_WEB_DIR=/app/frontend/dist \
    SARWATCH_CASES_DIR=/app/cases \
    SARWATCH_DATA_DIR=/tmp/sarwatch/jobs

COPY --from=source /source/ ./
# Constraints pin the verified package versions. Wheels supply the scientific
# libraries; a missing Linux wheel fails the build instead of compiling silently.
RUN python -m pip install --no-cache-dir --only-binary=:all: \
      --constraint requirements.lock.txt '.[web]' \
    && groupadd --system --gid 10001 sarwatch \
    && useradd --system --uid 10001 --gid sarwatch --home-dir /app sarwatch
# A healthy web server must not conceal missing native scientific dependencies.
RUN python -c "import rasterio,h5py,numpy,scipy,pyproj; from sarwatch.pipeline import run_analysis; from sarwatch.report import create_report; print('Scientific runtime imports verified')"
COPY --from=frontend /app/frontend/dist/ ./frontend/dist/
USER 10001:10001
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD python -c "import os,urllib.request; urllib.request.urlopen('http://127.0.0.1:'+os.environ.get('PORT','8000')+'/api/health',timeout=3)"
CMD ["sh", "-c", "exec python -m uvicorn sarwatch.api:app --host 0.0.0.0 --port ${PORT:-8000} --workers 1"]
