#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("./global.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  

  
  observe({
    if(!is.null(req(input$refresh2))){
      session$reload()
    }
  })
  
  
  volumes = getVolumes()
  # shinyFileChoose(input, "station", roots = volumes, session = session)
  
  observe({
    # shinyFileChoose(input, "station", roots = c("UserFolder"='C:/'), session = session)
    shinyFileChoose(input, "station", roots = volumes, session = session)
  })
  
  
  liste_station<-reactive({
    if(!is.null(req(input$station))){
      as.character(parseFilePaths(volumes, input$station)$datapath)
    }
  })
  
  
  dat<-reactive({
    archivo<-readxl::read_excel(liste_station())
    archivo$FECHALECTURA = as.POSIXct(strptime(archivo$FECHALECTURA,"%Y-%m-%d %H:%M:%OS")) ## NUEVO
    archivo = reshape2::melt(archivo,
                             id.vars = c("FECHALECTURA"),
                             variable.name="Estacion",
                             value.name = "Nivel",value.factor = F)
    archivo$Estacion = as.character(archivo$Estacion)
    archivo
  })
  # 
  # 
  # estaciones<-reactive({
  #   datos = dat()
  #   estaciones = data.frame("estacion" = unique(datos$Estacion),
  #                           "presencia" = 1)
  #   estaciones
  # })
  # 
  # 
  # NombresEstaciones<-reactive({
  #   station = estaciones()
  #   NombresEstaciones = merge(NombresEstaciones,station,
  #                             by.x = "Estacion_Archivo_Niveles",
  #                             by.y = "estacion",all.x = T)
  #   NombresEstaciones$observacion = NA
  #   NombresEstaciones$observacion[NombresEstaciones$presencia == 1] = "Activa"
  #   NombresEstaciones$observacion[is.na(NombresEstaciones$presencia)] = "Suspendida"
  #   NombresEstaciones
  # })
  
  
  output$mapNIVELES<-renderLeaflet({
    datos = dat()
    estaciones = data.frame("estacion" = unique(datos$Estacion),
                            "presencia" = 1)
    NombresEstaciones = merge(NombresEstaciones,estaciones,
                              by.x = "Estacion_Archivo_Niveles",
                              by.y = "estacion",all.x = T)
    NombresEstaciones$observacion = NA
    NombresEstaciones$observacion[NombresEstaciones$presencia == 1] = "Activa"
    NombresEstaciones$observacion[is.na(NombresEstaciones$presencia)] = "Suspendida"
    
    NombresEstaciones2 = NombresEstaciones
    pal = colorFactor(palette = c("blue", "red"),levels = c("Activa","Suspendida"))
    
    leaflet() %>% 
      addTiles(group = "Google Maps") %>%
      # addProviderTiles("Esri.WorldImagery",group = "WorldImagery") %>%
      # addProviderTiles(providers$Stamen.TonerLines,group = "WorldImagery") %>%
      # addProviderTiles(providers$Stamen.TonerLabels,group = "WorldImagery") %>%
      addCircleMarkers(data = NombresEstaciones2,group = "Estaciones_Niveles",
                       lng = NombresEstaciones2$Longitud_CATALOGO_CSV,
                       lat = NombresEstaciones2$Latitud_CATALOGO_CSV,
                       color = ~pal(observacion),layerId = NombresEstaciones2$Estacion_Niveles_SAB, 
                       label = ~ Estacion_Archivo_Niveles,radius = 2) %>% 
      addLayersControl(
        # baseGroups = c("Google Maps","WorldImagery"),
        baseGroups = c("Google Maps","WorldImagery"),
        overlayGroups = c("Estaciones_Niveles"),
        options = layersControlOptions(collapsed = FALSE)) %>% 
      leaflet::addLegend("bottomleft", 
                         pal = pal,
                         title = "Estado de la estacion",
                         values = NombresEstaciones2$observacion,
                         opacity = 1)
    
  })
  
}
