library(shiny)
library(plotly)
library(dplyr)

ui <- fluidPage(
  titlePanel("Casos Totales y Temperatura Mínima por Semana"),
  sidebarLayout(
    sidebarPanel(
      selectInput("distrito", "Selecciona un distrito:", 
                  choices = unique(final_data$distrito),
                  selected = unique(final_data$distrito)[1])
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlotly({
    # filtramos los datos por el distrito seleccionado
    plot_data <- final_data %>%
      filter(distrito == input$distrito) %>%
      arrange(ano, semana) %>%
      mutate(semana_continua = (ano - min(ano)) * 52 + semana)
    
    p <- plot_ly(plot_data, x = ~semana_continua, y = ~temp_min_semana, type = 'scatter', mode = 'lines', 
                 fill = 'tozeroy', name = 'Temp Mínima', 
                 line = list(shape = 'spline', color = 'rgba(255, 193, 7, 0.6)'),
                 hoverinfo = 'text', text = ~paste("Año:", ano, "<br>Semana:", semana, "<br>Temp Min:", temp_min_semana, "<br>Total Casos:", total_casos)) %>%
      add_trace(y = ~total_casos, type = 'scatter', mode = 'lines', 
                name = 'Total Casos', line = list(shape = 'spline', color = 'rgba(33, 37, 41, 0.8)'),
                hoverinfo = 'text', text = ~paste("Año:", ano, "<br>Semana:", semana, "<br>Total Casos:", total_casos, "<br>Temp Min:", temp_min_semana)) %>%
      layout(
        title = paste('Casos Totales y Temperatura Mínima por Semana en', input$distrito),
        xaxis = list(title = '', showticklabels = FALSE),
        yaxis = list(title = 'Total Casos'),
        yaxis2 = list(title = 'Temp Mínima (°C)', overlaying = 'y', side = 'right'),
        showlegend = TRUE,
        plot_bgcolor = 'rgba(0,0,0,0)',  
        paper_bgcolor = 'rgba(0,0,0,0)', 
        font = list(color = '#333333')   
      )
    
    p
  })
}

shinyApp(ui = ui, server = server)
