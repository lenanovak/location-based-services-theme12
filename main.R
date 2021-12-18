rm(list = ls())

library(stringr)
library(stringi)


#met_zone <- read.csv('met_postaje.csv', header = TRUE)

website_data <- read.csv("http://meteo.hr/naslovnica_aktpod.php?tab=aktpod", header=FALSE, skip=910)

measure_date <- stri_sub(str_replace_all(website_data[8:8,], fixed(" "), ""), 24, 33)
measure_hour <- stri_sub(str_replace_all(website_data[8:8,], fixed(" "), ""), 35, 36)

tmp_postaja_name <- stri_sub(str_replace_all(website_data[32:32,], fixed(" "), ""), 32)
tmp_postaja_temp <- stri_sub(str_replace_all(website_data[38:38,], fixed(" "), ""), 5, 7)

tmp_postaja_name2 <- stri_sub(str_replace_all(website_data[56:56,], fixed(" "), ""), 32)
tmp_postaja_temp2 <- stri_sub(str_replace_all(website_data[62:62,], fixed(" "), ""), 5, 8)
  
tmp_postaje <- c(tmp_postaja_name, tmp_postaja_name2)
tmp_temp <- c(tmp_postaja_temp, tmp_postaja_temp2)
  
rezultati <- data.frame(postaje = tmp_postaje, 
                        temperatura = tmp_temp)
