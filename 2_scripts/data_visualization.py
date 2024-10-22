import streamlit as st
import pandas as pd
import plotly.graph_objs as go

# Cargar el dataset
df = pd.read_csv("1_data/dengue_temp_population_loreto.csv")

# Calcular la suma de los casos y la media de la temperatura mínima por semana para todos los distritos
df_totales = df.groupby(['ano', 'semana']).agg({
    'total_casos': 'sum',    # Sumar los casos
    'temp_min_semana': 'mean'  # Promediar la temperatura mínima
}).reset_index()

# Crear una columna 'distrito' con el valor "TODOS"
df_totales['distrito'] = 'TODOS'

# Unir los datos sumados al dataset original
df = pd.concat([df, df_totales], ignore_index=True)

# Identificar los años que tienen 53 semanas
years_with_53_weeks = df.groupby('ano')['semana'].max()
years_with_53_weeks = years_with_53_weeks[years_with_53_weeks == 53].index.tolist()

# Ajustar la columna 'semana_continua' teniendo en cuenta los años con 53 semanas
df['semana_continua'] = df.apply(lambda row: (row['ano'] - df['ano'].min()) * 52 + row['semana']
                                  if row['ano'] not in years_with_53_weeks 
                                  else (row['ano'] - df['ano'].min()) * 53 + row['semana'], axis=1)

# Ordenar el dataset para que 'TODOS' esté primero en la lista
df['distrito'] = pd.Categorical(df['distrito'], categories=['TODOS'] + [x for x in df['distrito'].unique() if x != 'TODOS'], ordered=True)
df = df.sort_values(by=['ano', 'semana', 'distrito']).reset_index(drop=True)

# Título
st.title("Evolución de casos de dengue y temperatura mínima en Loreto (2017 - 2022)")

# Dropdown para seleccionar el distrito
distrito_seleccionado = st.selectbox(
    "Selecciona el distrito:",
    df['distrito'].unique(),
    index=list(df['distrito'].unique()).index('TODOS')  # Inicialmente "TODOS"
)

# Filtrar el dataframe por el distrito seleccionado
df_distrito = df[df['distrito'] == distrito_seleccionado]
df_distrito = df_distrito.sort_values(by=['ano', 'semana']).reset_index(drop=True)

# Crear la columna 'semana_continua'
df_distrito['semana_continua'] = (df_distrito['ano'] - df_distrito['ano'].min()) * 52 + df_distrito['semana']

# Crear la figura con Plotly
fig = go.Figure()

# Añadir traza de casos de dengue
fig.add_trace(go.Scatter(
    x=df_distrito['semana_continua'], 
    y=df_distrito['total_casos'], 
    name=f'Casos de {distrito_seleccionado}',
    yaxis='y1',
    hovertext=(df_distrito['ano'].astype(str) + " | Semana: " + df_distrito['semana'].astype(str) +
               " | Casos: " + df_distrito['total_casos'].astype(str))
))

# Añadir traza de temperatura mínima
fig.add_trace(go.Scatter(
    x=df_distrito['semana_continua'], 
    y=df_distrito['temp_min_semana'], 
    name=f'Temperatura mínima {distrito_seleccionado}',
    yaxis='y2',
    line=dict(dash='dot', color='red'),
    hovertext=(df_distrito['ano'].astype(str) + " | Semana: " + df_distrito['semana'].astype(str) +
               " | Temp Min: " + df_distrito['temp_min_semana'].round(2).astype(str))
))

# Configurar el layout del gráfico
fig.update_layout(
    yaxis=dict(title="Total de casos de dengue"),
    yaxis2=dict(title="Temperatura mínima (°C)", overlaying='y', side='right'),
    title=f'Evolución en {distrito_seleccionado}',
    hovermode="x unified",
    xaxis=dict(showticklabels=False)  # Ocultar etiquetas en el eje X
)

# Mostrar el gráfico en Streamlit
st.plotly_chart(fig)