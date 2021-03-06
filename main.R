rm(list = ls())

#met_zone <- read.csv('met_postaje.csv', header = TRUE)

library(spdep)
library(leaflet)
library(sf)
library(rvest)
library(dplyr)
library(stringr)

link = 'http://meteo.hr/naslovnica_aktpod.php?tab=aktpod'
website = read_html(link)

date_time = website %>% html_nodes(".hours-browser__title span") %>% html_text()

met_zone = website %>% html_nodes("#table-aktualni-podaci td.fd-u-text-align--left") %>% html_text() 

met_zone =  str_replace_all(gsub("[\r\n]", "", met_zone), fixed(" "), "")

temp = website %>% html_nodes("td:nth-child(4)") %>% html_text()

results = data.frame(met_zone, temp, stringsAsFactors = FALSE)

results = results[!duplicated(results),]

lonlat = read.csv(file='met_postaje.csv', header=TRUE, encoding="UTF-8")

names(lonlat)[names(lonlat) == 'X.U.FEFF.postaja'] = 'met_zone'

results = merge(results, lonlat, by='met_zone')

k <- knearneigh(coordinates(cbind(results$lon, results$lat)), longlat = TRUE)

nb <- knn2nb(k)
print(nb)

colW <- nb2listw(nb)
print(nb2listw(nb))

moran(as.numeric(results$temp), nb2listw(nb), length(nb), Szero(nb2listw(nb)))

moran.mc(as.numeric(results$temp), nb2listw(nb), nsim=99)

hist(as.numeric(results$temp), main=NULL)
boxplot(as.numeric(results$temp), horizontal = TRUE)

print_data = paste(results$met_zone, results$temp)

map.point <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng=results$lon, lat=results$lat, clusterOptions = markerClusterOptions(), label = print_data)
map.point