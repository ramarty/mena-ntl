# Extract data

BM_STATS <- c("mean", "median")

for(unit in c("mena_adm0", 
              "mena_adm1",
              "adm0_gas_flaring_5km",
              "adm0_gas_flaring_10km",
              "adm1_gas_flaring_5km",
              "adm1_gas_flaring_10km",
              "adm0_non_gas_flaring_5km",
              "adm0_non_gas_flaring_10km",
              "adm1_non_gas_flaring_5km",
              "adm1_non_gas_flaring_10km")){
  
  for(time_type in c("monthly", "annual")){
    
    dir.create(file.path(proj_dir, "data", "ntl_panel", "individual_files", time_type))
    dir.create(file.path(proj_dir, "data", "ntl_panel", "individual_files", time_type, unit))
    
    # Annual -------------------------------------------------------------------
    if(time_type %in% "annual"){
      
      for(year_i in 1992:2022){
        
        print(paste(unit, time_type, year_i))
        
        OUT_PATH <- file.path(proj_dir, "data", "ntl_panel", "individual_files", time_type, unit, 
                              paste0("ntl_", year_i, ".Rds"))
        
        if(!file.exists(OUT_PATH)){
          
          #### Load ROI
          if(unit %in% c("mena_adm0", "mena_adm1")){
            roi_sf <- readRDS(file.path(proj_dir, "data", "gadm", paste0(unit, ".Rds")))
          } else{
            roi_sf <- readRDS(file.path(gf_dir, "FinalData", paste0(unit, ".Rds")))
          }
          
          roi_df <- roi_sf %>%
            st_drop_geometry()
          
          roi_df$year <- year_i
          
          #### Process NTL
          if(year_i %in% 1992:2013){
            dmsp_r <- raster(file.path(proj_dir, "data", "ntl_dmspols", 
                                       paste0("Harmonized_DN_NTL_",year_i,"_calDMSP.tif")))
            
            dmsp_df        <- exact_extract(dmsp_r, roi_sf, BM_STATS, max_cells_in_memory=243995488)
            names(dmsp_df) <- paste0("ntl_dmsp_", names(dmsp_df))
            roi_df         <- bind_cols(roi_df, dmsp_df)
            
          }
          
          if(year_i %in% 2012:2022){
            bm_r <- raster(file.path(proj_dir, "data", "ntl_blackmarble", "annual",
                                     paste0("VNP46A4_t",year_i,".tif")))
            
            bm_df        <- exact_extract(bm_r,   roi_sf, BM_STATS, max_cells_in_memory=243995488)
            names(bm_df) <- paste0("ntl_bm_", names(bm_df))
            roi_df       <- bind_cols(roi_df, bm_df)
            
          }
          
          #### Export
          saveRDS(roi_df, OUT_PATH)
          
        }
      }
    }
    
    # Monthly ------------------------------------------------------------------
    if(time_type %in% "monthly"){
      
      monthly_files <- file.path(proj_dir, "data", "ntl_blackmarble", "monthly") %>%
        list.files()
      
      for(month_file_i in monthly_files){
        
        print(paste(unit, time_type, month_file_i))
        
        month_i <- month_file_i %>%
          str_replace_all("VNP46A3_t", "") %>%
          str_replace_all(".tif", "") %>%
          paste0("_01") 
        
        OUT_PATH <- file.path(proj_dir, "data", "ntl_panel", "individual_files", time_type, unit, 
                              paste0("ntl_", month_i, ".Rds"))
        
        if(!file.exists(OUT_PATH)){
          
          #### Load ROI
          if(unit %in% c("mena_adm0", "mena_adm1")){
            roi_sf <- readRDS(file.path(proj_dir, "data", "gadm", paste0(unit, ".Rds")))
          } else{
            roi_sf <- readRDS(file.path(gf_dir, "FinalData", paste0(unit, ".Rds")))
          }
          
          roi_df <- roi_sf %>%
            st_drop_geometry()
          
          roi_df$month <- month_i %>% ymd()
          
          #### Process NTL
          r <- raster(file.path(proj_dir, "data", "ntl_blackmarble", "monthly", month_file_i))
          
          bm_df        <- exact_extract(r, roi_sf, BM_STATS, max_cells_in_memory=243995488)
          names(bm_df) <- paste0("ntl_bm_", names(bm_df))
          roi_df       <- bind_cols(roi_df, bm_df)
          
          #### Export
          saveRDS(roi_df, OUT_PATH)
          
        }
      }
    }
    
    ##
  }
}


