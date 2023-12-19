# Make ROI

#### MENA Countries ISO
mena_iso3 <- c("DZA", "BHR", "DJI", "EGY", "IRN", "IRQ", "ISR", "JOR", "KWT", "LBN", 
              "LBY", "MRT", "MAR", "OMN", "PSE", "QAT", "SAU", "SDN", "SYR", "TUN", 
              "ARE", "YEM")

#### Make polygons
adm0_sf <- lapply(mena_iso3, function(iso){
  gadm(iso, level = 0, path = tempdir()) %>% st_as_sf()
}) %>%
  bind_rows()

adm1_sf <- lapply(mena_iso3, function(iso){
  gadm(iso, level = 1, path = tempdir()) %>% st_as_sf()
}) %>%
  bind_rows()

#### Save data
saveRDS(adm0_sf, file.path(proj_dir, "data", "gadm", "mena_adm0.Rds"))
saveRDS(adm1_sf, file.path(proj_dir, "data", "gadm", "mena_adm1.Rds"))
