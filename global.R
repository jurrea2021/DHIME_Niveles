library(shiny)
library(shinyFiles)
library(readxl)
library(reshape2)
library(leaflet)

RUTA = "data/"

NombresEstaciones = as.data.frame(readxl::read_excel(paste0(RUTA,"Estaciones_Niveles_NOMBRES.xlsx")))