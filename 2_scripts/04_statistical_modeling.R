# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(broom)

# Usar el conjunto de datos final del ejercicio anterior
# Asegúrate de que final_data contiene las columnas: ano, semana, distrito, total_casos, temp_min_semana

# Crear un modelo de regresión lineal generalizada (GLM) con una familia Poisson
modelo_dengue <- glm(total_casos ~ temp_min_semana, 
                     data = final_data, 
                     family = poisson(link = "log"))

# Resumen del modelo
summary(modelo_dengue)

# Chequear el ajuste del modelo visualizando los residuos
par(mfrow = c(2, 2))
plot(modelo_dengue)

# Predicciones del modelo
final_data$predicted_cases <- predict(modelo_dengue, type = "response")

# Graficar casos observados vs. casos predichos
ggplot(final_data, aes(x = total_casos, y = predicted_cases)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(x = "Casos Observados", y = "Casos Predichos", 
       title = "Casos Observados vs. Casos Predichos por el Modelo") +
  theme_minimal()

# Graficar la relación entre temperatura mínima y número de casos
ggplot(final_data, aes(x = temp_min_semana, y = total_casos)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = "poisson"), color = "blue") +
  labs(x = "Temperatura Mínima Semanal", y = "Casos de Dengue", 
       title = "Relación entre Temperatura Mínima y Casos de Dengue") +
  theme_minimal()

# Guardar las tablas de coeficientes y ajuste del modelo
coeficientes <- tidy(modelo_dengue)
ajuste_modelo <- glance(modelo_dengue)

# Imprimir tablas
print(coeficientes)
print(ajuste_modelo)
