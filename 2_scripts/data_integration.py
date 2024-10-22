from data_processing import dengue_loreto, temperature, population

# Unir los datasets, calcular la temperatura mínima, máxima y media por semana
dengue_temp_population_loreto = (dengue_loreto
              .merge(temperature, on=['ano', 'semana', 'ubigeo'], how='inner')  # Cambiar a left join para no perder semanas
              .merge(population, on=['ubigeo', 'ano'], how='inner')  # También hacer un left join con la población
              .groupby(['ano', 'semana', 'distrito', 'ubigeo'])
              .agg(total_casos=('total_casos', 'first'),
                   temp_min_semana=('temperature', 'min'),
                   population=('population', 'first'))
              .reset_index()
              .query('2017 <= ano <= 2022'))  # Filtrar por los años 2017 a 2022

# Convertir a entero los casos de dengue, si no hay valores NaN en 'total_casos'
dengue_temp_population_loreto['total_casos'] = dengue_temp_population_loreto['total_casos'].astype(int)

# Calcular variables de temperatura mínima con desfase para cada distrito
for lag in range(1, 8):
    dengue_temp_population_loreto[f'temp_min_lag{lag}'] = dengue_temp_population_loreto.groupby('distrito')['temp_min_semana'].shift(lag)
    
dengue_temp_population_loreto.to_csv("1_data/dengue_temp_population_loreto.csv", index=False)