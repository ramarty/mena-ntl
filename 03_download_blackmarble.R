# Download Black Marble

#### Define bearer token
bearer <- file.path(proj_dir, "blackmarble_token", "bearer_bm.csv") %>%
  read.csv() %>%
  pull(token)

#### Load ROI
roi_sf <- readRDS(file.path(proj_dir, "data", "gadm", "mena_adm0.Rds"))

#### Download monthly data
bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A3",
          date = seq.Date(from = ymd("2012-01-01"), 
                          to = Sys.Date(), 
                          by = "month"),
          bearer = bearer,
          output_location_type = "file",
          file_dir = file.path(proj_dir,
                               "data",
                               "ntl_blackmarble",
                               "monthly"))

#### Download annual data
bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A4",
          date = 2012:2023,
          bearer = bearer,
          output_location_type = "file",
          file_dir = file.path(proj_dir,
                               "data",
                               "ntl_blackmarble",
                               "annual"))

