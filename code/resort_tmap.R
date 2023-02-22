##########################
#################  library
##########################

## clear workspace
rm(list = ls())
gc()

## libraries
library(tidyverse)
library(tmap)
library(sf)

##########################
##################### data
##########################

## read resort data and create spatial sf object
resorts = 
  read_csv('data/north_american_resorts.csv') %>% 
  st_as_sf(coords = c(x = 'longitude',
                      y = 'latitude'), 
           crs = 4326) %>% 
  st_transform(5070)

## get us shape
usa =
  ne_states(country = "united states of america", 
            returnclass = "sf") %>%
  st_transform(st_crs(resorts)) %>%
  select(name, name_len) %>% 
  filter(!(name %in% c('Hawaii')))

## get canada shape
canada = 
  ne_states(country = "canada", 
            returnclass = "sf") %>%
  st_transform(st_crs(resorts)) %>%
  select(name, name_len)

## get total north america shape
north_america = rbind(usa, canada)

##########################
##################### plot
##########################
tmap_mode("view")

tm_shape(north_america) +
  tm_borders() +
tm_shape(resorts) +
  tm_dots("elev_vertical")
