# NISAR candidate audit — November 14, 2026

This audit checked eight proposed sites against official event sources and ASF catalog metadata. It reviewed acquisition dates, product maturity, compatible scene pairs, and full study-area coverage. Pixel quality and classification require separate checks.

## Primary candidates

| Candidate | Area | Catalog findings |
| --- | --- | --- |
| Limpopo / Incomati, Mozambique | 75 × 75 km | The original Jan 5 and Jan 17, 2026 BETA scenes fully cover the study area. NASA SVS 5661 uses the same dates. Measurements from this pair are experimental. |
| Navajo reservoir, United States | 50 × 50 km | Full PROVISIONAL pair from Sep 20 to Oct 14, 2026. An alternative VALIDATED pair spans Oct 26 to Nov 7, 2026. Agencies documented an increase in storage and surface elevation. |
| Chao Phraya, Thailand | 75 × 75 km | Full compatible pair from Jul 20 to Sep 30, 2026. The checked window yielded no scene from before Oct 7, 2025. Government sources confirm seasonal flooding. The proposed 2,700 km² estimate remains unverified for this study area. |

### Mozambique

- Center: −24.53, 32.98.
- Bounds: `[32.61293346799221, -24.864821428571428, 33.34706653200779, -24.195178571428574]`.
- Before: `NISAR_L2_PR_GCOV_009_114_A_165_4005_DHDH_A_20260105T034232_20260105T034253_X05010_N_P_J_001`.
- After: `NISAR_L2_PR_GCOV_010_114_A_165_4005_DHDH_A_20260117T034232_20260117T034254_X05010_N_P_J_001`.
- BETA, CRID `X05010`, track 114, frame 165, mode 4005, DHDH.
- The visualized NASA region can differ from the study square. Detection of flooded forest requires a method designed for water under vegetation. [NASA SVS 5661](https://svs.gsfc.nasa.gov/5661/)

### Navajo reservoir

- Center: 36.85, −107.55.
- Bounds: `[-107.82813524604894, 36.62678571428572, -107.27186475395105, 37.073214285714286]`.
- PROVISIONAL before: `NISAR_L2_PR_GCOV_031_027_D_070_4005_DHDH_A_20260920T015822_20260920T015857_P05023_F_F_J_001`.
- PROVISIONAL after: `NISAR_L2_PR_GCOV_033_027_D_070_4005_DHDH_A_20261014T015823_20261014T015857_P05023_N_F_J_001`.
- VALIDATED before: `NISAR_L2_PR_GCOV_034_027_D_070_4005_DHDH_A_20261026T015823_20261026T015858_P05036_N_F_J_001`.
- VALIDATED after: `NISAR_L2_PR_GCOV_035_027_D_070_4005_DHDH_A_20261107T015823_20261107T015858_P05036_N_F_J_001`.
- Every scene covers the square. Each pair uses one CRID. The Colorado River Board reported roughly 479,000 acre-feet of additional storage and a 48-foot increase in surface elevation since early October. [Colorado River Board, November 12, 2026](https://crb.ca.gov/wp-content/uploads/2026/11/20261112-board-packet.pdf) · [USBR October summary](https://www.usbr.gov/uc/water/rsvrs/ops/monthly_summaries/26_10_allRes.pdf)

### Chao Phraya

- Center: 14.35, 100.55.
- Bounds: `[100.20490566638468, 14.01517857142857, 100.89509433361532, 14.684821428571428]`.
- Before: `NISAR_L2_PR_GCOV_026_004_D_081_4005_DHDH_A_20260720T114713_20260720T114748_P05023_N_F_J_001`.
- After: `NISAR_L2_PR_GCOV_032_004_D_081_4005_DHDH_A_20260930T114712_20260930T114746_P05023_N_F_J_001`.
- Both observations are PROVISIONAL with CRID `P05023`, track 004, frame 081, and full coverage.
- Soil moisture and crop cycles also affect radar backscatter. Flood extent and damage require independent confirmation. [Government warning, September 29 to October 4](https://thailand.go.th/public/guide-book-detail/high-tide-warning-29-sept4-oct) · [Government update, October 5](https://thailand.go.th/guide-book-detail/jicc-warns-of-further-rainfall-despite-improving-flood-conditions)

## Other candidates

- **Rasuwa, Nepal.** The Aug 26, 2026 flash flood is documented. A 30 km square has full compatible coverage on Jun 20 and Aug 31. The Aug 28 observation was acquired on a different track from the June scene. A radar intensity comparison can show changes. Forecasts and landslide extent require other evidence. [Nepal Ministry of Health update](https://nepal.gov.np/api/updates/475d9917-63ec-4e65-886a-d81c778d1bfb/attachments/1c0969fa-c16a-43fc-bd0f-c4f213f9d624)
- **Gironde / Bordeaux, France.** Authorities confirmed the Saumos fire from Jul 22, 2026. Its documented extent is north of the original center at 44.55, −0.85. A 50 km square centered on 44.9, −1.0 has a compatible Jul 17 to Aug 10 pair. Burned area requires independent validation. [French Ministry of Agriculture](https://agriculture.gouv.fr/incendies-en-gironde-et-dans-les-landes-reconnaissance-dun-sinistre-de-grande-ampleur-pour-les) · [Gironde prefecture](https://www.gironde.gouv.fr/Actualites/Incendie-en-Gironde-toutes-les-informations-utiles)
- **Washington, United States.** Authorities recorded the Sinlahekin fire from Jul 26, 2026 near 48.70472, −119.69306, outside the original square. A revised 75 km square has full compatible coverage on Jul 25 and Aug 18. [Washington State Patrol](https://wsp.wa.gov/state-fire-mobilization-authorized-for-the-sinlahekin-fire/) · [Washington DNR](https://dnr.wa.gov/news/2026/department-natural-resources-implements-full-closure-loomis-state-forest-due-fire-operations-hazards) · [InciWeb](https://inciweb.wildfire.gov/incident-information/wanes-sinlahekin-fire)
- **Apuí, Brazil.** Apuí is on Brazil's deforestation monitoring priority list. The checked window yielded no GCOV before Sep 1, 2025. Compatible pairs from June through September 2026 are available. Event-level deforestation still requires supporting evidence. [Brazil's Ministry of the Environment](https://www.gov.br/mma/pt-br/assuntos/controle-ao-desmatamento-queimadas-e-ordenamento-ambiental-territorial/controle-do-desmatamento-1/municipios-prioritarios-da-amazonia)
- **Ganges floodplain.** IIRS illustrates strong L-band backscatter from inundated forest. The original dates lacked a full pair. A distinct VALIDATED pair spans Oct 22 to Nov 3, 2026. SARWatch's dark open-water classification is designed for exposed water. [IIRS study](https://science.iirs.gov.in/seeing-through-forests-how-nisar-reveals-what-lies-beneath/), DOI `10.65456/iirs.2026.7.2.1`

## Maturity and acquisition gap

BETA contains a limited early release. PROVISIONAL GCOV with CRID `P05023` includes observations starting Jun 17, 2026. The initial VALIDATED release with CRID `P05036` was published Nov 6, 2026 and covers acquisitions from Oct 21. Match maturity and CRID when comparing observations. ASF documents an instrument data gap from Jul 27, 2026 at 22:03:25 UTC to Aug 10, 2026 at 00:55:27 UTC. [Available data](https://nisar-docs.asf.alaska.edu/availability-overview/) · [Known issues](https://nisar-docs.asf.alaska.edu/nisar-known-issues/)

BETA data can show mask displacement, radiometric stripes, and radio-frequency interference. Browse previews can be offset by kilometers. Full footprint coverage is a catalog check. Pixel quality still requires validation.

## Preview and processing measurements

Public PNG previews returned HTTP 200 and decoded successfully without Earthdata authentication under an 8 MB input cap. The following timings were measured locally.

| Pair | Thumbnails before / after | Browse images before / after | GET time |
| --- | --- | --- | --- |
| Mozambique | 100 × 100, 9.4 / 9.7 KB | 1948 × 1884, 3.10 / 3.14 MB | Thumbnail about 2 s, browse 2.6–3.1 s |
| Navajo reservoir | 100 × 100, 13.2 / 12.9 KB | 1972 × 1941, 4.02 / 3.95 MB | Thumbnail 1.6–2 s, browse 2.8–3.1 s |
| Thailand | 100 × 100, 14.2 / 13.9 KB | 1990 × 1963, 5.23 / 5.00 MB | Thumbnail about 1.9 s, browse 2.8–3.1 s |

Scientific calculations used HTTP Range reads and averaged native blocks in linear power to a metric grid. Area estimates require comparable valid pixels and metric cell area. The selected square's nominal area is the side length squared.

| Run on local Mac | Grid spacing | Wall time | Data read | Peak process RSS |
| --- | ---: | ---: | ---: | ---: |
| Mozambique 75 km | 120 m | 468.1 s | 565.7 MB | 294.6 MiB |
| Navajo 50 km | 80 m | 195.4 s | 217.1 MB | 300.4 MiB |
| Thailand 75 km | 120 m | 366.5 s | 527.4 MB | 294.4 MiB |

Water and land failed the shared Otsu separation check for all three pairs. The resulting products display before and after observations and radar intensity differences. Render performance requires separate measurements. Local audit fixtures were recorded in `work/candidates-2026-audit.json` and `work/candidate-browse-probe.json`.
