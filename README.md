Aquí tienes una versión mejorada de tu README, con ajustes para mayor claridad y presentación:

---

# Análisis de la Incidencia de Dengue en Loreto

## Descripción del Proyecto

Este proyecto tiene como objetivo analizar la relación entre la temperatura mínima y la incidencia del dengue en los distritos del departamento de Loreto, Perú, durante los años 2017 a 2022. El análisis utiliza técnicas avanzadas de modelado estadístico para evaluar cómo las variables climáticas afectan la cantidad de casos de dengue, y proporciona una **visualización interactiva** que facilita la exploración de estos resultados.

### Principales características del análisis:
- **Modelos estadísticos**: Se implementaron modelos de **regresión binomial negativa** y **Poisson** para ajustar la relación entre la temperatura mínima semanal y los casos de dengue.
- **Evaluación del ajuste**: Se realizaron análisis de residuos y pruebas de sobredispersión para determinar el mejor modelo de conteo.
- **Visualización interactiva**: Los resultados se presentan en una aplicación que permite explorar los datos por distrito y observar la evolución temporal de las variables.

## Estructura del Repositorio

- `1_data/`: Contiene los datos procesados utilizados en el análisis.
- `2_scripts/`: Scripts para la recolección, procesamiento y análisis de los datos, así como para la visualización.
- `3_results/`: Resultados y visualizaciones generadas a partir de los modelos.
- `requirements.txt`: Archivo con las dependencias necesarias para ejecutar el proyecto.

## Instrucciones de Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/JoseCebrian12/Data-Challenge-Innovalab
   ```
2. Instala las dependencias necesarias:
   ```bash
   pip install -r requirements.txt
   ```

## Reporte de Modelamiento Estadístico

Para obtener un análisis detallado del modelado estadístico, puedes consultar el siguiente reporte en formato PDF:

- [Reporte de Modelamiento Estadístico](3_results/statistical_modeling_report.pdf)

## Ejecución de la Aplicación Interactiva

Puedes acceder a la versión desplegada de la aplicación **Streamlit** para visualizar los resultados del análisis en tiempo real a través del siguiente enlace:

- [Aplicación Streamlit - Incidencia de Dengue en Loreto](https://dengue-loreto-incidence.streamlit.app)

En la aplicación, podrás seleccionar un distrito y explorar la evolución semanal de los casos de dengue junto con las temperaturas mínimas durante los años 2017-2022.

## Tecnologías Utilizadas

- **Python**: Procesamiento de datos y análisis estadístico.
- **Streamlit**: Desarrollo de la interfaz interactiva.
- **Plotly**: Visualización gráfica de los resultados.
- **Pandas**: Manipulación y análisis de datos.
- **Statsmodels**: Implementación de los modelos de regresión Poisson y Binomial Negativa.
- **Requests**: Recolección de datos desde fuentes externas.

## Scripts de Análisis

### `data_collection.py`
Este script descarga los datos abiertos de vigilancia del dengue desde la web del gobierno peruano. Utiliza un mecanismo de reintentos automáticos para asegurar la descarga completa, incluso si se interrumpe.

### `data_processing.py`
Este script procesa los datos crudos, corrige errores en los formatos, y prepara el conjunto de datos con casos de dengue, datos de temperatura mínima y población. También incluye la generación de desfases (lags) en las variables climáticas para el análisis posterior.

### `data_integration.py`
Combina los datos procesados de dengue, temperatura y población. Además, genera variables con desfases de la temperatura mínima para cada distrito, permitiendo estudiar su efecto acumulado.

### `data_visualization.py`
Contiene la lógica para la creación de la visualización interactiva en Streamlit. Los usuarios pueden seleccionar distritos específicos para visualizar la evolución semanal de los casos de dengue y la temperatura mínima.

### `statistical_modeling.ipynb`
Un notebook de Jupyter que desarrolla el análisis de los modelos de Poisson y Binomial Negativo. Aquí se evalúan los coeficientes de los modelos, se comparan mediante el AIC, y se visualizan los residuos para verificar el ajuste.
