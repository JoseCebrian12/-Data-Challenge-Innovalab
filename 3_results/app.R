library(shiny)
library(plotly)
library(dplyr)

# Crear la interfaz de usuario
ui <- fluidPage(
  titlePanel("Análisis de Casos de Dengue y Temperatura Mínima"),
  tabsetPanel(
    tabPanel("Visualización por Distrito",
             sidebarLayout(
               sidebarPanel(
                 selectInput("distrito", "Selecciona un distrito:", 
                             choices = unique(final_data$distrito),
                             selected = unique(final_data$distrito)[1])
               ),
               mainPanel(
                 plotlyOutput("plot_casos_temp"),
                 plotlyOutput("plot_temp_minima"),
                 plotlyOutput("plot_total_casos"),
                 plotlyOutput("plot_poblacion")
               )
             )
    ),
    tabPanel("Evaluación del Modelo",
             fluidRow(
               column(6, plotlyOutput("plot_residuos")),
               column(6, plotlyOutput("plot_observados_predichos"))
             ),
             br(),  # Add spacing between rows
             fluidRow(
               column(12, textOutput("summary_text"), align = "center")
             ),
             fluidRow(
               column(12, tableOutput("summary_tabla"), align = "center"),
               column(12, textOutput("summary_explanation"), align = "center")
             ),
             br(),  # Add spacing between rows
             fluidRow(
               column(12, textOutput("anova_text"), align = "center")
             ),
             fluidRow(
               column(12, tableOutput("anova_tabla"), align = "center"),
               column(12, textOutput("anova_explanation"), align = "center")
             ),
             br(),  # Add spacing between rows
             fluidRow(
               column(12, textOutput("confint_text"), align = "center")
             ),
             fluidRow(
               column(12, tableOutput("confint_tabla"), align = "center"),
               column(12, textOutput("confint_explanation"), align = "center")
             )
    )
  )
)

# Crear el servidor
server <- function(input, output) {
  # Filtrar los datos según el distrito seleccionado
  filtered_data <- reactive({
    final_data %>%
      filter(distrito == input$distrito) %>%
      arrange(ano, semana) %>%
      mutate(semana_continua = (ano - min(ano)) * 52 + semana)
  })
  
  # Gráfico combinado de temperatura mínima y casos totales
  output$plot_casos_temp <- renderPlotly({
    plot_data <- filtered_data()
    
    p <- plot_ly(plot_data, x = ~semana_continua, y = ~temp_min_semana, type = 'scatter', mode = 'lines', 
                 fill = 'tozeroy', name = 'Temp Mínima', 
                 line = list(shape = 'spline', color = 'rgba(255, 193, 7, 0.6)'),
                 hoverinfo = 'text', text = ~paste("Año:", ano, "<br>Semana:", semana, "<br>Temp Min:", temp_min_semana, "<br>Total Casos:", total_casos)) %>%
      add_trace(y = ~total_casos, type = 'scatter', mode = 'lines', 
                name = 'Total Casos', line = list(shape = 'spline', color = 'rgba(33, 37, 41, 0.8)'),
                hoverinfo = 'text', text = ~paste("Año:", ano, "<br>Semana:", semana, "<br>Total Casos:", total_casos, "<br>Temp Min:", temp_min_semana)) %>%
      layout(
        title = paste('Casos Totales y Temperatura Mínima por Semana en', input$distrito),
        xaxis = list(title = '', showticklabels = FALSE),  # Eliminamos el texto del eje X
        yaxis = list(title = 'Total Casos'),
        yaxis2 = list(title = 'Temp Mínima (°C)', overlaying = 'y', side = 'right'),
        showlegend = TRUE,
        plot_bgcolor = 'rgba(0,0,0,0)',  
        paper_bgcolor = 'rgba(0,0,0,0)', 
        font = list(color = '#333333')   
      )
    
    p
  })
  
  # Gráfico de residuos para el modelo de Negativa Binomial
  output$plot_residuos <- renderPlotly({
    plot_ly(final_data, x = ~predicciones_negbinom, y = ~residuals(modelo_negbinom, type = "pearson"), type = 'scatter', mode = 'markers') %>%
      layout(
        title = "Residuos vs Predicciones (Negativa Binomial)",
        xaxis = list(title = "Predicciones (Negativa Binomial)"),
        yaxis = list(title = "Residuos Pearson")
      )
  })
  
  # Gráfico de comparación entre casos observados y predichos para el modelo de Negativa Binomial
  output$plot_observados_predichos <- renderPlotly({
    plot_ly(final_data, x = ~total_casos, y = ~predicciones_negbinom, type = 'scatter', mode = 'markers') %>%
      layout(
        title = "Casos Observados vs. Casos Predichos (Negativa Binomial)",
        xaxis = list(title = "Casos Observados"),
        yaxis = list(title = "Casos Predichos")
      )
  })
  
  # Explicación del resumen del modelo de Negativa Binomial
  output$summary_text <- renderText({
    "Este resumen del modelo de Negativa Binomial muestra los coeficientes estimados, errores estándar, valores z y p-valores asociados. Esto indica la relación entre la temperatura mínima semanal y los casos de dengue."
  })
  
  # Tabla resumen del modelo de Negativa Binomial
  output$summary_tabla <- renderTable({
    as.data.frame(summary(modelo_negbinom)$coefficients)
  })
  
  # Explicación de los coeficientes del modelo
  output$summary_explanation <- renderText({
    "El coeficiente estimado para 'temp_min_semana' muestra que un aumento en la temperatura mínima semanal está asociado con un aumento en los casos de dengue. Un p-valor menor de 0.05 indica que esta relación es estadísticamente significativa."
  })
  
  # Explicación de la ANOVA del modelo de Negativa Binomial
  output$anova_text <- renderText({
    "La tabla de ANOVA muestra los resultados del análisis de la devianza del modelo, indicando la significancia estadística de la temperatura mínima semanal en la predicción de los casos de dengue."
  })
  
  # Tabla de ANOVA para el modelo de Negativa Binomial
  output$anova_tabla <- renderTable({
    as.data.frame(anova(modelo_negbinom, test = "Chisq"))
  })
  
  # Explicación de la ANOVA
  output$anova_explanation <- renderText({
    "La baja devianza residual en comparación con la devianza nula sugiere que el modelo de Negativa Binomial ajusta bien los datos. Un p-valor bajo (< 0.05) para 'temp_min_semana' en la tabla ANOVA indica una influencia significativa en los casos de dengue."
  })
  
  # Explicación de los intervalos de confianza para los coeficientes del modelo de Negativa Binomial
  output$confint_text <- renderText({
    "Los intervalos de confianza para los coeficientes del modelo de Negativa Binomial proporcionan un rango dentro del cual se espera que los coeficientes verdaderos caigan con un 95% de confianza."
  })
  
  # Tabla de intervalos de confianza para los coeficientes del modelo de Negativa Binomial
  output$confint_tabla <- renderTable({
    as.data.frame(confint(modelo_negbinom))
  })
  
  # Explicación de los intervalos de confianza
  output$confint_explanation <- renderText({
    "Un intervalo de confianza estrecho indica precisión en la estimación del coeficiente, lo cual es deseable. El intervalo para 'temp_min_semana' no incluye el valor 0, lo que refuerza la significancia de su influencia en los casos de dengue."
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)
