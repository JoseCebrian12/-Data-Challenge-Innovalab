url <- "https://www.datosabiertos.gob.pe/sites/default/files/datos_abiertos_vigilancia_dengue.csv"
destfile <- "1_data/datos_abiertos_vigilancia_dengue.csv"

# descargamos el archivo, en caso de tener problemas con el SSL de Windows, el archivo se encuentra en /1_data 
download.file(url = url, destfile = destfile, method = "libcurl")

# mostramos las primeras filas
data <- read.csv(destfile)
head(data)