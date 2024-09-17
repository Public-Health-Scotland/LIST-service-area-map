lookups_folder <- path("/conf/linkage/output/lookups/Unicode")
shapefiles_folder <- path(lookups_folder, "Geography", "Shapefiles")
spd_path <- path(lookups_folder, "Geography", "Scottish Postcode Directory", "Scottish_Postcode_Directory_2024_2.parquet")

hscp_hb_lookup <- read_parquet(spd_path, col_select = c("hscp2019", starts_with("hb2019"))) |>
  distinct() |>
  mutate(service_manager = case_match(
    hb2019name,
    c("NHS Highland", "NHS Grampian", "NHS Orkney", "NHS Shetland", "NHS Tayside", "NHS Western Isles") ~ "Jenny (North)",
    c("NHS Borders", "NHS Fife", "NHS Forth Valley", "NHS Lanarkshire", "NHS Lothian") ~ "Gavin (Central and South)",
    c("NHS Ayrshire and Arran", "NHS Dumfries and Galloway", "NHS Greater Glasgow and Clyde") ~ "Julie (West)",
  ) |>
    factor())

hscp_shp <- read_sf(path(shapefiles_folder, "HSCP 2019", "SG_NHS_IntegrationAuthority_2019.shp")) |>
  # converts the shapefile to use latitude and longitude
  st_transform(4326) |>
  select(
    hscp_2019 = HIACode,
    hscp_name = HIAName,
    geometry
  ) |>
  left_join(
    hscp_hb_lookup,
    by = join_by(hscp_2019 == hscp2019),
    relationship = "one-to-one",
    unmatched = "error"
  )
