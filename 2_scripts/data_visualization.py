import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import plotly.graph_objs as go
import pandas as pd

# Cargar los datos
df = pd.read_csv("1_data/dengue_temp_population_loreto.csv")

# Calcular los totales (tal como lo hiciste)
df_totales = df.groupby(['ano', 'semana']).agg({
    'total_casos': 'sum',
    'temp_min_semana': 'mean'
}).reset_index()

df_totales['distrito'] = 'TODOS'
df = pd.concat([df, df_totales], ignore_index=True)

# Aplicación Dash
app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1("Evolución de casos de dengue y temperatura mínima en Loreto (2017 - 2022)"),
    dcc.Dropdown(
        id='distrito-dropdown',
        options=[{'label': d, 'value': d} for d in df['distrito'].unique()],
        value='TODOS'  # Inicialmente "TODOS"
    ),
    dcc.Graph(id='dengue-graph')
])

@app.callback(
    Output('dengue-graph', 'figure'),
    [Input('distrito-dropdown', 'value')]
)
def update_graph(distrito_seleccionado):
    df_distrito = df[df['distrito'] == distrito_seleccionado]
    df_distrito = df_distrito.sort_values(by=['ano', 'semana']).reset_index(drop=True)
    df_distrito['semana_continua'] = (df_distrito['ano'] - df_distrito['ano'].min()) * 52 + df_distrito['semana']

    fig = go.Figure()
    fig.add_trace(go.Scatter(x=df_distrito['semana_continua'], 
                             y=df_distrito['total_casos'], 
                             name=f'Casos de {distrito_seleccionado}', 
                             yaxis='y1'))

    fig.add_trace(go.Scatter(x=df_distrito['semana_continua'], 
                             y=df_distrito['temp_min_semana'], 
                             name=f'Temperatura mínima {distrito_seleccionado}', 
                             yaxis='y2', 
                             line=dict(dash='dot', color='red')))

    fig.update_layout(
        yaxis=dict(title="Total de casos de dengue"),
        yaxis2=dict(title="Temperatura mínima (°C)", overlaying='y', side='right'),
        title=f'Evolución en {distrito_seleccionado}',
        hovermode="x unified"
    )

    return fig

if __name__ == '__main__':
    app.run_server(debug=True)