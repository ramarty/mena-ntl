# Check Data

# Load data --------------------------------------------------------------------
df <- read_dta(file.path(proj_dir, "data", "ntl_panel", "mena_ntl_adm0_annual.dta"))

gas_df <- read_xlsx(file.path(gf_dir, "RawData",
                              "GGFR-Flaring-Dashboard-Data-March292023.xlsx"))

df %>%
  dplyr::filter(year >= 2012) %>%
  ggplot() +
  geom_line(aes(x = year,
                y = ntl_bm_mean)) +
  facet_wrap(~gadm_name_0,
             scales = "free_y")

df %>%
  dplyr::filter(year >= 2012) %>%
  ggplot() +
  geom_line(aes(x = year,
                y = ntl_gf_5km_bm_mean)) +
  facet_wrap(~gadm_name_0,
             scales = "free_y")

df %>%
  dplyr::filter(year >= 2012) %>%
  ggplot() +
  geom_line(aes(x = year,
                y = ntl_nogf_5km_bm_mean)) +
  facet_wrap(~gadm_name_0,
             scales = "free_y")

gas_df$COUNTRY %>%
  unique() %>%
  sort() 
