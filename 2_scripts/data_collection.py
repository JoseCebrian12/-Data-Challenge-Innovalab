import os
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

url = "https://www.datosabiertos.gob.pe/sites/default/files/datos_abiertos_vigilancia_dengue.csv"
destfile = "1_data/datos_abiertos_vigilancia_dengue2.csv"

# Configurar los reintentos automáticos y el timeout
session = requests.Session()
retry = Retry(
    total=5,  # Número total de intentos
    backoff_factor=1,  # Tiempo de espera incremental entre intentos
    status_forcelist=[500, 502, 503, 504],  # Errores en los que se debe intentar de nuevo
)
adapter = HTTPAdapter(max_retries=retry)
session.mount("http://", adapter)
session.mount("https://", adapter)

# Verificar si hay un archivo parcial descargado
def download_file():
    if os.path.exists(destfile):
        mode = 'ab'  # Append mode (continuar donde se dejó)
        downloaded_bytes = os.path.getsize(destfile)
    else:
        mode = 'wb'  # Si no existe, comenzamos desde cero
        downloaded_bytes = 0

    headers = {"Range": f"bytes={downloaded_bytes}-"}  # Solicitar la parte faltante

    try:
        with session.get(url, headers=headers, stream=True, timeout=60) as response:
            response.raise_for_status()
            with open(destfile, mode) as f:
                for chunk in response.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)
        print(f"Descargados {downloaded_bytes + os.path.getsize(destfile)} bytes hasta el momento.")
        return True  # La descarga fue exitosa
    except requests.exceptions.RequestException as e:
        print(f"Error al descargar el archivo: {e}")
        return False  # Hubo un error, intenta de nuevo

# Bucle que continúa hasta que se descargue todo el archivo
completed = False
while not completed:
    completed = download_file()

print("Descarga completada correctamente.")