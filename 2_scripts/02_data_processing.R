# DATASET DENGUE

lines <- readLines("1_data/datos_abiertos_vigilancia_dengue.csv")
lines <- gsub("\\\\,", "|", lines)  
# ocurría un problema con las líneas que contenían 'ENACE I\,II\,III', por lo que se cambia esto para no perder estas filas
writeLines(lines, "1_data/datos_abiertos_vigilancia_dengue.csv")
dengue <- read.csv("1_data/datos_abiertos_vigilancia_dengue.csv", fill = TRUE)

# Revisamos los datos
str(dengue)
summary(dengue)

# Convertir 'ano' y 'semana' a numérico
dengue$ano <- as.numeric(dengue$ano)
dengue$semana <- as.numeric(dengue$semana)

library(dplyr)

# Filtrar los datos de Loreto y agrupar
dengue_loreto <- dengue %>%
  filter(departamento == "LORETO") %>%
  group_by(ano, semana, distrito) %>%
  summarize(total_casos = n(), .groups = 'drop')

# Crear un marco de datos con todas las combinaciones de año, semana y distrito
all_weeks <- expand.grid(
  ano = unique(dengue_loreto$ano),
  semana = 1:53,
  distrito = unique(dengue_loreto$distrito)
)

# Unir con los datos de dengue y rellenar con 0 los casos faltantes
dengue_loreto_completo <- all_weeks %>%
  left_join(dengue_loreto, by = c("ano", "semana", "distrito")) %>%
  mutate(total_casos = ifelse(is.na(total_casos), 0, total_casos))

# Revisar el resultado
head(dengue_loreto_completo)

# RESTO DE DATASETS

districts <- read.csv("1_data/districts_2017census.csv")
population <- read.csv("1_data/population_2017-2022.csv")
temperature <- read.csv("1_data/mintemp_20170101-20221231.csv")

str(districts)
summary(districts)

# Filtrar los distritos de Loreto
loreto_districts <- districts %>% filter(departmento == "LORETO")

# Unificar nombres en el dataset de población
population <- population %>%
  rename(ano = year)

library(tidyr)

# Formato largo para el dataset de temperatura
temperature_long <- pivot_longer(temperature, 
                                 cols = starts_with("mintemp_"), 
                                 names_to = "date", 
                                 names_prefix = "mintemp_",
                                 values_to = "temperature")
temperature_long$date <- as.Date(temperature_long$date, format="%Y%m%d")

# Agregar semana epidemiológica
temperature_long$semana <- as.numeric(format(temperature_long$date + 1, "%V")) 
temperature_long$ano <- as.numeric(format(temperature_long$date, "%Y"))

table(temperature_long$semana)
table(dengue_loreto_completo$semana)
