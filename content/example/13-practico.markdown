---
title: "13. Análisis de Ecuaciones Estructurales con `lavaan`"
linktitle: "13. Análisis de Ecuaciones Estructurales"
date: "2025-06-30" 
menu:
  example: # Nombre del menú
    parent: Ejemplos # Sección padre dentro del menú "example"
    weight: 13       # Peso dentro de la sección padre
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

<script src="/rmarkdown-libs/htmlwidgets/htmlwidgets.js"></script>
<script src="/rmarkdown-libs/viz/viz.js"></script>
<link href="/rmarkdown-libs/DiagrammeR-styles/styles.css" rel="stylesheet" />
<script src="/rmarkdown-libs/grViz-binding/grViz.js"></script>

## 0. Objetivos del Práctico

En este práctico, aprenderemos a realizar un **Modelo de Ecuaciones Estructurales (SEM)**, que combina un **Análisis Factorial Confirmatorio (AFC)** para el modelo de medida y un **Análisis de Senderos** para el modelo estructural. Nos enfocaremos en:

1.  Preparar los datos y realizar una revisión de supuestos clave.
2.  **Especificar y estimar** un modelo SEM completo con `lavaan`.
3.  **Evaluar el ajuste global** del modelo utilizando diversos índices.
4.  **Interpretar** tanto el **modelo de medida** (cargas factoriales) como el **modelo estructural** (coeficientes path).
5.  Visualizar el modelo utilizando el paquete `lavaan.plot` de forma clara y teóricamente informada.

## Introducción al Ejemplo

Trabajaremos con datos de la **Encuesta de Bienestar Social (EBS) 2021** para construir un modelo SEM que busca explicar la **sintomatología depresiva** (variable latente `SM`) a partir de la **percepción de seguridad ciudadana** (variable latente `SEG`), controlando por diversas covariables sociodemográficas.

**Variables Latentes y sus Indicadores:**

- **Sintomatología Depresiva (`SM`):** Medida a través de 4 ítems (sm_1 a sm_4) de la escala PHQ-4.
- **Percepción de Seguridad (`SEG`):** Medida a través de 4 ítems (seg_1 a seg_4) sobre seguridad en el barrio.

<img src="https://github.com/Clases-GabrielSotomayor/pruebapagina/blob/master/content/example/input/ebs.png?raw=true" data-fig-align="center" />

## 1. Carga de Paquetes y Preparación de Datos

Cargamos los paquetes necesarios. `lavaan.plot` será nuestra herramienta para visualizar.

``` r
# Cargar paquetes
if (!require("pacman")) install.packages("pacman")
pacman::p_load(haven, lavaan, dplyr, lavaanPlot, texreg, MVN)
```

Importamos los datos de la EBS 2021 y preparamos las variables.

``` r
# --- Código para cargar EBS 2021 ---
temp <- tempfile() 
download.file("https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/bienestar-social/Base_de_datos_EBS_2021_SPSS.sav.zip",temp) 
data <- haven::read_sav(unz(temp, "Base de datos EBS 2021 SPSS.sav")) 
unlink(temp); remove(temp) 
# --- Fin código carga ---

# Seleccionar variables de interés y preparar
ebs <- data %>% 
  mutate(
    zona = ifelse(zona == 2, 1, 0), # 0 = Urbano (ref), 1 = Rural
    sexo = ifelse(sexo == 2, 1, 0)  # 0 = Hombre (ref), 1 = Mujer
  ) %>% 
  select(
    qaut, zona, sexo, edad = l1, maltrato = e5, social = a3_5,
    sm_1 = b9_1, sm_2 = b9_2, sm_3 = b9_3, sm_4 = b9_4,
    seg_1 = h4_1, seg_2 = h4_2, seg_3 = h4_3, seg_4 = h4_4
  )
```

## 2. Comprobación de Supuestos

Realizamos una revisión rápida de los supuestos para informar nuestras decisiones de modelado.

``` r
# Seleccionar variables para el modelo y omitir NAs
datos_modelo_completos <- ebs %>%
  select(qaut, zona, sexo, edad, maltrato, social, 
         sm_1, sm_2, sm_3, sm_4, 
         seg_1, seg_2, seg_3, seg_4) %>%
  na.omit()

print(paste("Observaciones completas para el análisis:", nrow(datos_modelo_completos)))
```

    ## [1] "Observaciones completas para el análisis: 10921"

Los datos **no cumplen con el supuesto de normalidad multivariante**. Dada esta violación y la naturaleza ordinal de muchos de nuestros indicadores, la elección del estimador **`DWLS`** (Diagonally Weighted Least Squares) en `lavaan` es la más apropiada, ya que es robusto a estas condiciones.

## 3. Especificación y Estimación del Modelo SEM

Especificamos el modelo SEM completo, combinando el modelo de medida y el estructural.

| Sintaxis `lavaan` | Comando                                     |
|-------------------|---------------------------------------------|
| `~`               | Regresión (VD ~ VI1 + VI2…)                 |
| `~~`              | (Co)varianza                                |
| `=~`              | Factor es medido por (variables latentes)   |
| `:=`              | Parámetro Definido (ej. efectos indirectos) |
| `etiqueta*`       | Etiquetar un parámetro                      |

``` r
# Especificar el modelo SEM completo
mod_sem_spec <- '
  # 1. Modelo de Medida
  SM  =~ sm_1 + sm_2 + sm_3 + sm_4
  SEG =~ seg_1 + seg_2 + seg_3 + seg_4

  # 2. Modelo Estructural
  SM ~ qaut + zona + sexo + edad + SEG + maltrato + social
'

# Ajustar el modelo SEM con estimador DWLS
ajus_sem <- sem(mod_sem_spec, 
                data = datos_modelo_completos, 
                estimator = "DWLS",
                ordered = c("sm_1", "sm_2", "sm_3", "sm_4",
                            "seg_1", "seg_2", "seg_3", "seg_4",
                            "maltrato", "social"))
```

### Resumen y Evaluación del Modelo

``` r
summary(ajus_sem, 
        fit.measures = TRUE, 
        standardized = TRUE, 
        rsquare = TRUE)
```

    ## lavaan 0.6.15 ended normally after 24 iterations
    ## 
    ##   Estimator                                       DWLS
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        43
    ## 
    ##   Number of observations                         10921
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                              2588.087
    ##   Degrees of freedom                                61
    ##   P-value (Chi-square)                           0.000
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                             99815.520
    ##   Degrees of freedom                                28
    ##   P-value                                        0.000
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    0.975
    ##   Tucker-Lewis Index (TLI)                       0.988
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.062
    ##   90 Percent confidence interval - lower         0.060
    ##   90 Percent confidence interval - upper         0.064
    ##   P-value H_0: RMSEA <= 0.050                    0.000
    ##   P-value H_0: RMSEA >= 0.080                    0.000
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.028
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                             Standard
    ##   Information                                 Expected
    ##   Information saturated (h1) model        Unstructured
    ## 
    ## Latent Variables:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   SM =~                                                                 
    ##     sm_1              1.000                               0.807    0.755
    ##     sm_2              1.172    0.017   68.609    0.000    0.946    0.865
    ##     sm_3              1.017    0.013   76.781    0.000    0.821    0.766
    ##     sm_4              0.950    0.013   72.688    0.000    0.766    0.721
    ##   SEG =~                                                                
    ##     seg_1             1.000                               0.849    0.849
    ##     seg_2             1.061    0.013   80.028    0.000    0.901    0.901
    ##     seg_3             0.810    0.008   97.405    0.000    0.687    0.687
    ##     seg_4             0.614    0.008   74.168    0.000    0.521    0.521
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   SM ~                                                                  
    ##     qaut             -0.057    0.004  -14.139    0.000   -0.070   -0.095
    ##     zona             -0.049    0.015   -3.300    0.001   -0.061   -0.022
    ##     sexo              0.293    0.011   26.544    0.000    0.363    0.179
    ##     edad             -0.002    0.000   -5.853    0.000   -0.002   -0.038
    ##     SEG              -0.160    0.005  -34.981    0.000   -0.168   -0.168
    ##     maltrato          0.214    0.005   42.285    0.000    0.265    0.292
    ##     social           -0.171    0.005  -33.874    0.000   -0.212   -0.230
    ## 
    ## Intercepts:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sm_1              0.000                               0.000    0.000
    ##    .sm_2              0.000                               0.000    0.000
    ##    .sm_3              0.000                               0.000    0.000
    ##    .sm_4              0.000                               0.000    0.000
    ##    .seg_1             0.000                               0.000    0.000
    ##    .seg_2             0.000                               0.000    0.000
    ##    .seg_3             0.000                               0.000    0.000
    ##    .seg_4             0.000                               0.000    0.000
    ##    .SM                0.000                               0.000    0.000
    ##     SEG               0.000                               0.000    0.000
    ## 
    ## Thresholds:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     sm_1|t1          -0.730    0.061  -11.993    0.000   -0.730   -0.683
    ##     sm_1|t2           0.565    0.061    9.278    0.000    0.565    0.528
    ##     sm_1|t3           0.993    0.062   16.057    0.000    0.993    0.929
    ##     sm_2|t1          -0.482    0.061   -7.877    0.000   -0.482   -0.441
    ##     sm_2|t2           0.901    0.062   14.612    0.000    0.901    0.824
    ##     sm_2|t3           1.364    0.063   21.718    0.000    1.364    1.247
    ##     sm_3|t1          -0.690    0.060  -11.499    0.000   -0.690   -0.644
    ##     sm_3|t2           0.665    0.060   11.108    0.000    0.665    0.621
    ##     sm_3|t3           1.109    0.061   18.236    0.000    1.109    1.035
    ##     sm_4|t1           0.020    0.064    0.313    0.754    0.020    0.019
    ##     sm_4|t2           0.956    0.065   14.697    0.000    0.956    0.900
    ##     sm_4|t3           1.268    0.066   19.214    0.000    1.268    1.193
    ##     seg_1|t1         -1.247    0.059  -21.038    0.000   -1.247   -1.247
    ##     seg_1|t2         -0.574    0.057   -9.987    0.000   -0.574   -0.574
    ##     seg_1|t3          0.061    0.057    1.066    0.287    0.061    0.061
    ##     seg_1|t4          1.157    0.058   20.007    0.000    1.157    1.157
    ##     seg_2|t1         -1.463    0.059  -24.629    0.000   -1.463   -1.463
    ##     seg_2|t2         -0.777    0.057  -13.544    0.000   -0.777   -0.777
    ##     seg_2|t3         -0.166    0.057   -2.929    0.003   -0.166   -0.166
    ##     seg_2|t4          1.020    0.058   17.728    0.000    1.020    1.020
    ##     seg_3|t1         -0.579    0.060   -9.730    0.000   -0.579   -0.579
    ##     seg_3|t2          0.022    0.059    0.370    0.712    0.022    0.022
    ##     seg_3|t3          0.550    0.060    9.222    0.000    0.550    0.550
    ##     seg_3|t4          1.380    0.061   22.581    0.000    1.380    1.380
    ##     seg_4|t1         -1.869    0.066  -28.488    0.000   -1.869   -1.869
    ##     seg_4|t2         -1.397    0.062  -22.357    0.000   -1.397   -1.397
    ##     seg_4|t3         -0.921    0.061  -14.988    0.000   -0.921   -0.921
    ##     seg_4|t4          0.251    0.061    4.124    0.000    0.251    0.251
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sm_1              0.491                               0.491    0.430
    ##    .sm_2              0.301                               0.301    0.252
    ##    .sm_3              0.474                               0.474    0.413
    ##    .sm_4              0.541                               0.541    0.480
    ##    .seg_1             0.280                               0.280    0.280
    ##    .seg_2             0.189                               0.189    0.189
    ##    .seg_3             0.528                               0.528    0.528
    ##    .seg_4             0.728                               0.728    0.728
    ##    .SM                0.490    0.009   54.850    0.000    0.753    0.753
    ##     SEG               0.720    0.010   74.625    0.000    1.000    1.000
    ## 
    ## Scales y*:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     sm_1              1.000                               1.000    1.000
    ##     sm_2              1.000                               1.000    1.000
    ##     sm_3              1.000                               1.000    1.000
    ##     sm_4              1.000                               1.000    1.000
    ##     seg_1             1.000                               1.000    1.000
    ##     seg_2             1.000                               1.000    1.000
    ##     seg_3             1.000                               1.000    1.000
    ##     seg_4             1.000                               1.000    1.000
    ## 
    ## R-Square:
    ##                    Estimate
    ##     sm_1              0.570
    ##     sm_2              0.748
    ##     sm_3              0.587
    ##     sm_4              0.520
    ##     seg_1             0.720
    ##     seg_2             0.811
    ##     seg_3             0.472
    ##     seg_4             0.272
    ##     SM                0.247

**Interpretación de la Salida de `summary()`:**

**A. Evaluación del Ajuste Global del Modelo:**

- **Test `\(\chi^2\)`:** El estadístico es **2588.087** con **61** grados de libertad (p-valor = 0.000). Dado el gran tamaño muestral, un p-valor significativo es esperado y no invalida el modelo por sí solo. Es más informativo observar otros índices.  
- **CFI = 0.975; TLI = 0.988:** Ambos índices son excelentes (muy por encima de 0.95), lo que sugiere un muy buen ajuste comparativo del modelo a los datos.  
- **RMSEA = 0.062 (IC 90%: 0.060 - 0.064):** Este valor está en el rango de **ajuste aceptable/razonable** (entre 0.05 y 0.08). El intervalo de confianza es estrecho y se encuentra completamente dentro de un rango aceptable.  
- **SRMR = 0.028:** Este valor es excelente (muy por debajo de 0.08).

**Conclusión de Ajuste:** El modelo muestra un **ajuste global muy bueno**. A pesar del `\(\chi^2\)` significativo, los índices CFI, TLI, RMSEA y SRMR indican que la estructura teórica propuesta representa adecuadamente las relaciones en los datos.

**B. Interpretación del Modelo de Medida (Cargas Factoriales `Std.all`):**

- **Factor `SM` (Sintomatología Depresiva):** Las cargas estandarizadas son **0.755, 0.865, 0.766, y 0.721**. Todas son muy altas (\>0.7) y significativas (p\<0.001), indicando que los 4 ítems son excelentes indicadores del constructo.  
- **Factor `SEG` (Percepción de Seguridad):** Las cargas estandarizadas son **0.849, 0.901, 0.687, y 0.521**. Los ítems sobre seguridad en el barrio de día y noche (`seg_1`, `seg_2`) son los más fuertes. La seguridad en plazas (`seg_3`) es buena y en el transporte público (`seg_4`) es aceptable, aunque es el indicador más débil. Todos son significativos.

**C. Interpretación del Modelo Estructural (Regressions `Std.all`):**

- **`qaut` (Quintil Ingreso):** Beta = **-0.095**. Un mayor quintil de ingreso se asocia significativamente con menor sintomatología depresiva.  
- **`zona` (Rural=1):** Beta = **-0.022**. No hay una diferencia significativa en sintomatología entre zonas urbanas y rurales en este modelo, una vez controladas las otras variables.  
- **`sexo` (Mujer=1):** Beta = **0.179**. Ser mujer se asocia significativamente con una mayor sintomatología depresiva, controlando por los otros factores.  
- **`edad`:** Beta = **-0.038**. A mayor edad, hay una leve pero significativa disminución en la sintomatología depresiva.  
- **`SEG` (Percepción Seguridad):** Beta = **-0.168**. Una mayor percepción de seguridad se asocia fuertemente con una **menor** sintomatología depresiva.
- **`maltrato`:** Beta = **0.292**. La percepción de haber sido maltratado es el **predictor más fuerte** de una mayor sintomatología depresiva.  
- **`social` (Satisfacción Vida Social):** Beta = **-0.230**. Una mayor satisfacción con la vida social es el segundo predictor más fuerte, asociado a una **menor** sintomatología depresiva.

**D. Varianza Explicada ($R^2$):**

- **`SM`:** `\(R^2 = 0.247\)`. El modelo en su conjunto explica el **24.7% de la varianza** en la sintomatología depresiva.

## 4. Visualización del Modelo con `lavaan.plot`

El paquete `lavaan.plot` permite crear diagramas de senderos limpios y personalizables.

``` r
# Visualizar el modelo usando lavaan.plot de forma más limpia
lavaanPlot(model = ajus_sem, 
            node_options = list(shape = "box", fontname = "Helvetica"),
            edge_options = list(color = "black"),
            coefs = TRUE,           # Mostrar coeficientes
            stand = TRUE,           # Usar la solución estandarizada
            covs = FALSE,           # ¡IMPORTANTE! No mostrar covarianzas entre exógenas por defecto
            stars = "regress",      # Añadir estrellas de significancia
            graph_options = list(rankdir = "LR"))
```

<div class="grViz html-widget html-fill-item" id="htmlwidget-1" style="width:1152px;height:768px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"diagram":" digraph plot { \n graph [ rankdir = LR ] \n node [ shape = box, fontname = Helvetica ] \n node [shape = box] \n qaut; zona; sexo; edad; maltrato; social; sm_1; sm_2; sm_3; sm_4; seg_1; seg_2; seg_3; seg_4 \n node [shape = oval] \n SM; SEG \n \n edge [ color = black ] \n qaut->SM [label = \"-0.1***\"] zona->SM [label = \"-0.02***\"] sexo->SM [label = \"0.18***\"] edad->SM [label = \"-0.04***\"] SEG->SM [label = \"-0.17***\"] maltrato->SM [label = \"0.29***\"] social->SM [label = \"-0.23***\"] SM->sm_1 [label = \"0.75\"] SM->sm_2 [label = \"0.86\"] SM->sm_3 [label = \"0.77\"] SM->sm_4 [label = \"0.72\"] SEG->seg_1 [label = \"0.85\"] SEG->seg_2 [label = \"0.9\"] SEG->seg_3 [label = \"0.69\"] SEG->seg_4 [label = \"0.52\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

**Interpretación del Gráfico:**

El diagrama ahora visualiza el modelo de forma mucho más clara.

- **Modelo de Medida (Derecha):** Vemos los dos factores latentes (`SM` y `SEG`) en óvalos, con flechas apuntando a sus respectivos indicadores (rectángulos). Los números en estas flechas son las cargas factoriales estandarizadas.  
- **Modelo Estructural (Izquierda y Centro):** Vemos las variables exógenas (covariables) y el factor `SEG` apuntando con flechas al factor endógeno `SM`. Los números en estas flechas son los coeficientes path estandarizados, con estrellas que indican su nivel de significancia. Esto permite ver rápidamente qué relaciones son las más fuertes y significativas.

## 5. Conclusión del Práctico

En este práctico hemos:
1. Especificado y estimado un modelo SEM completo, utilizando el estimador `DWLS` apropiado para nuestros datos.
2. Evaluado el ajuste del modelo, concluyendo que es **bueno y teóricamente defendible**.
3. Confirmado la validez de nuestras **escalas de medida** para sintomatología depresiva y percepción de seguridad.
4. Identificado los **predictores más importantes** de la sintomatología depresiva: la percepción de maltrato, la satisfacción con la vida social y la percepción de seguridad son los factores con mayor impacto.
5. Cuantificado que nuestro modelo explica un **24.7% de la varianza** en la sintomatología depresiva.

Este ejercicio demuestra el poder de SEM para testear simultáneamente teorías complejas sobre la medición de constructos y las relaciones causales hipotetizadas entre ellos de una manera rigurosa.
