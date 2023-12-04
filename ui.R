#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFiles)
library(readxl)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("Niveles IDIGER"),
  
  shinyFilesButton("station", "Elegir archivo con los datos de niveles de las estaciones" ,
                   title = "Seleccionar una lista de estaciones:", multiple = FALSE,
                   buttonType = "default", class = NULL,style='padding:13px; font-size:80%'),
  p(),
  actionButton('summary','Visualizar los resultados',style='padding:13px; font-size:80%'),
  
  p(),
  actionButton('refresh2','Recargar el software',style='padding:15px; font-size:80%'),
  
  # Sidebar with a slider input for number of bins
  
  conditionalPanel('input.summary',
                   leafletOutput("mapNIVELES")
                   # mainPanel(
                   #   leafletOutput("mapNIVELES")
                   # )
                   # sidebarLayout(
                   #   # sidebarPanel(
                   #   #   sliderInput("bins",
                   #   #               "Number of bins:",
                   #   #               min = 1,
                   #   #               max = 50,
                   #   #               value = 30)
                   #   # ),
                   #   
                   #   # Show a plot of the generated distribution
                   # 
                   # )
  )
)
