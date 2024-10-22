# Análisis de la Incidencia de Dengue en Loreto

## Descripción del Proyecto

Este proyecto tiene como objetivo analizar el impacto de la temperatura mínima en la incidencia del dengue en los distritos del departamento de Loreto durante los años 2017 a 2022. Utiliza técnicas de modelado estadístico para evaluar la relación entre variables climáticas y la cantidad de casos de dengue, proporcionando una visualización interactiva que facilita la exploración de los resultados.

Este análisis incluye:
- Modelos de regresión binomial negativa y Poisson para ajustar la relación entre la temperatura y los casos de dengue.
- Análisis de residuos y pruebas de sobredispersión para justificar el uso de modelos de conteo.
- Visualización interactiva para explorar los datos por distrito y la evolución de las variables.

## Estructura del Repositorio

- `1_data/`: Conjunto de datos procesados utilizados en el análisis.
- `2_scripts/`: Scripts de procesamiento, análisis estadístico y visualización de datos utilizando Python.
- `3_results/`: Visualizaciones y resultados obtenidos a partir de los modelos.
- `requirements.txt`: Dependencias necesarias para ejecutar el proyecto.
  
## Instrucciones de Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/JoseCebrian12/Data-Challenge-Innovalab
   ```
2. Instala las dependencias utilizando pip:
   ```bash
   pip install -r requirements.txt
   ```
## Reporte de Modelamiento Estadístico

Para más detalles sobre el análisis de modelamiento estadístico realizado, puedes consultar el siguiente reporte en PDF:

- [Reporte de Modelamiento Estadístico](3_results/statistical_modeling_report.pdf)

## Ejecución de la Aplicación Streamlit

Para visualizar la aplicación interactiva con los resultados del análisis, puedes acceder a la versión desplegada de la aplicación [aquí](https://dengue-loreto-incidence.streamlit.app).

Esto desplegará una aplicación interactiva donde podrás seleccionar el distrito y observar la evolución de los casos de dengue junto con las temperaturas mínimas por semana.

## Tecnologías Utilizadas

- **Python**: Para el procesamiento de datos y análisis estadístico.
- **Streamlit**: Para la creación de una interfaz interactiva.
- **Plotly**: Para la visualización gráfica de los resultados.
- **Pandas**: Para la manipulación de datos.
- **Statsmodels**: Para los modelos de regresión Poisson y Binomial Negativa.
