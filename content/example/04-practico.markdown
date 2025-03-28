---
title: "4. Explorando Encuestas Complejas (CASEN) y Declarando el Diseño en R"
linktitle: "4. Explorando Encuestas Complejas (CASEN) y Declarando el Diseño en R"
date: "2025-03-31"
menu:
  example:
    parent: Ejemplos
    weight: 4
type: docs
toc: true
editor_options:
  chunk_output_type: console
---



## 0. Objetivos del Práctico

En esta sesión práctica, vamos a dar los primeros pasos para trabajar con datos de encuestas complejas en R, usando la Encuesta CASEN 2022 como nuestro caso de estudio. Al finalizar este práctico, serás capaz de:

1.  **Cargar** datos de encuestas en formato SPSS (`.sav`) en R.
2.  **Explorar** una base de datos de encuesta e **identificar** las variables clave que describen su diseño muestral complejo (ponderadores, estratos, conglomerados).
3.  Realizar cálculos descriptivos **"ingenuos"** (ignorando el diseño muestral) como punto de comparación.
4.  **Declarar** correctamente el diseño muestral complejo en R utilizando la función `svydesign()` del paquete `survey`.
5.  Realizar un primer cálculo **ponderado** (una media) y **constatar** la diferencia con el cálculo ingenuo.

## 1. Preparación del Entorno

Antes de empezar, necesitamos asegurarnos de tener las herramientas adecuadas en R.

*   **Paquetes:** Cargaremos los paquetes `tidyverse` (para manipulación general de datos), `haven` (para leer archivos de SPSS/Stata/SAS) y `survey` (para análisis de encuestas complejas).
*   **RProject:** Es una buena práctica trabajar dentro de un RStudio Project para mantener todo organizado y facilitar el manejo de rutas de archivos. Si no tienes uno para este curso, considera crearlo.


``` r
# Si no tienes instalados los paquetes, ejecuta primero estas líneas (quitando el #):
# install.packages("tidyverse")
# install.packages("haven")
# install.packages("survey")

# Cargar los paquetes necesarios para la sesión
library(tidyverse)
library(haven)
library(survey)
```

¡Listo! Ahora estamos preparados para trabajar con los datos.

## 2. Cargando y Explorando Datos CASEN 2022

La Encuesta de Caracterización Socioeconómica Nacional (CASEN) es una de las encuestas de hogares más importantes de Chile. Utilizaremos la versión 2022. El Ministerio de Desarrollo Social y Familia la disponibiliza públicamente en formato SPSS (`.sav`).

Usaremos un código para descargarla directamente desde la web del ministerio y cargarla en R.


``` r
# Crear un archivo temporal para la descarga
temp <- tempfile() 

# Descargar el archivo .zip que contiene la base de datos SPSS
download.file("https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2022/Base%20de%20datos%20Casen%202022%20SPSS.sav.zip", temp, mode = "wb") 

# Leer el archivo .sav desde dentro del .zip usando haven::read_sav()
# Nota: 'unz()' descomprime el archivo temporalmente para leerlo.
# El nombre "Base de datos Casen 2022 SPSS.sav" debe coincidir exactamente.
casen <- haven::read_sav(unz(temp, "Base de datos Casen 2022 SPSS.sav")) 

# Eliminar el archivo temporal descargado
unlink(temp)
remove(temp) 

# Mensaje de confirmación (opcional)
print("Base de datos CASEN 2022 cargada exitosamente.")
```

```
## [1] "Base de datos CASEN 2022 cargada exitosamente."
```

Ahora que tenemos la base `casen` en nuestro entorno, vamos a explorarla un poco.


``` r
# Vistazo rápido a la estructura y tipos de variables
#glimpse(casen) # Comentado para brevedad

# Ver las primeras filas de la base
head(casen)
```

```
## # A tibble: 6 × 917
##   id_vivienda    folio id_persona region   area    cod_upm nse     estrato hogar
##         <dbl>    <dbl>      <dbl> <dbl+lb> <dbl+l>   <dbl> <dbl+l>   <dbl> <dbl>
## 1     1000901   1.00e8          1 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## 2     1000901   1.00e8          2 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## 3     1000901   1.00e8          3 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## 4     1000902   1.00e8          1 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## 5     1000902   1.00e8          2 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## 6     1000902   1.00e8          3 16 [Reg… 2 [Rur…   10009 4 [Baj… 1630324     1
## # ℹ 908 more variables: expr <dbl>, expr_osig <dbl>, varstrat <dbl>,
## #   varunit <dbl>, fecha_entrev <date>, p1 <dbl+lbl>, p2 <dbl+lbl>,
## #   p3 <dbl+lbl>, p4 <dbl+lbl>, p9 <dbl>, p10 <dbl+lbl>, p11 <dbl>,
## #   tot_per_h <dbl>, h1 <dbl+lbl>, edad <dbl>, mes_nac_nna <dbl+lbl>,
## #   ano_nac_nna <dbl+lbl>, sexo <dbl+lbl>, pco1_a <dbl+lbl>, pco1_b <dbl+lbl>,
## #   pco1 <dbl+lbl>, h5_cp <dbl+lbl>, h5_sp <dbl+lbl>, h5_b1_1 <dbl>,
## #   h5_b1_2 <dbl>, h5a_2 <dbl+lbl>, h5_b2_1 <dbl>, h5_b2_2 <dbl>, …
```

``` r
# Resumen de algunas variables sociodemográficas clave
summary(casen$edad) 
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00   20.00   38.00   39.32   58.00  120.00
```

``` r
summary(casen$sexo) # Veremos las etiquetas si haven las cargó bien
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   2.000   1.527   2.000   2.000
```

``` r
summary(casen$esc) # Años de escolaridad
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    8.00   12.00   11.17   14.00   29.00   36983
```

``` r
summary(casen$ytotcorh) # Ingreso total corregido del hogar
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##        0   750000  1121667  1476989  1728370 77300000      120
```

``` r
summary(casen$pobreza) # Situación de pobreza
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   1.000   3.000   3.000   2.901   3.000   3.000     120
```

**Interpretación de la Exploración:**
*   La base tiene muchísimas variables (917) y un gran número de casos (202231), correspondientes a personas.
*   La **edad** va de 0 a 120 años, con una media muestral (aún no ponderada) de 39.3 años.
*   El **sexo** está codificado (probablemente 1=Hombre, 2=Mujer), con una leve mayoría de mujeres en la muestra (media de 1.53).
*   La **escolaridad** (`esc`) tiene un rango amplio y presenta valores perdidos (`NA's`). La media muestral es de 11.2 años.
*   El **ingreso del hogar** (`ytotcorh`) muestra una gran dispersión (comparar mediana y media, y el máximo valor) y también tiene algunos `NA`.
*   La variable **pobreza** (probablemente 1=extrema, 2=no extrema, 3=no pobre) muestra que la mayoría de la muestra se clasifica como no pobre (media cercana a 3).

**Reflexión:** Esta exploración inicial nos da una idea general de los datos, pero recordamos que estas son estadísticas *de la muestra*, no necesariamente representativas de la población chilena todavía.

### Identificando las Variables del Diseño Muestral

Como vimos en la clase, para analizar correctamente esta encuesta, necesitamos identificar las variables que definen su diseño complejo. Basándonos en la documentación oficial de CASEN (que siempre deberías consultar), estas variables suelen ser:

1.  **Ponderador / Factor de Expansión:** `expr` (regional).
2.  **Estrato:** `varstrat`.
3.  **Conglomerado / UPM:** `varunit`.

Veamos cómo lucen estas variables en nuestros datos:


``` r
# Resumen del factor de expansión regional (ponderador)
summary(casen$expr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     2.0    44.0    75.0    98.3   118.0  5222.0
```

``` r
# Nota: ¡Los pesos varían mucho! Van desde 2 hasta 5222, con una media de 98.3. 
# Esto confirma que las probabilidades de selección fueron muy desiguales.

# Cantidad de estratos únicos definidos para la varianza
length(unique(casen$varstrat)) 
```

```
## [1] 755
```

``` r
head(casen$varstrat)
```

```
## [1] 751 751 751 751 751 751
```

``` r
# Cantidad de conglomerados (UPMs) únicos definidos para la varianza
length(unique(casen$varunit))
```

```
## [1] 12062
```

``` r
head(casen$varunit)
```

```
## [1] 12041 12041 12041 12041 12041 12041
```

``` r
# Nota: Hay muchos menos estratos (755) que conglomerados (12062), 
# y los IDs de conglomerado (varunit) se repiten, confirmando la estructura anidada.
```

**Importante:** Hemos localizado las variables `expr`, `varstrat`, y `varunit`. ¡Estas son las llaves para decirle a R cómo fue diseñada la muestra!

## 3. El Error Común: Análisis Ingenuo

Antes de usar las herramientas correctas, calculemos estadísticas como si CASEN fuera una muestra aleatoria simple (MAS), ignorando el diseño.


``` r
# Media de edad simple (ignorando el diseño)
media_edad_ingenua <- mean(casen$edad, na.rm = TRUE)
print(paste("Media de edad (ingenua):", round(media_edad_ingenua, 2)))
```

```
## [1] "Media de edad (ingenua): 39.32"
```

``` r
# Media de escolaridad simple
media_esc_ingenua <- mean(casen$esc, na.rm = TRUE)
print(paste("Media de escolaridad (ingenua):", round(media_esc_ingenua, 2)))
```

```
## [1] "Media de escolaridad (ingenua): 11.17"
```

``` r
# Proporción de sexo simple (usando table y prop.table)
tabla_sexo_ingenua <- table(casen$sexo)
prop_sexo_ingenua <- prop.table(tabla_sexo_ingenua)
print("Proporción por sexo (ingenua):")
```

```
## [1] "Proporción por sexo (ingenua):"
```

``` r
print(round(prop_sexo_ingenua, 3))
```

```
## 
##     1     2 
## 0.473 0.527
```

``` r
# Proporción de pobreza simple (variable dicotómica pobre_dic)
casen <- casen %>% 
  mutate(pobre_dic = ifelse(pobreza %in% c(1, 2), 1, 0))

tabla_pobreza_ingenua <- table(casen$pobre_dic)
prop_pobreza_ingenua <- prop.table(tabla_pobreza_ingenua)
print("Proporción de pobreza (ingenua):")
```

```
## [1] "Proporción de pobreza (ingenua):"
```

``` r
print(round(prop_pobreza_ingenua, 3)) 
```

```
## 
##     0     1 
## 0.924 0.076
```

**Resultados Ingenuos:**
*   Edad media (ingenua): 39.32 años.
*   Escolaridad media (ingenua): 11.17 años.
*   Proporción de Hombres (ingenua): 47.3%.
*   Proporción de Mujeres (ingenua): 52.7%.
*   Proporción de Pobreza (ingenua): 7.6%.

**Guarda estos números.** Los usaremos para comparar.

## 4. Declarando el Diseño Muestral con `survey`

Ahora, le enseñamos a R la "receta" de la muestra CASEN usando `svydesign()`.


``` r
# Crear el objeto que describe el diseño muestral de CASEN
casen_design <- svydesign(ids = ~varunit,      # Conglomerados (UPM)
                          strata = ~varstrat,   # Estratos
                          weights = ~expr,     # Ponderador regional
                          data = casen,        # Base de datos
                          nest = TRUE)         # IDs de UPM se repiten entre estratos

# Mensaje de confirmación
print("Objeto de diseño muestral 'casen_design' creado.")
```

```
## [1] "Objeto de diseño muestral 'casen_design' creado."
```

``` r
# Inspeccionar el objeto creado
print(casen_design)
```

```
## Stratified 1 - level Cluster Sampling design (with replacement)
## With (12062) clusters.
## svydesign(ids = ~varunit, strata = ~varstrat, weights = ~expr, 
##     data = casen, nest = TRUE)
```

``` r
#summary(casen_design) # Comentado para brevedad
```

**Interpretación de la Salida `print(casen_design)`:**
R nos confirma que ha creado un objeto de diseño muestral. Nos indica que es un diseño "Stratified 1-level Cluster Sampling design" (Muestreo por Conglomerados Estratificado de 1 nivel - aunque sabemos que es bietápico, `survey` a menudo simplifica la descripción si solo se especifican las UPMs). Crucialmente, identifica:
*   Que hay 12062 clusters (UPMs únicas definidas en `varunit`).
*   Que la estratificación está dada por `varstrat`.
*   Que los ponderadores son `expr`.
*   Que los datos provienen de `casen`.

¡Ahora R "sabe" que esta no es una muestra simple y cómo está estructurada!

## 5. Primer Cálculo Respetando el Diseño

Vamos a recalcular la **media de edad** y la **proporción de pobreza** usando el objeto `casen_design` y la función `svymean()`.


``` r
# Media de edad PONDERADA
media_edad_ponderada <- svymean(~edad, design = casen_design, na.rm = TRUE)
print("Media de edad (ponderada y con diseño complejo):")
```

```
## [1] "Media de edad (ponderada y con diseño complejo):"
```

``` r
print(media_edad_ponderada)
```

```
##      mean    SE
## edad 37.2 0.098
```

``` r
# Proporción de pobreza PONDERADA (usando pobre_dic)
prop_pobreza_ponderada <- svymean(~pobre_dic, design = casen_design, na.rm = TRUE)
print("Proporción de pobreza (ponderada y con diseño complejo):")
```

```
## [1] "Proporción de pobreza (ponderada y con diseño complejo):"
```

``` r
print(prop_pobreza_ponderada) 
```

```
##               mean     SE
## pobre_dic 0.064986 0.0014
```

**¡Ahora compara!**

1.  **Edad:** La media ingenua fue **39.32 años**. La media ponderada es **37.2 años** (SE=0.098). ¡Son diferentes! La media ponderada, que representa mejor a la población, es menor.
2.  **Pobreza:** La proporción ingenua de pobreza fue **7.6%** (0.076). La proporción ponderada es **6.5%** (0.065, SE=0.0014). ¡También es diferente! La estimación que considera el diseño muestral es más baja.

**Pregunta de Reflexión:** ¿Por qué crees que los resultados ponderados difieren de los resultados ingenuos? 
*Respuesta posible:* Los ponderadores corrigen el hecho de que algunas personas (quizás más jóvenes o no pobres en este caso) tuvieron mayor probabilidad de ser seleccionadas o respondieron más que otras. Al aplicar los pesos, ajustamos esas diferencias para que la muestra refleje mejor la estructura real de la población. Ignorar los pesos nos daría una imagen distorsionada.

¿Qué implica esto para nuestras conclusiones si solo hubiéramos usado los cálculos ingenuos?
*Respuesta posible:* Hubiéramos sobreestimado la edad promedio de la población y también la tasa de pobreza. Nuestras conclusiones sobre la sociedad chilena habrían sido incorrectas.

## 6. Conclusión

¡Felicitaciones! Has dado tus primeros pasos en el análisis de encuestas complejas en R.

*   Aprendiste a cargar datos de CASEN.
*   Identificaste las variables cruciales del diseño muestral (`expr`, `varstrat`, `varunit`).
*   Declaraste este diseño a R usando `svydesign()`.
*   **Comprobaste empíricamente** que ignorar los ponderadores lleva a **estimaciones diferentes (y probablemente sesgadas)**, comparando los resultados ingenuos con los obtenidos usando `svymean()`.
*   Notaste que `svymean` también entrega un **Error Estándar (SE)**, que mide la incertidumbre de la estimación considerando el diseño.

En la próxima sesión, profundizaremos en cómo realizar más análisis (proporciones por grupo, totales) de manera más fácil usando el paquete `srvyr` y cómo interpretar estos errores estándar.
