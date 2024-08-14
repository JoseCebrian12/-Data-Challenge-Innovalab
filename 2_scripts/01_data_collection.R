# Definir la URL y la ruta donde se guardará el archivo
url <- "http://www.datosabiertos.gob.pe/sites/default/files/datos_abiertos_vigilancia_dengue.csv"
destfile <- "data/datos_abiertos_vigilancia_dengue.csv"

# Descargar el archivo usando libcurl para evitar problemas de SSL
download.file(url = url, destfile = destfile, method = "libcurl")
