# SARWatch 0.9.4

SARWatch is a NASA Space Apps 2026 research prototype for comparing NISAR radar observations and Landsat optical imagery. It shows changes on an interactive map and exports PNG images and PDF reports in English, Russian, and Kazakh.

[Open SARWatch](https://sarwatch-space-apps-2026.onrender.com/)

## Run locally

The published `sarwatch-source.zip` contains the code, a built frontend, prepared cases, and tests. Extract it into a separate directory when working from the GitHub repository.

```sh
python3.12 -m zipfile -e sarwatch-source.zip source
cd source
python3.12 -m venv .venv
.venv/bin/python -m pip install -c requirements.lock.txt -e '.[web,test]'
.venv/bin/python -m sarwatch.serve
```

Open [http://127.0.0.1:8000/](http://127.0.0.1:8000/). On macOS, you can double-click `Start-SARWatch.command` after setup. It reuses the local service if it is already running. Set `SARWATCH_PORT=8001` if another application uses port 8000. The frontend uses HTTP for API requests. `SARWatch.html` links to the hosted application.

Prepared cases and catalog search are public. For a new NISAR calculation, copy `config.env.example` to a local `.env` and set `EARTHDATA_TOKEN` using your [Earthdata profile](https://urs.earthdata.nasa.gov/profile). Keep the token on the server and keep `.env` outside Git. Minimal Linux installations also need `libexpat1`. The Dockerfile includes it and verifies scientific Python imports.

The Dockerfile and Render Blueprint build the frontend and serve the interface and API from a single origin. See [deployment instructions](DEPLOY.md).

## Prepared cases

| Case | Observation dates in UTC | Area |
| --- | --- | --- |
| Mozambique flooding | Jan 5 and 17, 2026 · NISAR BETA | 75 × 75 km. Early data may exhibit masking and calibration artifacts. |
| North Aral Sea | Jun 21 and Oct 7, 2026 · NISAR PROVISIONAL | 30 × 30 km near Saryshyganak Bay in Kazakhstan. |
| Lake Urmia, Iran | Sep 22, 2014 and Sep 7, 2023 · Landsat 8 and 9 | 100 × 100 km across part of the lake and its surroundings. |
| Rasuwa, Nepal | Jun 20 and Aug 31, 2026 · NISAR PROVISIONAL | 30 × 30 km of mountain valleys before and after the August 26 flash flood. |
| Sinlahekin, United States | Jul 20 and Sep 6, 2026 · NISAR PROVISIONAL | 30 × 30 km of Washington State affected by wildfire. The radar channel is HVHV. |

Radar cases show signal changes in decibels. The Urmia case estimates changes in open water using pixels clear on both observation dates. Case manifests document acquisition dates, scene IDs, and event sources.

## Search and analysis

- Search for a place or enter latitude and longitude. Esri topographic and labeled satellite basemaps wrap horizontally. Select or resize a square up to 100 × 100 km. Browser geolocation is optional and starts after consent.
- Choose two to six dates. SARWatch automatically searches NISAR when every date falls on or after October 1, 2025. Each compatible radar observation must cover the selected square and match the other observations in track, frame, direction, mode, polarization, configuration, and processing version.
- If a compatible radar comparison is missing, SARWatch explains what the catalog found and offers an archive-wide search for other compatible NISAR dates at the same location. Select a proposed sequence to update the date fields. The optical alternatives can be searched separately.
- For dates before the NISAR archive, SARWatch checks Landsat Collection 2 Level-2 first. The Landsat archive starts on August 22, 1982 and supports Landsat 4, 5, 7, 8, and 9. Searches start within 32 days of each requested date and can expand to 96 days. NASA MODIS overview imagery is available from February 24, 2000 where imagery exists.
- Landsat uses QA_PIXEL to exclude clouds, cloud shadows, snow, and missing data. Water areas use comparable clear pixels, the Water flag, and shortwave infrared reflectance. The result displays a cloud warning when the selected Landsat pixels are obscured or when the NASA MODIS optical cloud-phase product detects clouds in the selected area.
- Open the Sources panel for original Earthdata scenes, ASF previews and HDF5 links, the Landsat catalog, or NASA Worldview.
- The weather panel compares NASA POWER observations in the 14 days before acquisition with local precipitation climatology. With `GEMINI_API_KEY`, the server requests an explanation using satellite previews, measurements, and weather. `OPENAI_API_KEY` supports a text explanation from metrics and weather.

## Scientific method and limitations

NISAR data are read with bounded HTTP Range requests. Native blocks are averaged in linear power to a grid of at most 640 samples per side. The displayed grid spacing depends on the study area. The pipeline checks GCOV quality masks and a common channel, aligns the observations, and compares the signal in decibels. Public ASF browse images are used for previews. They are limited to 8 MB of input and 1024 × 1024 pixels of output.

Experimental water classification uses a 3 × 3 median filter, a shared Otsu threshold, a class separation check, and removal of components under nine pixels. SARWatch shows the radar comparison when class separation is insufficient. Potential inundation uses the newly detected water class, excluding previously visible water, JRC historical water with frequency at or above 90%, and a 60 m buffer. It also limits results to slopes up to 5° from Copernicus DEM GLO-30.

Radar shadows, dark terrain, soil moisture, wind, and mixed pixels can affect classification. The DEM represents surface elevation. Interpreting changes requires independent evidence. Areas use comparable valid pixels and metric cell area. Coarser grids can miss small features. Analysis squares that cross the antimeridian or exceed supported latitudes are unsupported.

Each NISAR or Landsat pair can read up to 600 MB in 15 minutes. Two heavy jobs and two MODIS jobs can run concurrently with bounded queues. For a series, each pair of consecutive observations has its own metrics and exports.

## API and verification

Open `/docs` for the FastAPI reference. Main endpoints include `/api/health`, `/api/cases`, `/api/presets`, `/api/places`, `/api/scenes`, `/api/series`, and `/api/nisar/dates`. Create an analysis with `POST /api/analyses`. Check status and access exports under `/api/analyses/{id}`.

Up to 32 completed jobs can be restored while their output directory persists. Render Free deployments use temporary storage. Prepared cases are part of the image. With a separate frontend, set the exact frontend origins in `CORS_ORIGINS` and set `VITE_API_URL` at build time.

```sh
.venv/bin/python -m pytest -q
cd frontend
pnpm install --frozen-lockfile
pnpm build
```

The frontend uses Node 24 and pnpm 11.25. Backend tests cover bounded transfers, credentials, masks and projections, scene matching, area measurements, classification, exports, and the job lifecycle. `scripts/probe_balkhash.py` checks access to the data service.

## Data sources and attribution

- [ASF NISAR GCOV](https://nisar-docs.asf.alaska.edu/gcov/) and [NISAR Cookbook](https://asfopensarlab.github.io/NISAR_Cookbook/search-stream-nisar-asf-search/)
- [USGS Landsat QA bands](https://www.usgs.gov/landsat-missions/landsat-collection-2-quality-assessment-bands)
- [NASA GIBS](https://nasa-gibs.github.io/gibs-api-docs/) and [NASA POWER](https://power.larc.nasa.gov/)
- [JRC Global Surface Water](https://global-surface-water.appspot.com/download), EC JRC/Google and Pekel et al. (2016), DOI `10.1038/nature20584`
- [Copernicus DEM GLO-30](https://registry.opendata.aws/copernicus-dem/), ESA / Copernicus / Sinergise
- [Sentinel-2 through Earth Search](https://earth-search.aws.element84.com/v1)

The map displays attribution for its Esri basemaps. The Noto Sans font is distributed with its SIL Open Font License.
