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
      selectInput("Año1", "Elige el año del PIB per cápital:",
                  choices = unique(gapminder$year)),
      selectInput("Año2", "Elige el año de la esperanza de vida:",
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

# Crear el servidor
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
    
    #Base filtrada
    a <- select(gapminder, continent, year, gdpPercap) %>%
      filter(year == año1()) %>%
      group_by(continent) %>%
      summarize(mediana_gdpPercap = median(gdpPercap))
    
    #Gráfico de barras
    barplot(height = a$mediana_gdpPercap,
            names.arg = a$continent,
            main = paste("Mediana del per cápita por continente en", año1()),
            xlab = "Continentes",
            ylab = "Mediana del per cápita",
            col = "red",
            horiz = F)
    })
  
  #Segunda base filtrada
  output$barPlot2 <- renderPlot({
    req(año2())
    
    b <- select(gapminder, continent, year, lifeExp) %>%
      filter(year == año2()) %>%
      group_by(continent) %>%
      summarize(mediana_lifeExp = median(lifeExp))
    
    
    #Gráfico de barras
    barplot(height = b$mediana_lifeExp,
            names.arg = b$continent,
            main = paste("Mediana de la esperanza de vida por continente en", año2()),
            xlab = "Continentes",
            ylab = "Mediana de la esperanza de vida",
            col = "blue",
            horiz = F)
    })
  
  output$ggplot1 <- renderPlot({
    req(año3())
    
    c <- gapminder %>%
      filter(year == año3())
    
    ggplot(c, aes(x = gdpPercap, y = lifeExp, color = continent)) +
      geom_point(alpha = 0.5) +
      labs(title = paste("Correlación de la esperanza de vida con el
      per cápital en", año3()),
           x = paste("PIB per cápita"),
           y = paste("Esperanza de vida"), 
           color = paste("Continente")) +
      theme_minimal()
  })
}

#Correr
shinyApp(ui = ui, server = server)
           
  

