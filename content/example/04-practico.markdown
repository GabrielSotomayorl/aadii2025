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
#glimpse(casen)

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

**Reflexiona:** Observa la cantidad de variables y casos. ¿Qué tipo de datos contienen las variables que resumiste? ¿Hay valores perdidos (`NA`)?

### Identificando las Variables del Diseño Muestral

Como vimos en la clase, para analizar correctamente esta encuesta, necesitamos identificar las variables que definen su diseño complejo. Basándonos en la documentación oficial de CASEN (que siempre deberías consultar), estas variables suelen ser:

1.  **Ponderador / Factor de Expansión:** Representa a cuántas personas de la población representa cada encuestado. Busca variables con nombres como `expr`, `expc`, `exph`. Usaremos el ponderador regional `expr`.
2.  **Estrato:** Define los subgrupos creados antes del muestreo (ej. por zona geográfica, NSE). En CASEN 2022, se llama `varstrat`.
3.  **Conglomerado / UPM:** Identifica la unidad primaria de muestreo (ej. la manzana o sector censal). En CASEN 2022, se llama `varunit`.

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
# Nota: ¡Los pesos no son todos iguales! Esto confirma que no es MAS.

# Resumen (o tabla de frecuencias) de la variable de estrato
# Es un código, así que un summary no es tan útil como ver cuántos hay
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
# Resumen (o tabla de frecuencias) de la variable de conglomerado (UPM)
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
# Nota: Los IDs de conglomerado (varunit) probablemente se repiten entre estratos (varstrat).
```

**Importante:** Hemos localizado las variables `expr`, `varstrat`, y `varunit`. ¡Estas son las llaves para decirle a R cómo fue diseñada la muestra!

## 3. El Error Común: Análisis Ingenuo

Antes de usar las herramientas correctas, hagamos un ejercicio: calculemos algunas estadísticas como si CASEN fuera una muestra aleatoria simple (MAS), ignorando los ponderadores, estratos y conglomerados. Esto nos dará un punto de comparación.


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
# Proporción de pobreza simple
# (Recodificamos pobreza: 1=pobre extremo, 2=pobre no extremo, 3=no pobre)
# Crearemos una variable dicotómica: 1 si es pobre (1 o 2), 0 si no es pobre (3)
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

``` r
# Mostramos la proporción de '1' (pobres)
```

**Guarda estos resultados ingenuos.** Los usaremos para comparar en el último paso.

## 4. Declarando el Diseño Muestral con `survey`

Ahora, vamos a enseñarle a R cómo está estructurada realmente la muestra de CASEN. Usaremos la función `svydesign()` del paquete `survey`.

Los argumentos clave son:

*   `ids = ~varunit`: Especifica la variable que contiene los identificadores de las UPM (conglomerados). El `~` es importante.
*   `strata = ~varstrat`: Especifica la variable que contiene los identificadores de los estratos.
*   `weights = ~expr`: Especifica la variable que contiene los ponderadores (factores de expansión). Usaremos `expr` (ponderador regional).
*   `data = casen`: El data frame que contiene los datos.
*   `nest = TRUE`: Argumento importante. Se usa cuando los IDs de las UPM (`varunit`) pueden repetirse entre diferentes estratos (`varstrat`), lo cual es común. Le dice a `survey` que trate, por ejemplo, `varunit = 1` en `varstrat = A` como diferente de `varunit = 1` en `varstrat = B`.


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
#summary(casen_design) 
```

**Observa la salida:** ¿Qué información te entrega R sobre el diseño que acabas de declarar? Te dice el número de estratos, el número de UPMs (PSUs), el número de observaciones y la variable de ponderación utilizada. ¡Ahora R "sabe" que esta no es una muestra simple!

## 5. Primer Cálculo Respetando el Diseño

Vamos a recalcular la **media de edad** y la **proporción de pobreza**, pero esta vez usando nuestro objeto `casen_design` y una función del paquete `survey`: `svymean()`.

`svymean()` calcula medias ponderadas y correctamente ajustadas para diseños complejos. También calcula el error estándar (SE) correcto.

*   Para variables continuas (como `edad`), calcula la media ponderada.
*   Para variables categóricas (como `pobre_dic` que es 0/1), calcula la proporción ponderada de la categoría 1.


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
# Fíjate que ahora también obtenemos el Error Estándar (SE)

# Proporción de pobreza PONDERADA
# Usamos la variable dicotómica pobre_dic (1=pobre, 0=no pobre)
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

``` r
# El 'mean' aquí es la proporción de '1' (pobres)
```

**¡Ahora compara!**

1.  Compara la `media_edad_ponderada` (el valor `mean` de la salida) con la `media_edad_ingenua` que calculaste antes. ¿Son iguales o diferentes?
2.  Compara la `prop_pobreza_ponderada` (el valor `mean` de la salida) con la `prop_pobreza_ingenua` (la proporción de '1') que calculaste antes. ¿Son iguales o diferentes?

**Pregunta de Reflexión:** ¿Por qué crees que los resultados ponderados difieren de los resultados ingenuos? ¿Qué implica esto para nuestras conclusiones si solo hubiéramos usado los cálculos ingenuos?

## 6. Conclusión

¡Felicitaciones! Has dado tus primeros pasos en el análisis de encuestas complejas en R.

*   Aprendiste a cargar datos de CASEN.
*   Identificaste las variables cruciales del diseño muestral (`expr`, `varstrat`, `varunit`).
*   Declaraste este diseño a R usando `svydesign()`.
*   Viste empíricamente cómo los **ponderadores cambian las estimaciones** puntuales usando `svymean()`.

En la próxima sesión, profundizaremos en cómo realizar más análisis (proporciones por grupo, totales) de manera más fácil usando el paquete `srvyr` y cómo interpretar los errores estándar que R calcula para nosotros.
