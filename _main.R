# MENA Nighttime Lights

# Filepaths --------------------------------------------------------------------
if(Sys.info()[["user"]] == "robmarty"){
  proj_dir <- "~/Dropbox/World Bank/Side Work/MENA Nighttime Lights/"
  git_dir  <- "~/Documents/Github/mena-ntl"
} 

gf_dir <- file.path(proj_dir, "data", "global_gas_flaring")

# Libraries --------------------------------------------------------------------
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
library(blackmarbler)
library(sf)
library(geodata)
library(raster)
library(leaflet)
library(exactextractr)
library(readxl)
library(stringr)
library(haven)
library(ggplot2)

# Run Code ---------------------------------------------------------------------
if(F){
  code_dir <- file.path(proj_dir, "code")
  
  #source(file.path(git_dir, "01_make_roi.R"))
  #source(file.path(git_dir, "02_gas_flaring_locations.R"))
  source(file.path(git_dir, "03_download_blackmarble.R"))
  source(file.path(git_dir, "04_extract_data.R"))
  source(file.path(git_dir, "05_append_merge_data.R"))
  
}

