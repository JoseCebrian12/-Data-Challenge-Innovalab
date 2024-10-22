import pandas as pd
import numpy as np
from epiweeks import Week

# Abrir el archivo CSV como texto
with open("1_data/datos_abiertos_vigilancia_dengue.csv", "r", encoding="utf-8") as file:
    lines = file.readlines()

# Buscar y reemplazar el patrón que tiene comas internas
with open("1_data/datos_abiertos_vigilancia_dengue.csv", "w", encoding="utf-8") as file:
    for line in lines:
        # Reemplazar cualquier ocurrencia de "ENACE I\,II\,III" con la versión entre comillas dobles
        corrected_line = line.replace("ENACE I\\,II\\,III", '"ENACE I, II, III"')
        # Puedes añadir más reemplazos si hay otros patrones similares
        file.write(corrected_line)

# Leer el archivo corregido con pandas
df = pd.read_csv("1_data/datos_abiertos_vigilancia_dengue.csv",
                 quotechar='"',
                 dtype={'localcod': str})

df['departamento'] = df['departamento'].replace('\\N', np.nan)

df_ubigeos_correctos = df[df['ubigeo'] != 999999].groupby('localidad').first().reset_index()
df.loc[df['ubigeo'] == 999999, 'ubigeo'] = df.loc[df['ubigeo'] == 999999, 'localidad'].map(df_ubigeos_correctos.set_index('localidad')['ubigeo'])
df = df.dropna(subset=['ubigeo'])

df.loc[df['edad'] > 106, 'edad'] = np.nan

# Agrupar por año, semana, distrito y ubigeo
dengue_loreto = (df[df['departamento'] == "LORETO"]
                 .groupby(['ano', 'semana', 'distrito', 'ubigeo'])
                 .size()
                 .reset_index(name='total_casos'))
# Crear un marco de datos con todas las combinaciones de año, semana y distrito
all_weeks = pd.MultiIndex.from_product(
    [dengue_loreto['ano'].unique(), range(1, 54), dengue_loreto['distrito'].unique()],
    names=['ano', 'semana', 'distrito']
).to_frame(index=False)

# Unir el marco de semanas con el mapeo correcto de distritos y ubigeos
distrito_ubigeo_map = dengue_loreto[['distrito', 'ubigeo']].drop_duplicates()
all_weeks = all_weeks.merge(distrito_ubigeo_map, on='distrito', how='left')

# Unir con los datos de dengue y rellenar con 0 los casos faltantes
dengue_loreto = (all_weeks
                 .merge(dengue_loreto, how='left', on=['ano', 'semana', 'distrito', 'ubigeo'])
                 .fillna({'total_casos': 0}))

population = pd.read_csv("1_data/population_2017-2022.csv")

# Unificar nombres en el dataset de población
population = population.rename(columns={'year': 'ano'})

temperature = pd.read_csv("1_data/mintemp_20170101-20221231.csv")

temperature = pd.melt(temperature, 
                      id_vars=['ubigeo'], 
                      value_vars=[col for col in temperature.columns if col.startswith("mintemp_")],
                      var_name="date", 
                      value_name="temperature")

temperature['date'] = pd.to_datetime(temperature['date'].str.replace("mintemp_", ""), format='%Y%m%d')

def get_epiweek(date):
    return Week.fromdate(date).week

temperature['semana'] = temperature['date'].apply(get_epiweek)
temperature['ano'] = temperature['date'].dt.year