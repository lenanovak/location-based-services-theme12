rm(list = ls())

met_zone1 <- read.csv('met_postaje.csv', header = TRUE)

library(stringr)
library(rvest)
library(dplyr)
library(rworldmap)

link = 'http://meteo.hr/naslovnica_aktpod.php?tab=aktpod'
website = read_html(link)

date_time = website %>% html_nodes(".hours-browser__title span") %>% html_text()

met_zone = website %>% html_nodes("#table-aktualni-podaci td.fd-u-text-align--left") %>% html_text() 

met_zone =  str_replace_all(gsub("[\r\n]", "", met_zone), fixed(" "), "")

temp = website %>% html_nodes("td:nth-child(4)") %>% html_text()

results = data.frame(met_zone, temp, stringsAsFactors = FALSE)

newmap <- getMap(resolution="low")

plot(newmap, xlim = c(16.5, 16.5), ylim = c(42.5, 46.5), asp = 1)
points(met_zone1$lon, met_zone1$lat, col = "red", cex = .6)
