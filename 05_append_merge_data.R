# Append and Merge

#### Define units
units <- c("mena_adm0", 
           "mena_adm1",
           "adm0_gas_flaring_5km",
           "adm0_gas_flaring_10km",
           "adm1_gas_flaring_5km",
           "adm1_gas_flaring_10km",
           "adm0_non_gas_flaring_5km",
           "adm0_non_gas_flaring_10km",
           "adm1_non_gas_flaring_5km",
           "adm1_non_gas_flaring_10km")

adm0_units <- units %>% str_subset("adm0")
adm1_units <- units %>% str_subset("adm1")

#### Function to Clean Names
clean_ntl_names <- function(df_i, unit_i){
  if(unit_i %in% c("adm0_gas_flaring_5km", "adm1_gas_flaring_5km")){
    names(df_i) <- names(df_i) %>% str_replace_all("ntl_", "ntl_gf_5km_")
  } 
  
  if(unit_i %in% c("adm0_gas_flaring_10km", "adm1_gas_flaring_10km")){
    names(df_i) <- names(df_i) %>% str_replace_all("ntl_", "ntl_gf_10km_")
  } 
  
  if(unit_i %in% c("adm0_non_gas_flaring_5km", "adm1_non_gas_flaring_5km")){
    names(df_i) <- names(df_i) %>% str_replace_all("ntl_", "ntl_nogf_5km_")
  } 
  
  if(unit_i %in% c("adm0_non_gas_flaring_10km", "adm1_non_gas_flaring_10km")){
    names(df_i) <- names(df_i) %>% str_replace_all("ntl_", "ntl_nogf_10km_")
  } 
  
  if(unit_i %in% c("mena_adm0")){
    df_i <- df_i %>%
      dplyr::rename(gadm_name_0 = COUNTRY) %>%
      dplyr::select(-GID_0)
  }
  
  if(unit_i %in% c("mena_adm1")){
    df_i <- df_i %>%
      dplyr::rename(gadm_name_0 = COUNTRY,
                    gadm_name_1 = NAME_1,
                    gid_0 = GID_0,
                    gid_1 = GID_1) %>%
      dplyr::select(-c(VARNAME_1, NL_NAME_1, TYPE_1, ENGTYPE_1, CC_1, HASC_1, ISO_1))
  }
  
  df_i
}

#### ADM0 Clean
adm0_month_df <- lapply(adm0_units, function(unit_i){
  file.path(proj_dir, "data", "ntl_panel", "individual_files", "monthly", unit_i) %>%
    list.files(full.names = T) %>%
    map_df(readRDS) %>% 
    clean_ntl_names(unit_i)
}) %>%
  reduce(full_join, by = c("gadm_name_0", "month"))

adm0_year_df <- lapply(adm0_units, function(unit_i){
  file.path(proj_dir, "data", "ntl_panel", "individual_files", "annual", unit_i) %>%
    list.files(full.names = T) %>%
    map_df(readRDS) %>% 
    clean_ntl_names(unit_i)
}) %>%
  reduce(full_join, by = c("gadm_name_0", "year"))

#### ADM1 Clean
adm1_month_df <- lapply(adm1_units, function(unit_i){
  file.path(proj_dir, "data", "ntl_panel", "individual_files", "monthly", unit_i) %>%
    list.files(full.names = T) %>%
    map_df(readRDS) %>% 
    clean_ntl_names(unit_i)
}) %>%
  reduce(full_join, by = c("gadm_name_0", "gadm_name_1", "gid_0", "gid_1", "month"))

adm1_year_df <- lapply(adm1_units, function(unit_i){
  file.path(proj_dir, "data", "ntl_panel", "individual_files", "annual", unit_i) %>%
    list.files(full.names = T) %>%
    map_df(readRDS) %>% 
    clean_ntl_names(unit_i)
}) %>%
  reduce(full_join, by = c("gadm_name_0", "gadm_name_1", "gid_0", "gid_1", "year"))

#### Export
write_dta(adm0_month_df, file.path(proj_dir, "data", "ntl_panel", "mena_ntl_adm0_monthly.dta"))
write_dta(adm0_year_df, file.path(proj_dir, "data", "ntl_panel", "mena_ntl_adm0_annual.dta"))

write_dta(adm1_month_df, file.path(proj_dir, "data", "ntl_panel", "mena_ntl_adm1_monthly.dta"))
write_dta(adm1_year_df, file.path(proj_dir, "data", "ntl_panel", "mena_ntl_adm1_annual.dta"))

