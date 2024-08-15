# Data Challenge Innovalab

## Descripción del Proyecto
El objetivo de este proyecto es desarrollar un modelo estadístico para evaluar el efecto de la temperatura mínima sobre la incidencia de dengue por semana epidemiológica en los distritos del departamento de Loreto durante los años 2017 a 2022.

Este análisis se ha implementado utilizando R y la aplicación final incluye una interfaz interactiva en Shiny para visualizar los resultados y evaluar el ajuste del modelo.

## Estructura del Repositorio

- `1_data/`: Contiene los datos utilizados en el análisis.
- `2_scripts/`: Scripts R para el procesamiento y análisis de datos.
- `3_results/`: Contiene la aplicación Shiny (`app.R`) que muestra los resultados finales.
- `renv/`: Carpeta para la gestión de dependencias del proyecto.

## Instrucciones de Instalación

1. Clonar este repositorio:
   ```bash
   git clone https://github.com/JoseCebrian12/Data-Challenge-Innovalab
   ```
2. Abrir el proyecto en RStudio
   Abra el archivo Data-Challenge-Innovalab.Rproj para cargar el entorno de trabajo configurado.
4. Restaurar el entorno R con `renv`:
   ```r
   renv::restore()
   ```
## Ejecución de la Aplicación Shiny

Para ejecutar la aplicación Shiny:

1. Navega a la carpeta `3_results/`.
2. Ejecuta el siguiente comando en R:
   ``` r
   shiny::runApp('app.R')
   ```
