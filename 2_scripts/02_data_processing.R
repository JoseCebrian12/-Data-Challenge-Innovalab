# DATASET DENGUE

lines <- readLines("1_data/datos_abiertos_vigilancia_dengue.csv")
lines <- gsub("\\\\,", "|", lines)  
# ocurria un problema con las líneas que contenían 'ENACE I\,II\,III', por lo que se cambia esto para no perder estas filas
writeLines(lines, "1_data/datos_abiertos_vigilancia_dengue.csv")
dengue <- read.csv("1_data/datos_abiertos_vigilancia_dengue.csv", fill = TRUE)

# revisamos los datos
str(dengue)
summary(dengue)

# 'ano' y 'semana' a numérico
dengue$ano <- as.numeric(dengue$ano)
dengue$semana <- as.numeric(dengue$semana)

library(dplyr)
# total de casos por año, semana epidemiológica y distrito
dengue_loreto <- dengue %>%
  filter(departamento == "LORETO") %>%
  group_by(ano, semana, distrito) %>%
  summarize(total_casos = n(), .groups = 'drop')

head(dengue_loreto)

# RESTO DE DATASETS

districts <- read.csv("1_data/districts_2017census.csv")
population <- read.csv("1_data/population_2017-2022.csv")
temperature <- read.csv("1_data/mintemp_20170101-20221231.csv")

str(districts)
summary(districts)

loreto_districts <- districts %>% filter(departmento == "LORETO")

str(population)
summary(population)
population <- population %>%
  rename(ano = year)

library(tidyr)
#formato largo
temperature_long <- pivot_longer(temperature, 
                                 cols = starts_with("mintemp_"), 
                                 names_to = "date", 
                                 names_prefix = "mintemp_",
                                 values_to = "temperature")
temperature_long$date <- as.Date(temperature_long$date, format="%Y%m%d")

# agregar semana epidemiológica
temperature_long$semana <- as.numeric(format(temperature_long$date + 1, "%V")) 
temperature_long$ano <- as.numeric(format(temperature_long$date, "%Y"))

table(temperature_long$semana)
table(dengue_summary$semana)