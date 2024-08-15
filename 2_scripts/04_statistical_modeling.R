# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(lme4)
library(MASS)
library(lmtest)

# poisson
modelo_poisson <- glm(total_casos ~ temp_min_semana, data = final_data, family = poisson())

# GLMM
modelo_glmm <- glmer(total_casos ~ temp_min_semana + (1 | distrito), data = final_data, family = poisson())

# negativa binomial
modelo_negbinom <- glm.nb(total_casos ~ temp_min_semana, data = final_data)

summary(modelo_poisson)
summary(modelo_glmm)
summary(modelo_negbinom)

# evaluación de la heterocedasticidad
bptest_poisson <- bptest(modelo_poisson)
print(bptest_poisson)

# comparar AIC 
aic_poisson <- AIC(modelo_poisson)
aic_glmm <- AIC(modelo_glmm)
aic_negbinom <- AIC(modelo_negbinom)

cat("AIC Modelo Poisson: ", aic_poisson, "\n")
cat("AIC Modelo GLMM: ", aic_glmm, "\n")
cat("AIC Modelo Negativa Binomial: ", aic_negbinom, "\n")

# Diagnóstico del modelo GLMM: gráficos de residuos
plot(modelo_glmm)

# Gráfico de dispersión entre casos y temperatura con la curva ajustada para GLMM
ggplot(final_data, aes(x = temp_min_semana, y = total_casos)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "glm", method.args = list(family = "poisson"), col = "blue") +
  labs(title = "Relación entre Temperatura Mínima y Casos de Dengue",
       x = "Temperatura Mínima Semanal (°C)",
       y = "Total Casos de Dengue") +
  theme_minimal()

# predicciones y gráfico comparativo entre valores observados y ajustados para todos los modelos
final_data$predicciones_poisson <- predict(modelo_poisson, type = "response")
final_data$predicciones_glmm <- predict(modelo_glmm, type = "response")
final_data$predicciones_negbinom <- predict(modelo_negbinom, type = "response")

ggplot(final_data, aes(x = total_casos)) +
  geom_point(aes(y = predicciones_poisson), color = "blue", alpha = 0.5) +
  geom_point(aes(y = predicciones_glmm), color = "green", alpha = 0.5) +
  geom_point(aes(y = predicciones_negbinom), color = "orange", alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1, col = "red") +
  labs(title = "Comparación de Casos Observados vs. Predicciones",
       x = "Casos Observados",
       y = "Casos Predichos") +
  theme_minimal() +
  scale_y_continuous(sec.axis = sec_axis(~ ., name = "Predicciones por Modelo")) +
  guides(colour = guide_legend(title = "Modelos"))

# evaluación y selección del mejor modelo según AIC y gráficos de diagnóstico

# gráfico de residuos para evaluar la calidad del ajuste del modelo de Negativa Binomial
ggplot(final_data, aes(x = predicciones_negbinom, y = residuals(modelo_negbinom, type = "pearson"))) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Residuos vs Predicciones (Negativa Binomial)",
       x = "Predicciones (Negativa Binomial)",
       y = "Residuos Pearson") +
  theme_minimal()

# tabla comparativa de los modelos
tabla_modelos <- data.frame(
  Modelo = c("Poisson", "GLMM", "Negativa Binomial"),
  AIC = c(aic_poisson, aic_glmm, aic_negbinom)
)
print(tabla_modelos)
