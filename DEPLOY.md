# Deploying SARWatch on Render

The Docker image serves the React frontend, FastAPI, and prepared cases from one HTTPS origin. The existing Render deployment is connected to the GitHub `main` branch.

## Deploy a service

1. Publish the unpacked source tree or the prepared `sarwatch-source.zip` alongside `Dockerfile`, `.dockerignore`, and `render.yaml`. The archive contains `frontend/`, `sarwatch/`, `cases/`, `pyproject.toml`, and `requirements.lock.txt` at its root.
2. Create a Render Blueprint from the repository. The blueprint defines one Docker web service on the Free plan.
3. Set `EARTHDATA_TOKEN` in the Render environment for new NISAR processing. Obtain it from [NASA Earthdata](https://urs.earthdata.nasa.gov/profile). Prepared cases and public metadata search work without a token.
4. Wait for the service to show Live, then open the public URL. Check `/api/health` for `application: "sarwatch"`, `status: "ok"`, and `data_access_configured: true`. Verify the language switcher, case reports, acquisition dates, and new analysis jobs.

The image builds the frontend with Node 24 and pnpm 11.25.0. The Python 3.12 runtime installs locked scientific dependencies and runs as an unprivileged user. The server binds to `0.0.0.0` using Render's `PORT`. One Uvicorn process manages two heavy analysis slots and two separate MODIS slots. `SARWATCH_QUEUE_LIMIT` sets the waiting capacity for each queue. The Free service can sleep when idle. Restarts and deployments can clear temporary jobs. Prepared cases stay available in the image. [Blueprint reference](https://render.com/docs/blueprint-spec) · [Health checks](https://render.com/docs/health-checks) · [Free plan](https://render.com/docs/free)

Keep secrets in Render environment variables. The archive builder excludes `.env`, credentials, temporary job data, dependencies, and raw HDF5 and GeoTIFF files. The Docker build checks the archive structure before extraction. [Environment variables](https://render.com/docs/configure-environment-variables)

## Gemini on Render

Create a key in [Google AI Studio](https://aistudio.google.com/apikey). In the Render service, open **Environment** and add `GEMINI_API_KEY`. Save and redeploy. An existing `gemini` Environment Group can be linked under **Linked Environment Groups**. A variable set directly on the service takes precedence over a group variable of the same name.

Check `ai_configured` in `/api/health` and open the weather panel in a prepared case to verify that Gemini returns an explanation. The default model is `gemini-3.5-flash-lite`. Gemini receives satellite previews, measurements, and NASA POWER weather data. `OPENAI_API_KEY` supports text-only explanations. [Link an environment group](https://render.com/docs/configure-environment-variables#linking-a-group-to-a-service)

## Separate frontend and optional worker

Lovable and Vercel clients use the same Render API. For Lovable, run `python scripts/build_lovable.py` and upload `release/sarwatch-lovable.zip` using **Import project → Upload code**. For Vercel, build `frontend` with `VITE_API_URL=https://sarwatch-space-apps-2026.onrender.com`. Add the exact frontend origins to Render's comma-separated `CORS_ORIGINS`. [Lovable project import](https://docs.lovable.dev/features/projects/import-project)

The Render API assigns jobs to its local analysis slots or an optional Docker worker. Run the external worker from the same image with `python -m sarwatch.worker`. Set the same random `SARWATCH_WORKER_TOKEN` of at least 32 characters on Render and the worker. On the worker set `SARWATCH_WORKER_API=https://sarwatch-space-apps-2026.onrender.com` and `EARTHDATA_TOKEN`. The result and Gemini explanation are served from Render. If a worker stops renewing its lease for 120 seconds, a subsequent status, health, or queue request returns the job to a Render slot. Check `external_worker_enabled` and the job's `executor` field. [Vercel Daemons](https://vercel.com/docs/daemons)

## Verify the container locally

```sh
docker build -t sarwatch:local .
docker run --rm -p 8000:8000 --env-file .env sarwatch:local
```

Open [http://127.0.0.1:8000/](http://127.0.0.1:8000/). Omit `--env-file .env` for a smoke test of prepared cases. The environment file is passed to the running container.
