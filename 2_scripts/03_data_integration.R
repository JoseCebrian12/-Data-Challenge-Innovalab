# unir los datos de dengue con los distritos de Loreto
merged_data <- dengue_loreto_completo %>%
  inner_join(loreto_districts, by = "distrito")

# unir los datasets, calcular la temperatura mínima por semana y filtrar los datos según el objetivo analítico
final_data <- merged_data %>%
  inner_join(temperature_long, by = c("ano", "semana", "ubigeo")) %>%
  inner_join(population, by = c("ubigeo", "ano")) %>%
  group_by(ano, semana, distrito) %>%
  summarize(total_casos = first(total_casos), 
            temp_min_semana = min(temperature, na.rm = TRUE),
            population = first(population), .groups = 'drop') %>%
  filter(ano >= 2017 & ano <= 2022) 

head(final_data)