source("code/packages.R")
source("code/data.R")

sm_palette <- colorFactor(
  palette = phs_colors(c("phs-green", "phs-purple", "phs-magenta")),
  domain = hscp_shp$service_manager
)

hscp_shp |>
  leaflet(options = leafletOptions(zoomControl = FALSE)) |>
  addPolygons(
    # fill colour of the polygons
    fillColor = ~ sm_palette(service_manager),
    fillOpacity = 0.8,
    color = "black",
    # Thickness of borders
    weight = 0.4,
    # detail level of polygon (higher number = less accurate representation & better performance)
    smoothFactor = 0.1
  ) |>
  # Setting map provider for map background
  # you can see the list by typing providers$ or visiting the following link
  # # http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  addProviderTiles(provider = providers[["OpenStreetMap"]]) |>
  # addProviderTiles(provider = providers[["Stadia.Outdoors"]],
  #                  options = providerTileOptions(api_key = readr::read_lines("~/stadia_api_key.txt"))) |>
  addLegend(
    position = "topleft",
    pal = sm_palette,
    values = ~service_manager,
    title = "Service Area",
    opacity = 1
  )
