---
title: "11. Análisis de Senderos con `lavaan`"
linktitle: "11. Análisis de Senderos"
date: "2025-06-16" 
menu:
  example: # Nombre del menú
    parent: Ejemplos # Sección padre dentro del menú "example"
    weight: 11       # Peso dentro de la sección padre
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

<link href="/rmarkdown-libs/htmltools-fill/fill.css" rel="stylesheet" />
<script src="/rmarkdown-libs/htmlwidgets/htmlwidgets.js"></script>

<script src="/rmarkdown-libs/viz/viz.js"></script>

<link href="/rmarkdown-libs/DiagrammeR-styles/styles.css" rel="stylesheet" />
<script src="/rmarkdown-libs/grViz-binding/grViz.js"></script>

## 0. Objetivos del Práctico

En este práctico, aprenderemos a especificar, estimar e interpretar modelos de Análisis de Senderos (Path Analysis - PA) utilizando el paquete `lavaan` en R. Nos enfocaremos en:

1.  Comprender la **lógica y sintaxis** para definir modelos de senderos en `lavaan`.
2.  Realizar una **revisión de supuestos** pertinente para el Análisis de Senderos, adaptando nuestras decisiones según los hallazgos.
3.  **Estimar** los parámetros del modelo utilizando un estimador adecuado, en este caso, `DWLS`, debido a la naturaleza de nuestros datos.
4.  Evaluar el **ajuste global** del modelo a los datos mediante diversos índices.
5.  **Interpretar** detalladamente los coeficientes path (directos e indirectos) y la varianza explicada (`\(R^2\)`).
6.  Visualizar el modelo de senderos para una mejor comprensión.

## Introducción al Ejemplo

El análisis de senderos es una técnica poderosa que nos permite ir más allá de las correlaciones simples, ayudándonos a testear teorías sobre cómo diferentes variables se influyen mutuamente, tanto de forma directa como a través de variables intermedias (mediadoras).

Trabajaremos con un ejemplo adaptado del taller de Dra. Monica Gerber sobre Ecuaciones Estructurales. El objetivo es analizar el efecto de la **posición política** sobre el **acuerdo con castigos severos** para quienes cometen delitos, considerando el **autoritarismo de derechas (RWA)** como una variable mediadora clave.

**Modelo Hipotetizado Inicial:**

Este es el diagrama conceptual que representa nuestra teoría inicial:

<img src="https://github.com/Clases-GabrielSotomayor/pruebapagina/blob/master/content/example/input/sendero.png?raw=true" data-fig-align="center" />

## 1. Carga de Paquetes y Datos

Comenzamos cargando los paquetes que necesitaremos. `lavaan` será nuestra herramienta principal para el análisis de senderos.

``` r
# Cargar paquetes
# install.packages(c("haven", "lavaan", "dplyr", "lavaanPlot", "texreg", "MVN")) # Descomentar si es necesario la primera vez


library(haven)
library(lavaan)
library(dplyr)
library(lavaanPlot) # Para graficar modelos SEM
library(texreg)  # Para tablas de resultados
library(MVN)     # Para test de normalidad multivariante
```

Importamos los datos de la encuesta ELSOC 2016.

``` r
# Importar datos
datos <- read_sav(url("https://github.com/Clases-GabrielSotomayor/pruebapagina/raw/master/content/example/input/data/elsoc2016.sav"))
# glimpse(datos) 
```

## 2. Comprobación de Supuestos

Antes de ajustar cualquier modelo, es fundamental revisar las características de nuestros datos y si cumplen (o no) con los supuestos de la técnica.

``` r
# Seleccionar solo las variables que se usarán en el modelo
variables_modelo <- c("castigo_media", "rwa_media", "derecha", "izquierda", "centro")
datos_modelo <- datos %>%
  select(all_of(variables_modelo))

# Manejo de Casos Perdidos (Listwise deletion para simplificar este práctico)
print(paste("Observaciones antes de eliminar NAs:", nrow(datos_modelo)))
```

    ## [1] "Observaciones antes de eliminar NAs: 2984"

``` r
datos_modelo_completos <- datos_modelo %>%
  na.omit()
print(paste("Observaciones después de eliminar NAs:", nrow(datos_modelo_completos)))
```

    ## [1] "Observaciones después de eliminar NAs: 2909"

``` r
print(paste("Observaciones perdidas:", nrow(datos_modelo) - nrow(datos_modelo_completos)))
```

    ## [1] "Observaciones perdidas: 75"

``` r
# Matriz de Correlaciones
matriz_cor <- cor(datos_modelo_completos, use = "pairwise.complete.obs") 
print("Matriz de Correlaciones (Pearson):")
```

    ## [1] "Matriz de Correlaciones (Pearson):"

``` r
print(round(matriz_cor, 2))
```

    ##               castigo_media rwa_media derecha izquierda centro
    ## castigo_media          1.00      0.28    0.08     -0.09  -0.06
    ## rwa_media              0.28      1.00    0.11     -0.18  -0.02
    ## derecha                0.08      0.11    1.00     -0.15  -0.23
    ## izquierda             -0.09     -0.18   -0.15      1.00  -0.28
    ## centro                -0.06     -0.02   -0.23     -0.28   1.00

``` r
# Normalidad Multivariante (Test de Mardia)
resultados_mvn <- mvn(datos_modelo_completos, 
                      mvnTest = "mardia", 
                      univariateTest = "SW", 
                      showOutliers = FALSE, # No mostraremos la lista de outliers aquí
                      showNewData = FALSE) 
print("Resultados Test de Normalidad Multivariante (Mardia):")
```

    ## [1] "Resultados Test de Normalidad Multivariante (Mardia):"

``` r
print(resultados_mvn$multivariateNormality)
```

    ##              Test        Statistic p value Result
    ## 1 Mardia Skewness 6763.70732593015       0     NO
    ## 2 Mardia Kurtosis   15.37649877022       0     NO
    ## 3             MVN             <NA>    <NA>     NO

``` r
print("Resultados Test de Normalidad Univariante (Shapiro-Wilk):")
```

    ## [1] "Resultados Test de Normalidad Univariante (Shapiro-Wilk):"

``` r
print(resultados_mvn$univariateNormality)
```

    ##           Test      Variable Statistic   p value Normality
    ## 1 Shapiro-Wilk castigo_media    0.7990  <0.001      NO    
    ## 2 Shapiro-Wilk   rwa_media      0.9267  <0.001      NO    
    ## 3 Shapiro-Wilk    derecha       0.3617  <0.001      NO    
    ## 4 Shapiro-Wilk   izquierda      0.4291  <0.001      NO    
    ## 5 Shapiro-Wilk    centro        0.5742  <0.001      NO

**Interpretación Detallada de Supuestos:**

- **Casos Perdidos:** Se eliminaron **75** observaciones debido a valores perdidos en alguna de las variables del modelo, quedando **2909** casos completos para el análisis. Esta pérdida es de aproximadamente 2.5%, lo cual es relativamente bajo.
- **Correlaciones (Pearson):**
  - `castigo_media` y `rwa_media` muestran una correlación positiva de **0.28**.
  - `rwa_media` tiene una correlación positiva con `derecha` (**0.11**) y negativa con `izquierda` (**-0.18**) y `centro` (**-0.02**, muy baja).
  - `castigo_media` tiene una correlación positiva baja con `derecha` (**0.08**) y negativa baja con `izquierda` (**-0.09**) y `centro` (**-0.06**).
  - Las variables de posición política (`derecha`, `izquierda`, `centro`) son, como se espera, negativamente correlacionadas entre sí, ya que una persona no puede estar en múltiples categorías simultáneamente (son dummies de un conjunto que excluye a “independiente/ninguno”).
  - No se observan correlaciones extremadamente altas (ej. \> 0.85) entre los predictores de `rwa_media`, lo que sugiere que la multicolinealidad no será un problema grave entre ellos.
- **Normalidad:**
  - *Multivariante (Test de Mardia):* Los resultados para Asimetría (`Skewness`) y Curtosis (`Kurtosis`) muestran p-valores de **0**, lo que indica que **se rechaza la hipótesis de normalidad multivariante**.
  - *Univariante (Test de Shapiro-Wilk):* Para todas las variables analizadas (`castigo_media`, `rwa_media`, `derecha`, `izquierda`, `centro`), el p-valor es **\< 0.001**. Esto significa que **ninguna de estas variables sigue una distribución normal** por sí sola.
  - **Implicancia Principal:** La marcada no-normalidad multivariante y univariante, junto con la presencia de variables dicotómicas (posición política), hace que el estimador por defecto de `lavaan` (Máxima Verosimilitud - ML) no sea el más adecuado. Por ello, utilizaremos el estimador **DWLS (Diagonally Weighted Least Squares)**, que es más robusto ante la violación del supuesto de normalidad y está diseñado para manejar variables que pueden ser tratadas como categóricas u ordinales.

## 3. Especificación y Estimación del Modelo de Senderos Inicial

Especificamos el modelo donde el autoritarismo (`rwa_media`) media la relación entre la posición política y el acuerdo con castigos severos (`castigo_media`).

**Recordatorio de Sintaxis `lavaan`:**

| Sintaxis `lavaan` | Comando | Ejemplo |
|----|----|----|
| `~` | Regresar en (VD ~ VI1 + VI2…) | `B ~ A` (B es predicha por A) |
| `~~` | (Co)varianza | `A ~~ A` (Varianza de A) <br> `A ~~ B` (Covarianza entre A y B) |
| `=~` | Factor es medido por (para variables latentes) | `F1 =~ item1 + item2 + item3` |
| `:=` | Parámetro Definido (ej. efecto indirecto) | `indirect_effect := path_a * path_b` |
| `etiqueta*` | Etiquetar un parámetro | `Y ~ b1*X1` (el path de X1 a Y se etiqueta como `b1`) |

``` r
# Especificar el modelo de senderos inicial
mod_sendero1_spec <- '
  # Regresiones (senderos directos)
  castigo_media ~ rwa_media          
  rwa_media     ~ derecha + izquierda + centro 
'

# Ajustar el modelo usando DWLS y datos_modelo_completos
ajus_sendero1 <- sem(model = mod_sendero1_spec, 
                     data = datos_modelo_completos, 
                     estimator = "DWLS") # Estimador robusto
```

### Resumen y Evaluación del Modelo Inicial

``` r
summary(ajus_sendero1, 
        fit.measures = TRUE,
        standardized = TRUE,
        rsquare = TRUE,
        modindices = TRUE)
```

    ## lavaan 0.6-19 ended normally after 33 iterations
    ## 
    ##   Estimator                                       DWLS
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        12
    ## 
    ##   Number of observations                          2909
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                15.635
    ##   Degrees of freedom                                 3
    ##   P-value (Chi-square)                           0.001
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                               298.645
    ##   Degrees of freedom                                 7
    ##   P-value                                        0.000
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    0.957
    ##   Tucker-Lewis Index (TLI)                       0.899
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.038
    ##   90 Percent confidence interval - lower         0.021
    ##   90 Percent confidence interval - upper         0.058
    ##   P-value H_0: RMSEA <= 0.050                    0.829
    ##   P-value H_0: RMSEA >= 0.080                    0.000
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.020
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                             Standard
    ##   Information                                 Expected
    ##   Information saturated (h1) model        Unstructured
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   castigo_media ~                                                       
    ##     rwa_media         0.306    0.025   12.143    0.000    0.306    0.304
    ##   rwa_media ~                                                           
    ##     derecha           0.189    0.049    3.838    0.000    0.189    0.077
    ##     izquierda        -0.437    0.059   -7.406    0.000   -0.437   -0.204
    ##     centro           -0.126    0.040   -3.150    0.002   -0.126   -0.075
    ## 
    ## Covariances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   derecha ~~                                                            
    ##     izquierda        -0.017    0.001  -15.809    0.000   -0.017   -0.149
    ##     centro           -0.033    0.002  -18.589    0.000   -0.033   -0.229
    ##   izquierda ~~                                                          
    ##     centro           -0.045    0.002  -22.133    0.000   -0.045   -0.276
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .castigo_media     0.544    0.027   20.491    0.000    0.544    0.908
    ##    .rwa_media         0.561    0.019   29.073    0.000    0.561    0.948
    ##     derecha           0.098    0.005   21.689    0.000    0.098    1.000
    ##     izquierda         0.129    0.005   27.817    0.000    0.129    1.000
    ##     centro            0.209    0.003   60.963    0.000    0.209    1.000
    ## 
    ## R-Square:
    ##                    Estimate
    ##     castigo_media     0.092
    ##     rwa_media         0.052
    ## 
    ## Modification Indices:
    ## 
    ##             lhs op           rhs    mi    epc sepc.lv sepc.all sepc.nox
    ## 1 castigo_media ~~     rwa_media 9.542  0.173   0.173    0.314    0.314
    ## 2 castigo_media  ~       derecha 8.533 -0.137  -0.137   -0.056   -0.177
    ## 3 castigo_media  ~     izquierda 0.809  0.044   0.044    0.020    0.056
    ## 4 castigo_media  ~        centro 7.667  0.088   0.088    0.052    0.113
    ## 5     rwa_media  ~ castigo_media 9.542  0.319   0.319    0.321    0.321
    ## 6       derecha  ~ castigo_media 4.746 -0.019  -0.019   -0.046   -0.046
    ## 7     izquierda  ~ castigo_media 2.173  0.018   0.018    0.039    0.039
    ## 8        centro  ~ castigo_media 7.591  0.036   0.036    0.060    0.060

**Interpretación del `summary(ajus_sendero1)` (con DWLS):**

- **Ajuste Global del Modelo:**
  - **Test `\(\chi^2\)`:** El estadístico es **15.635** con **3** grados de libertad. El **p-valor es 0.001**. Aunque DWLS usa un `\(\chi^2\)` escalado que es menos sensible al N y a la no-normalidad que el `\(\chi^2\)` de ML, un p-valor \< 0.05 todavía sugiere que el modelo hipotetizado tiene una discrepancia estadísticamente significativa con los datos observados.
  - **CFI = 0.957; TLI = 0.899:** El CFI es bueno (\>0.95). El TLI está justo en el límite inferior de lo aceptable (idealmente \>0.90), lo que sugiere un ajuste razonable pero no perfecto.
  - **RMSEA = 0.038 (IC 90%: 0.021 - 0.058):** Este valor es excelente (\<0.05), y su intervalo de confianza también se encuentra en un rango muy bueno (límite superior \< 0.08). El P-value para `\(H_0\)`: RMSEA `\(\leq 0.050\)` es 0.829, indicando que no podemos rechazar que el ajuste sea bueno.
  - **SRMR = 0.020:** Este valor es excelente (\<0.08), indicando una baja discrepancia promedio.
  - **Conclusión de Ajuste Inicial:** Aunque el `\(\chi^2\)` es significativo, los demás índices (especialmente RMSEA, SRMR y CFI) sugieren que el modelo tiene un **ajuste de aceptable a bueno**. El TLI cercano a 0.90 es el punto más débil.
- **Estimaciones de los Senderos (Regressions - Columna `Std.all` para coeficientes path estandarizados):**
  - `castigo_media ~ rwa_media`: El path estandarizado es **0.304** (p \< 0.001). Por cada aumento de una desviación estándar en autoritarismo (`rwa_media`), el acuerdo con castigos severos (`castigo_media`) aumenta en 0.304 desviaciones estándar. Es un efecto positivo y significativo.
  - `rwa_media ~ derecha`: Path = **0.077** (p \< 0.001). Identificarse con la derecha (comparado con ser independiente/ninguno) se asocia con un aumento de 0.077 DE en autoritarismo.
  - `rwa_media ~ izquierda`: Path = **-0.204** (p \< 0.001). Identificarse con la izquierda se asocia con una disminución de 0.204 DE en autoritarismo.
  - `rwa_media ~ centro`: Path = **-0.075** (p = 0.002). Identificarse con el centro se asocia con una disminución de 0.075 DE en autoritarismo.
  - Todas las relaciones hipotetizadas son estadísticamente significativas.
- **$`R^2`$ (Varianza Explicada):**
  - Para `castigo_media`: `\(R^2 = 0.092\)`. El autoritarismo (`rwa_media`) explica el **9.2%** de la varianza en el acuerdo con castigos severos.
  - Para `rwa_media`: `\(R^2 = 0.052\)`. La posición política (derecha, izquierda, centro vs. independiente) explica el **5.2%** de la varianza en autoritarismo.
  - Estos `\(R^2\)` son modestos, lo que sugiere que hay otros factores importantes no incluidos en el modelo que explican la variación en ambas variables endógenas.

## 4. Modelo Modificado: Incluyendo Efectos Directos y Definiendo Efectos Indirectos

El `summary` del modelo anterior (si se solicitan `modindices = TRUE`) podría haber sugerido añadir un efecto directo de la posición política (ej. `derecha`) sobre `castigo_media`. Exploraremos este modelo modificado y definiremos explícitamente los efectos indirectos y totales para que `lavaan` los estime y testee.

**Nuevo Modelo Hipotetizado (con path directo de derecha a castigo):**
<img src="https://github.com/Clases-GabrielSotomayor/pruebapagina/blob/master/content/example/input/sendero2.png?raw=true" data-fig-align="center" />

``` r
# Especificar el modelo con efecto directo de 'derecha' y etiquetas para efectos indirectos/totales
mod_sendero2_spec <- '
  # Regresiones (senderos directos)
  castigo_media ~ a*rwa_media + c*derecha   # a es path rwa->castigo, c es path derecha->castigo
  rwa_media     ~ b*derecha + izquierda + centro # b es path derecha->rwa
  
  # Definir efecto indirecto de derecha sobre castigo_media via rwa_media
  ind_derecha_rwa := a*b
  
  # Definir efecto total de derecha sobre castigo_media
  total_derecha_rwa := (a*b) + c 
'

# Ajustar el modelo modificado con DWLS
ajus_sendero2 <- sem(model = mod_sendero2_spec, 
                     data = datos_modelo_completos,
                     estimator = "DWLS")
```

### Resumen y Evaluación del Modelo Modificado

``` r
summary(ajus_sendero2, 
        fit.measures = TRUE, 
        standardized = TRUE, 
        rsquare = TRUE)
```

    ## lavaan 0.6-19 ended normally after 34 iterations
    ## 
    ##   Estimator                                       DWLS
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        13
    ## 
    ##   Number of observations                          2909
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 7.063
    ##   Degrees of freedom                                 2
    ##   P-value (Chi-square)                           0.029
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                               298.645
    ##   Degrees of freedom                                 7
    ##   P-value                                        0.000
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    0.983
    ##   Tucker-Lewis Index (TLI)                       0.939
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.030
    ##   90 Percent confidence interval - lower         0.008
    ##   90 Percent confidence interval - upper         0.054
    ##   P-value H_0: RMSEA <= 0.050                    0.906
    ##   P-value H_0: RMSEA >= 0.080                    0.000
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.014
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                             Standard
    ##   Information                                 Expected
    ##   Information saturated (h1) model        Unstructured
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   castigo_media ~                                                       
    ##     rwa_media  (a)    0.285    0.026   11.076    0.000    0.285    0.284
    ##     derecha    (c)    0.137    0.047    2.927    0.003    0.137    0.055
    ##   rwa_media ~                                                           
    ##     derecha    (b)    0.160    0.050    3.185    0.001    0.160    0.065
    ##     izquierda        -0.436    0.059   -7.339    0.000   -0.436   -0.203
    ##     centro           -0.123    0.040   -3.059    0.002   -0.123   -0.073
    ## 
    ## Covariances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   derecha ~~                                                            
    ##     izquierda        -0.017    0.001  -15.844    0.000   -0.017   -0.150
    ##     centro           -0.033    0.002  -18.676    0.000   -0.033   -0.231
    ##   izquierda ~~                                                          
    ##     centro           -0.045    0.002  -22.133    0.000   -0.045   -0.276
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .castigo_media     0.547    0.026   20.703    0.000    0.547    0.913
    ##    .rwa_media         0.567    0.019   29.225    0.000    0.567    0.951
    ##     derecha           0.098    0.005   21.614    0.000    0.098    1.000
    ##     izquierda         0.129    0.005   27.817    0.000    0.129    1.000
    ##     centro            0.209    0.003   60.963    0.000    0.209    1.000
    ## 
    ## R-Square:
    ##                    Estimate
    ##     castigo_media     0.087
    ##     rwa_media         0.049
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     ind_derecha_rw    0.046    0.015    3.058    0.002    0.046    0.018
    ##     total_derch_rw    0.183    0.046    3.983    0.000    0.183    0.074

**Interpretación del `summary(ajus_sendero2)` (con DWLS):**

- **Ajuste Global del Modelo Modificado:**
  - **Test `\(\chi^2\)`:** **7.063** con **2** grados de libertad. El **p-valor es 0.029**. Aunque el valor del estadístico `\(\chi^2\)` es mucho menor que en el modelo anterior (era 15.635), el p-valor sigue siendo significativo (\< 0.05). Esto indica que el modelo aún difiere de un ajuste perfecto. La reducción en grados de libertad (de 3 a 2) se debe a que estimamos un parámetro más (el path `c`).
  - **CFI = 0.983; TLI = 0.939:** El CFI mejoró (era 0.957) y ahora es excelente. El TLI también mejoró (era 0.899) y ahora supera el umbral de 0.90, indicando un buen ajuste comparativo.
  - **RMSEA = 0.030 (IC 90%: 0.008 - 0.054):** Este valor es excelente (\<0.05), y su intervalo de confianza es muy bueno, con el límite superior muy por debajo de 0.08. El p-valor para `\(H_0\)`: RMSEA `\(\leq 0.050\)` es 0.906, lo que fuertemente apoya un buen ajuste.
  - **SRMR = 0.014:** Mejoró aún más (era 0.020), lo cual es excelente.
  - **Conclusión de Ajuste:** Añadir el path directo de `derecha` a `castigo_media` **mejoró sustancialmente el ajuste del modelo** según CFI, TLI, RMSEA y SRMR, a pesar de que el `\(\chi^2\)` sigue siendo significativo. Este modelo parece representar mejor los datos.
- **Estimaciones de los Senderos (Regressions - `Std.all`):**
  - `castigo_media ~ rwa_media` (path `a`): Coeficiente estandarizado = **0.284** (p \< 0.001). El efecto del autoritarismo sobre el apoyo a castigos sigue siendo positivo y significativo, con una magnitud similar al modelo anterior.
  - `castigo_media ~ derecha` (path `c`, el nuevo): Coeficiente estandarizado = **0.055** (p = 0.003). Ser de derecha tiene un efecto directo positivo y **estadísticamente significativo** sobre el acuerdo con castigos severos, incluso después de controlar por el nivel de autoritarismo.
  - `rwa_media ~ derecha` (path `b`): Coeficiente estandarizado = **0.065** (p = 0.001). El efecto de ser de derecha sobre el autoritarismo es ligeramente menor que antes (0.077) pero sigue siendo significativo.
  - Los efectos de `izquierda` (Std.all = -0.203, p \< 0.001) y `centro` (Std.all = -0.073, p = 0.002) sobre `rwa_media` se mantienen negativos y significativos.
- **$`R^2`$ (Varianza Explicada):**
  - Para `castigo_media`: `\(R^2 = 0.087\)` (8.7%). Hubo un pequeño aumento respecto al modelo anterior (0.080), gracias al path directo añadido.
  - Para `rwa_media`: `\(R^2 = 0.049\)` (4.9%). La varianza explicada para autoritarismo es similar, ya que sus predictores no cambiaron fundamentalmente.
- **Parámetros Definidos (`Defined Parameters - Std.all` para interpretación estandarizada):**
  - `ind_derecha_rwa (a*b)`: El efecto indirecto estandarizado de `derecha` sobre `castigo_media` (mediado por `rwa_media`) es **0.018** (p = 0.002). Aunque pequeño, es estadísticamente significativo.
  - `total_derecha_rwa ((a*b)+c)`: El efecto total estandarizado de `derecha` sobre `castigo_media` es **0.074** (p \< 0.001). Este efecto total es la suma del efecto directo (0.055) y el indirecto (0.018).
  - **Conclusión Efectos:** Ser de derecha tiene un efecto total positivo y significativo sobre el acuerdo con castigos severos. Este efecto se compone de una influencia directa y una influencia indirecta (más pequeña pero significativa) que opera a través del aumento en los niveles de autoritarismo.

## 5. Visualización del Modelo Final (con `lavaanPlot`)

``` r
# Diagrama del modelo de senderos modificado
lavaanPlot(
  model = ajus_sendero2, 
  node_options = list(shape = "box", fontname = "Helvetica"),
  edge_options = list(color = "black"),
  coefs = T,          # Muestra los coeficientes
  stand = TRUE,          # Usa los estandarizados
  stars = "regress"      # Añade estrellas de significancia
)
```

<div class="grViz html-widget html-fill-item" id="htmlwidget-1" style="width:960px;height:672px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box, fontname = Helvetica ] \n node [shape = box] \n rwa_media; derecha; izquierda; centro; castigo_media \n node [shape = oval] \n  \n \n edge [ color = black ] \n rwa_media->castigo_media [label = \"0.28***\"] derecha->castigo_media [label = \"0.06**\"] derecha->rwa_media [label = \"0.06**\"] izquierda->rwa_media [label = \"-0.2***\"] centro->rwa_media [label = \"-0.07**\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

**Interpretación del Gráfico:** El diagrama ahora muestra el path directo de `derecha` a `castigo_media` (con un coeficiente estandarizado de 0.06) además de las relaciones del modelo original. Los valores en las flechas son los coeficientes estandarizados (`Std.all`).

## 6. Conclusión del Práctico

En este práctico hemos:
1. Revisado supuestos, identificando no-normalidad, lo que nos llevó a usar el estimador `DWLS` en `lavaan`.
2. Especificado y estimado un modelo de senderos inicial y luego un modelo modificado que incluyó un path directo adicional.
3. Evaluado el ajuste global de ambos modelos, concluyendo que el **segundo modelo (modificado) presenta un mejor ajuste general a los datos**, según la mayoría de los índices (CFI, TLI, RMSEA, SRMR), a pesar de que el `\(\chi^2\)` sigue siendo significativo.
4. Interpretado los coeficientes path directos, confirmando que la posición política influye en el autoritarismo, y que tanto el autoritarismo como ser de derecha (directamente) influyen en el apoyo a castigos severos.
5. Definido, estimado e interpretado un **efecto indirecto significativo** de ser de derecha sobre el apoyo a castigos, mediado por el autoritarismo, así como el **efecto total**.
6. Observado que, aunque los efectos son estadísticamente significativos, la **varianza explicada (`\(R^2\)`)** por estos modelos es modesta (alrededor del 8.7% para `castigo_media` y 4.9% para `rwa_media`), lo que indica que hay muchos otros factores no incluidos que también son importantes para explicar estas actitudes.

Este ejercicio ilustra cómo el Análisis de Senderos nos permite testear modelos teóricos complejos de relaciones causales, descomponer los efectos para una comprensión más profunda, y tomar decisiones informadas sobre la estructura del modelo basadas en el ajuste y la teoría.
