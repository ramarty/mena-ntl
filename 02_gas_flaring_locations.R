# Gas Flaring Locations

# Load data --------------------------------------------------------------------
gas_df <- read_xlsx(file.path(gf_dir, "RawData",
                          "GGFR-Flaring-Dashboard-Data-March292023.xlsx"))

adm0_sf <- readRDS(file.path(proj_dir, "data", "gadm", "mena_adm0.Rds"))
adm1_sf <- readRDS(file.path(proj_dir, "data", "gadm", "mena_adm1.Rds"))

adm0_sf <- adm0_sf %>%
  dplyr::select(COUNTRY) %>%
  dplyr::rename(gadm_name_0 = COUNTRY)

adm1_sf <- adm1_sf %>%
  dplyr::select(COUNTRY, NAME_1, GID_0, GID_1) %>%
  dplyr::rename(gadm_name_0 = COUNTRY,
                gadm_name_1 = NAME_1,
                gid_0 = GID_0,
                gid_1 = GID_1)

# Prep points ------------------------------------------------------------------
gas_df <- gas_df %>%
  distinct(Latitude, Longitude, .keep_all = T)

gas_sf <- st_as_sf(gas_df, coords = c("Longitude", "Latitude"), crs=4326)

gas_sf <- st_intersection(gas_sf, adm0_sf)
gas_sf <- gas_sf %>%
  dplyr::select(-gadm_name_0)

# gas_sf <- st_intersection(gas_sf, adm1_sf)

# Prep buffers -----------------------------------------------------------------
gas_5km_sf  <- st_buffer(gas_sf, dist = 5000)
gas_10km_sf <- st_buffer(gas_sf, dist = 10000)

# Unions & valid ---------------------------------------------------------------
gas_5km_sf_u  <- gas_5km_sf  %>% st_union() %>% st_make_valid()
gas_10km_sf_u <- gas_10km_sf %>% st_make_valid() %>% st_union() %>% st_make_valid()

adm0_sf <- adm0_sf %>% st_make_valid()
adm1_sf <- adm1_sf %>% st_make_valid()

# Remove empty geoms -----------------------------------------------------------
gas_5km_sf_u  <- gas_5km_sf_u %>% st_as_sf()
gas_10km_sf_u <- gas_10km_sf_u %>% st_as_sf()

gas_5km_sf_u   <- gas_5km_sf_u[2,]
gas_10km_sf_u  <- gas_10km_sf_u[2,]

# Prep gas flaring -------------------------------------------------------------
adm0_gf_5km_sf  <- st_intersection(adm0_sf, gas_5km_sf_u) %>% st_as_sf()
adm0_gf_10km_sf <- st_intersection(adm0_sf, gas_10km_sf_u) %>% st_as_sf()

adm1_gf_5km_sf  <- st_intersection(adm1_sf, gas_5km_sf_u) %>% st_as_sf()
adm1_gf_10km_sf <- st_intersection(adm1_sf, gas_10km_sf_u) %>% st_as_sf()

# Prep ADM non flaring ---------------------------------------------------------
adm0_nogf_5km_sf  <- st_difference(adm0_sf, gas_5km_sf_u) %>% st_as_sf()
adm0_nogf_10km_sf <- st_difference(adm0_sf, gas_10km_sf_u) %>% st_as_sf()

adm1_nogf_5km_sf  <- st_difference(adm1_sf, gas_5km_sf_u) %>% st_as_sf()
adm1_nogf_10km_sf <- st_difference(adm1_sf, gas_10km_sf_u) %>% st_as_sf()

# Export -----------------------------------------------------------------------

## Gas Flaring
saveRDS(adm0_gf_5km_sf,  file.path(gf_dir, "FinalData", "adm0_gas_flaring_5km.Rds"))
saveRDS(adm0_gf_10km_sf, file.path(gf_dir, "FinalData", "adm0_gas_flaring_10km.Rds"))

saveRDS(adm1_gf_5km_sf,  file.path(gf_dir, "FinalData", "adm1_gas_flaring_5km.Rds"))
saveRDS(adm1_gf_10km_sf, file.path(gf_dir, "FinalData", "adm1_gas_flaring_10km.Rds"))

## Non Gas Flaring
saveRDS(adm0_nogf_5km_sf,  file.path(gf_dir, "FinalData", "adm0_non_gas_flaring_5km.Rds"))
saveRDS(adm0_nogf_10km_sf, file.path(gf_dir, "FinalData", "adm0_non_gas_flaring_10km.Rds"))

saveRDS(adm1_nogf_5km_sf,  file.path(gf_dir, "FinalData", "adm1_non_gas_flaring_5km.Rds"))
saveRDS(adm1_nogf_10km_sf, file.path(gf_dir, "FinalData", "adm1_non_gas_flaring_10km.Rds"))

