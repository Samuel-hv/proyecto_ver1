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
    

