library(shiny)
library(dplyr)
library(gapminder)
library(ggplot2)

#Crear el ui
ui <- fluidPage(
  titlePanel("Gráficos de la mediana y correlación de la
             esperanza de vida con el PIB per cápital
             por medio de los continentes"),

#Selección por años y botoncito de generar
sidebarLayout(
    sidebarPanel(
      selectInput("Año2", "Elige el año de la esperanza de vida:",
                  choices = unique(gapminder$year)),
      selectInput("Año1", "Elige el año del PIB per cápital:",
                  choices = unique(gapminder$year)),
      selectInput("Año3", "Elige el año de la correlación:",
                  choices = unique(gapminder$year)),
      actionButton("plot", "Generar gráfico")),

#Donde colocar el dato
    mainPanel(
      plotOutput("barPlot1"),
      plotOutput("barPlot2"),
      plotOutput("ggplot1")
    )
)
)
# Crear el server
server <- function(input, output) {
  #Seleccionar el año
  año1 <- reactiveVal()
  año2 <- reactiveVal()
  año3 <- reactiveVal()
  
  observeEvent(input$plot, {
    año1(input$Año1)
    año2(input$Año2)
    año3(input$Año3)
  })
  
  output$barPlot1 <- renderPlot({
    req(año1())

