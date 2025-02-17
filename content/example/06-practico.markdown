---
title: "Análisis Factorial Exploratorio I"
linktitle: "6: Análisis Factorial Exploratorio I"
date: "2023-04-29"
menu:
  example:
    parent: Ejemplos
    weight: 6
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---



## 0. Objetivo del práctico

El objetivo de este práctico es revisar como realizar la comprobación de supuestos y tratamiento de variables para la realización de un Análisis factorial Exploratorio. 


## 1. Carga y gestión de datos

En primer lugar, cargaremos una base de datos de PNUD 2015, que incluye los siguientes ítem. Con estos esperamos revisar si existen estructuras latentes en como las personas evalúan las oportunidades que entrega Chile. 

![](https://raw.githubusercontent.com/Clases-GabrielSotomayor/pruebapagina/master/static/slides/img/05/Practico.png)

Estos datos están en formato csv (comma separated value), por lo cual podemos leerlos con la función *read.csv2* incluida con r base.


```r
library(dplyr)
#cargamos los datos 
datos <- read.csv("https://raw.githubusercontent.com/Clases-GabrielSotomayor/pruebapagina/master/static/slides/data/EDH_2013_csv.csv") |> 
  select(salud = P25a,ingr = P25b, trab = P25c,  educ = P25d, vivi = P25e,  segur = P25f, medio = P25g, liber = P25h, proye = P25i) 
```


A continuación, revisamos los datos y daremos por perdidos los valores no sabe y no responde. 


```r
#   3.    DEFINIR VALORES PERDIDOS para Las variables, intervalares discretas de 7 categorias de las base de Datos PNUD 2015
summary(datos)
```

```
##      salud            ingr            trab            educ      
##  Min.   :1.000   Min.   :1.000   Min.   :1.000   Min.   :1.000  
##  1st Qu.:3.000   1st Qu.:2.000   1st Qu.:3.000   1st Qu.:3.000  
##  Median :4.000   Median :3.000   Median :4.000   Median :4.000  
##  Mean   :4.082   Mean   :3.433   Mean   :4.029   Mean   :3.811  
##  3rd Qu.:5.000   3rd Qu.:5.000   3rd Qu.:5.000   3rd Qu.:5.000  
##  Max.   :7.000   Max.   :7.000   Max.   :7.000   Max.   :7.000  
##  NA's   :12      NA's   :28      NA's   :32      NA's   :68     
##       vivi           segur           medio           liber      
##  Min.   :1.000   Min.   :1.000   Min.   :1.000   Min.   :1.000  
##  1st Qu.:3.000   1st Qu.:1.000   1st Qu.:3.000   1st Qu.:4.000  
##  Median :4.000   Median :3.000   Median :4.000   Median :5.000  
##  Mean   :3.993   Mean   :3.183   Mean   :4.144   Mean   :4.476  
##  3rd Qu.:5.000   3rd Qu.:5.000   3rd Qu.:5.000   3rd Qu.:6.000  
##  Max.   :7.000   Max.   :7.000   Max.   :7.000   Max.   :7.000  
##  NA's   :35      NA's   :17      NA's   :17      NA's   :23     
##      proye      
##  Min.   :1.000  
##  1st Qu.:4.000  
##  Median :5.000  
##  Mean   :4.531  
##  3rd Qu.:6.000  
##  Max.   :7.000  
##  NA's   :34
```

```r
#Categorizar como NA 8 y 9 (NS/NR).
datos <- datos %>%
  mutate(across(everything(), ~na_if(.x, 9))) %>%
  mutate(across(everything(), ~na_if(.x, 8)))
```

A continuación, exploramos los datos para conocer sus medias y distribución. En este punto es relevante revisar si existe mucha diferencia en sus niveles de variabilidad, ya que esto afectara los resultados del Análisis Factorial Exploratorio.


```r
#   4.    ANALISIS DESCRIPTIVO DE LAS VARIABLES. 
library(summarytools)
print(dfSummary(datos, headings = FALSE, method = "render"))
```

```
## 
## -------------------------------------------------------------------------------------------
## No   Variable    Stats / Values          Freqs (% of Valid)   Graph     Valid     Missing  
## ---- ----------- ----------------------- -------------------- --------- --------- ---------
## 1    salud       Mean (sd) : 4.1 (1.8)   1 : 221 (12.3%)      II        1793      12       
##      [integer]   min < med < max:        2 : 144 ( 8.0%)      I         (99.3%)   (0.7%)   
##                  1 < 4 < 7               3 : 255 (14.2%)      II                           
##                  IQR (CV) : 2 (0.4)      4 : 361 (20.1%)      IIII                         
##                                          5 : 422 (23.5%)      IIII                         
##                                          6 : 239 (13.3%)      II                           
##                                          7 : 151 ( 8.4%)      I                            
## 
## 2    ingr        Mean (sd) : 3.4 (1.7)   1 : 337 (19.0%)      III       1777      28       
##      [integer]   min < med < max:        2 : 240 (13.5%)      II        (98.4%)   (1.6%)   
##                  1 < 3 < 7               3 : 345 (19.4%)      III                          
##                  IQR (CV) : 3 (0.5)      4 : 344 (19.4%)      III                          
##                                          5 : 281 (15.8%)      III                          
##                                          6 : 143 ( 8.0%)      I                            
##                                          7 :  87 ( 4.9%)                                   
## 
## 3    trab        Mean (sd) : 4 (1.7)     1 : 179 (10.1%)      II        1773      32       
##      [integer]   min < med < max:        2 : 165 ( 9.3%)      I         (98.2%)   (1.8%)   
##                  1 < 4 < 7               3 : 267 (15.1%)      III                          
##                  IQR (CV) : 2 (0.4)      4 : 436 (24.6%)      IIII                         
##                                          5 : 390 (22.0%)      IIII                         
##                                          6 : 212 (12.0%)      II                           
##                                          7 : 124 ( 7.0%)      I                            
## 
## 4    educ        Mean (sd) : 3.8 (1.7)   1 : 232 (13.4%)      II        1737      68       
##      [integer]   min < med < max:        2 : 191 (11.0%)      II        (96.2%)   (3.8%)   
##                  1 < 4 < 7               3 : 295 (17.0%)      III                          
##                  IQR (CV) : 2 (0.5)      4 : 376 (21.6%)      IIII                         
##                                          5 : 345 (19.9%)      III                          
##                                          6 : 194 (11.2%)      II                           
##                                          7 : 104 ( 6.0%)      I                            
## 
## 5    vivi        Mean (sd) : 4 (1.7)     1 : 210 (11.9%)      II        1770      35       
##      [integer]   min < med < max:        2 : 164 ( 9.3%)      I         (98.1%)   (1.9%)   
##                  1 < 4 < 7               3 : 279 (15.8%)      III                          
##                  IQR (CV) : 2 (0.4)      4 : 370 (20.9%)      IIII                         
##                                          5 : 390 (22.0%)      IIII                         
##                                          6 : 237 (13.4%)      II                           
##                                          7 : 120 ( 6.8%)      I                            
## 
## 6    segur       Mean (sd) : 3.2 (1.8)   1 : 487 (27.2%)      IIIII     1788      17       
##      [integer]   min < med < max:        2 : 224 (12.5%)      II        (99.1%)   (0.9%)   
##                  1 < 3 < 7               3 : 301 (16.8%)      III                          
##                  IQR (CV) : 4 (0.6)      4 : 313 (17.5%)      III                          
##                                          5 : 242 (13.5%)      II                           
##                                          6 : 156 ( 8.7%)      I                            
##                                          7 :  65 ( 3.6%)                                   
## 
## 7    medio       Mean (sd) : 4.1 (1.7)   1 : 191 (10.7%)      II        1788      17       
##      [integer]   min < med < max:        2 : 146 ( 8.2%)      I         (99.1%)   (0.9%)   
##                  1 < 4 < 7               3 : 248 (13.9%)      II                           
##                  IQR (CV) : 2 (0.4)      4 : 401 (22.4%)      IIII                         
##                                          5 : 372 (20.8%)      IIII                         
##                                          6 : 291 (16.3%)      III                          
##                                          7 : 139 ( 7.8%)      I                            
## 
## 8    liber       Mean (sd) : 4.5 (1.6)   1 : 141 ( 7.9%)      I         1782      23       
##      [integer]   min < med < max:        2 :  91 ( 5.1%)      I         (98.7%)   (1.3%)   
##                  1 < 5 < 7               3 : 203 (11.4%)      II                           
##                  IQR (CV) : 2 (0.4)      4 : 383 (21.5%)      IIII                         
##                                          5 : 452 (25.4%)      IIIII                        
##                                          6 : 331 (18.6%)      III                          
##                                          7 : 181 (10.2%)      II                           
## 
## 9    proye       Mean (sd) : 4.5 (1.6)   1 : 110 ( 6.2%)      I         1771      34       
##      [integer]   min < med < max:        2 :  97 ( 5.5%)      I         (98.1%)   (1.9%)   
##                  1 < 5 < 7               3 : 204 (11.5%)      II                           
##                  IQR (CV) : 2 (0.3)      4 : 373 (21.1%)      IIII                         
##                                          5 : 471 (26.6%)      IIIII                        
##                                          6 : 351 (19.8%)      III                          
##                                          7 : 165 ( 9.3%)      I                            
## -------------------------------------------------------------------------------------------
```

##  2.  Comprobación de supuestos

En este bloque de código, se cargan las bibliotecas necesarias para realizar la comprobación de supuestos.


```r
library(psych)
library(MVN)
```

Para la comprobación de supuestos partiremos por generar una base de datos listwise, es decir, en la que se eliminan todos los casos que tienen valores perdidos en alguno de los ítem. Esto es posible en este caso por el número moderado de casos perdidos existentes. Pasamos de tener 1780 casos a 1632.


```r
#   5a.   Crear una base solo con listwise (para test de Mardia)
datosLW <- na.omit(datos)
dim(datosLW)
```

```
## [1] 1654    9
```

A continuación, revisaremos la existencia de casos atípicos multivariantes a partir del cálculo y evaluación de la distancia de Mahalanobis. Primero se crean las medias para cada variable (mean) y la matriz de covarianzas (Sx) para calcular la distancia de mahalanobis con la función correspondiente. 

Luego se calcula el valor p asociado con cada distancia de Mahalanobis D2 y se guarda como una nueva variable: datosLW$sigmahala=(1-pchisq(D2, 9)).

Finalmente se filtran los casos atípicos multivariantes según el valor p de la distancia de mahalanobis, y se elimina la variable creada en el paso anterior.


```r
#Tratamiento de casos atipicos
mean<-colMeans(datosLW[1:9])
Sx<-cov(datosLW[1:9]) #matriz de varianza covariaza 
D2<-mahalanobis(datosLW[1:9],mean,Sx)

datosLW$sigmahala=(1-pchisq(D2, df = 9))  # Usando 9 grados de libertad

#eliminar casos atipicos
datosLW <- datosLW %>%
  filter(sigmahala > 0.001) %>%
  select(-sigmahala)
```

A continuación, utilizamos la función **mvn**  para evaluar la normalidad multivariante y univariante en un conjunto de datos. Especificamos que utilice el test de Mardia para evaluar la existencia de normalidad multivariante en nuestros datos.   

El output de esta función tiene 4 elementos: en gráfico q-q que compara la distribución multivariante de los datos con una normal, los resultados de la prueba de Mardia para evaluar la normalidad multivariante, los resultados de la prueba de Anderson-Darling para evaluar la normalidad univariante de cada variable en el conjunto de datos y estadísticas descriptivas para cada variable en el conjunto de datos, entre las que resulta particularmente relevante la asimetría, que en caso de no existir normalidad, se espera que se encuentra dentro del rango +-2.


```r
  #Test de Mardia.
MVN::mvn(datosLW,mvnTest	= "mardia",multivariatePlot="qq")
```

<img src="/example/06-practico_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```
## $multivariateNormality
##              Test        Statistic               p value Result
## 1 Mardia Skewness 1729.47785876834 1.34356485870314e-258     NO
## 2 Mardia Kurtosis 33.0432346855492                     0     NO
## 3             MVN             <NA>                  <NA>     NO
## 
## $univariateNormality
##               Test  Variable Statistic   p value Normality
## 1 Anderson-Darling   salud     31.8929  <0.001      NO    
## 2 Anderson-Darling   ingr      31.6696  <0.001      NO    
## 3 Anderson-Darling   trab      30.0160  <0.001      NO    
## 4 Anderson-Darling   educ      29.0099  <0.001      NO    
## 5 Anderson-Darling   vivi      29.5427  <0.001      NO    
## 6 Anderson-Darling   segur     45.2613  <0.001      NO    
## 7 Anderson-Darling   medio     31.0955  <0.001      NO    
## 8 Anderson-Darling   liber     36.9583  <0.001      NO    
## 9 Anderson-Darling   proye     37.3868  <0.001      NO    
## 
## $Descriptives
##          n     Mean  Std.Dev Median Min Max 25th 75th        Skew   Kurtosis
## salud 1591 4.055940 1.725871      4   1   7    3    5 -0.22717877 -0.7792271
## ingr  1591 3.462602 1.725416      3   1   7    2    5  0.19055267 -0.8519259
## trab  1591 4.012571 1.630246      4   1   7    3    5 -0.16992697 -0.6457336
## educ  1591 3.817096 1.698644      4   1   7    3    5 -0.05949038 -0.8496713
## vivi  1591 3.971716 1.699376      4   1   7    3    5 -0.15334896 -0.8108244
## segur 1591 3.204903 1.791525      3   1   7    1    5  0.30840123 -0.9764130
## medio 1591 4.082967 1.693689      4   1   7    3    5 -0.23857539 -0.7504117
## liber 1591 4.420490 1.629078      5   1   7    3    6 -0.46962149 -0.3959629
## proye 1591 4.485229 1.566433      5   1   7    4    6 -0.49369218 -0.3003321
```

Tanto el test de mardia como la prueba de normalidad univariante para cada variable dan cuenta de que no existe normalidad, lo cual debe tenerse en cuenta al seleccionar la forma de extracción de los factores. También nos indica que más adelante no será posible interpretar la preuba de esfericidad de Barlett para multicolinealdiad, ya que esta supone normalidad multivariante.

A pesar de que no existe normalidad multivariante, encontramos una asimetría moderada, por lo que es posible continuar con el análisis.   

A continuación calculamos la matriz de correlaciones para evaluar la existencia de colinealidad. Esto es relevante porque es necesario que exista suficiente varianza común entre las variables para la extracción de factores comunes. 


```r
#Matriz de Correlaciones 
#Uso de Pearson por caracteristicas de las variables (discretas de baja asimetria)

cor_datos<- cor(datosLW)
print(cor_datos)
```

```
##           salud      ingr      trab      educ      vivi     segur     medio
## salud 1.0000000 0.6998917 0.6428539 0.6777664 0.6475043 0.5090866 0.5814939
## ingr  0.6998917 1.0000000 0.6702718 0.6928244 0.6625396 0.6149054 0.5808554
## trab  0.6428539 0.6702718 1.0000000 0.7598514 0.7268128 0.5109832 0.6105283
## educ  0.6777664 0.6928244 0.7598514 1.0000000 0.7969429 0.5986460 0.6490793
## vivi  0.6475043 0.6625396 0.7268128 0.7969429 1.0000000 0.6175165 0.6487104
## segur 0.5090866 0.6149054 0.5109832 0.5986460 0.6175165 1.0000000 0.5919668
## medio 0.5814939 0.5808554 0.6105283 0.6490793 0.6487104 0.5919668 1.0000000
## liber 0.5763626 0.5277238 0.6653509 0.6485083 0.6565347 0.4773054 0.7185909
## proye 0.5652700 0.5575204 0.7044475 0.6715690 0.6794626 0.4674596 0.6421821
##           liber     proye
## salud 0.5763626 0.5652700
## ingr  0.5277238 0.5575204
## trab  0.6653509 0.7044475
## educ  0.6485083 0.6715690
## vivi  0.6565347 0.6794626
## segur 0.4773054 0.4674596
## medio 0.7185909 0.6421821
## liber 1.0000000 0.8144031
## proye 0.8144031 1.0000000
```

```r
print(det(cor_datos))#Cercano a 0 correlacion multivariante
```

```
## [1] 0.00071532
```

La matriz de correlaciones da cuenta de un alto nivel de correlación entre las variables. Como criterio general se espera que existan correlaciones de al menos 0,3. 

El determinante de la matriz de correlaciones se calcula con la función det(). Un determinante cercano a 0 indica que existe correlación multivariante entre las variables. En este caso, el determinante es 0.0001593243, lo que sugiere que hay  colinealidad entre las variables.

A continuación se presenta como calcular una matriz de correlaciones policóricas para el caso de estar trabajando con variables ordinales. En caso de variable dicotómicas (0-1) corresponde usar correlaciones tetracóricas mediante la función 'tetrachoric()'.


```r
#Probar con matriz policlorica en caso de estar trabajando con variables ordinales.
polychoric(datosLW)
```

```
## Call: polychoric(x = datosLW)
## Polychoric correlations 
##       salud ingr trab educ vivi segur medio liber proye
## salud 1.00                                             
## ingr  0.74  1.00                                       
## trab  0.67  0.71 1.00                                  
## educ  0.70  0.73 0.79 1.00                             
## vivi  0.67  0.70 0.76 0.83 1.00                        
## segur 0.54  0.66 0.55 0.64 0.66 1.00                   
## medio 0.61  0.62 0.64 0.68 0.68 0.64  1.00             
## liber 0.60  0.56 0.70 0.68 0.69 0.52  0.75  1.00       
## proye 0.59  0.59 0.73 0.71 0.71 0.51  0.68  0.84  1.00 
## 
##  with tau of 
##           1     2      3      4    5   6
## salud -1.18 -0.84 -0.392  0.154 0.81 1.4
## ingr  -0.92 -0.49  0.035  0.549 1.14 1.7
## trab  -1.31 -0.87 -0.402  0.256 0.90 1.5
## educ  -1.14 -0.71 -0.220  0.333 0.95 1.6
## vivi  -1.21 -0.80 -0.320  0.225 0.86 1.5
## segur -0.64 -0.29  0.167  0.652 1.16 1.8
## medio -1.24 -0.88 -0.419  0.181 0.76 1.5
## liber -1.41 -1.11 -0.672 -0.069 0.62 1.3
## proye -1.53 -1.19 -0.712 -0.111 0.59 1.4
```

Por último, chequeamos la existencia de multicolinealidad. Con fines de presentar el código, se calcula la prueba de esfericidad de Bartlett, sin embargo esta no puede interpretarse de manera confiable, ya que esta presupone normalidad multivariante, la cual no existe en este caso. 

La prueba de esfericidad de Bartlett evalúa si la matriz de correlaciones es significativamente diferente de la matriz de identidad. En otras palabras, contrasta la hipótesis nula de que las variables no están correlacionadas en absoluto (es decir, la matriz de correlaciones es igual a la matriz de identidad). La función toma los como argumento la matriz de correlaciones y el n.


```r
#   5c.   MULTICOLINEALIDAD
#Test de esfericidad de Bartlett. Contrastar la hipotesis Nula de Igualdad con Matriz identidad

print(cortest.bartlett(cor_datos,n = nrow(datosLW)))
```

```
## $chisq
## [1] 11488.26
## 
## $p.value
## [1] 0
## 
## $df
## [1] 36
```

En este caso, el valor chi-cuadrado es 11479.18 y el valor p es muy pequeño, lo que indica que se debe rechazar la hipótesis nula de que la matriz de correlaciones es igual a la matriz de identidad. Esto sugiere que hay correlaciones entre las variables y es apropiado continuar con el análisis factorial exploratorio.

La función **KMO()** calcula la medida de adecuación del muestreo de Kaiser-Meyer-Olkin (KMO) para evaluar la adecuación de los datos para el análisis factorial. La medida KMO varía entre 0 y 1, y valores más altos indican que el análisis factorial es más adecuado para los datos. 


```r
#KMO
KMO(datosLW)
```

```
## Kaiser-Meyer-Olkin factor adequacy
## Call: KMO(r = datosLW)
## Overall MSA =  0.93
## MSA for each item = 
## salud  ingr  trab  educ  vivi segur medio liber proye 
##  0.95  0.92  0.95  0.94  0.94  0.93  0.94  0.88  0.90
```

El output incluye:

- Overall MSA: La medida KMO general para todo el conjunto de datos.  
- MSA for each item: La medida KMO para cada variable en el conjunto de datos.  

En este caso, la medida KMO general es 0.94, lo que indica una adecuación muy alta para el análisis factorial. Además, las medidas KMO para cada variable también son altas (entre 0.88 y 0.95), lo que sugiere que cada variable contribuye adecuadamente al análisis factorial.
