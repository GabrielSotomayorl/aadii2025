---
title: "Introducción a R"
linktitle: "1: Introducción a R"
date: "2024-08-09"
menu:
  example:
    parent: Ejemplos
    weight: 1
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

## 0. Objetivo del práctico

El propósito de este práctico es familiarizarnos con R y RStudio. **R es un lenguaje de programación orientado a objetos**, especialmente diseñado para el análisis estadístico y la visualización de datos. RStudio, por otro lado, proporciona un **entorno integrado de desarrollo (IDE)** que facilita el uso de R ofreciendo numerosas herramientas útiles en un solo lugar.

## 1. R como calculadora

R no solo es útil para análisis estadísticos complejos, sino también para operaciones matemáticas básicas, que luego nos permitirán trabajr con nuestras variables. A continuación, demostramos cómo usar R como calculadora:


```r
5+2
```

```
## [1] 7
```

```r
5-2
```

```
## [1] 3
```

```r
5/2
```

```
## [1] 2.5
```

```r
5*2
```

```
## [1] 10
```

## 2. Creación y manipulación de objetos

En R, podemos crear objetos para almacenar datos. A continuación, se muestra cómo asignar un valor a un objeto y cómo interactuar con él


```r
x <- 5
```

Cómo el objeto queda en el ambiente/environment, después podemos imprimir o llamar al objeto


```r
x
```

```
## [1] 5
```

Podemos crear los objetos que creamos necesarios, esta vez, crearemos un segundo objeto llamado y


```r
y <- 10
```

Ahora podemos realizar operaciones con nuestros objetos


```r
x + y
```

```
## [1] 15
```

```r
x - y
```

```
## [1] -5
```

```r
x * y
```

```
## [1] 50
```

```r
x / y
```

```
## [1] 0.5
```

También podemos guardar los resultados como objetos


```r
z <- x^2 
z
```

```
## [1] 25
```

## 3. Operaciones lógicas

También podemos realizar operaciones lógicas. Para establecer una igualdad usamos doble signo ==


```r
x > y 
```

```
## [1] FALSE
```

```r
15 == x + y 
```

```
## [1] TRUE
```

```r
16 > x + y
```

```
## [1] TRUE
```

## 4. Vectores

Un vector en R es una secuencia de elementos del mismo tipo. Crearemos una variable llamada Edad. Mediante la función concatenar "c()", podemos crear un objeto que agrupe un conjunto de datos. Para el lenguaje del software esto es un vector, para nosotros una variable, en este caso numérica (numeric): intervalar, continua, cuantitativa.


```r
edad<- c(18,25,33,38,67,25,35,57,99)
summary(edad)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   18.00   25.00   35.00   44.11   57.00   99.00
```

```r
table(edad)
```

```
## edad
## 18 25 33 35 38 57 67 99 
##  1  2  1  1  1  1  1  1
```

```r
class(edad)
```

```
## [1] "numeric"
```

También podemos realizar operaciones sobre los vectores. R aplicará la operación a cada uno de los elementos del vector y nos devolverá un vector con los resultados.  

Si aplicamos 


```r
edad/2
```

```
## [1]  9.0 12.5 16.5 19.0 33.5 12.5 17.5 28.5 49.5
```

```r
edad-1
```

```
## [1] 17 24 32 37 66 24 34 56 98
```

```r
edad2<-edad-1 #y guardar los resultados

#También podemos realziar operaciones entre vectores. 
edad/c(1,2)
```

```
## Warning in edad/c(1, 2): longitud de objeto mayor no es múltiplo de la longitud
## de uno menor
```

```
## [1] 18.0 12.5 33.0 19.0 67.0 12.5 35.0 28.5 99.0
```

Creación de una variable. "Sexo". Se sigue la misma lógica. Variable cualitativa y nominal, dicotómica. Tipo "Character" Categorías: H=Hombre; M=Mujer.


```r
sexo<-c("H","H","H","M","H","M","M","M")

summary(sexo)
```

```
##    Length     Class      Mode 
##         8 character character
```

```r
table(sexo)
```

```
## sexo
## H M 
## 4 4
```

```r
class(sexo)
```

```
## [1] "character"
```

También puede expresarse como factor siendo variable dummy (para 1 y 0). 
Variable cualitativa, nominal.


```r
s<-c(1,1,1,0,1,0,0,0,9)

#SEXO<-factor(s, levels = c(0,1,9), labels = c("Mujer","Hombre")) #importancia de los errores
sexof<-factor(s, levels = c(0,1,9), labels = c("Mujer","Hombre","NC"))

summary(sexof)
```

```
##  Mujer Hombre     NC 
##      4      4      1
```

```r
table(sexof)
```

```
## sexof
##  Mujer Hombre     NC 
##      4      4      1
```

Variable Nivel socioecon?mico. Ordinal, cualitativa.
NSE: 1=E, 2=D, 3=C3, 4=C2, 5=C1, 6=AB


```r
p1<-c(1,2,2,3,4,5,5,6,99)

nse<-factor(p1,levels=c(1,2,3,4,5,6),labels=c("E","D","C3","C2","C1","AB"))
table(nse)
```

```
## nse
##  E  D C3 C2 C1 AB 
##  1  2  1  1  2  1
```

```r
summary(nse) #NA son lo perdidos
```

```
##    E    D   C3   C2   C1   AB NA's 
##    1    2    1    1    2    1    1
```

## 5. Selección de elementos de un objeto

Podemos seleccionar elementos específicos de los vectores


```r
nse[4] #pedimos el cuarto elemento
```

```
## [1] C3
## Levels: E D C3 C2 C1 AB
```

```r
nse[1:3] #los primeros 3
```

```
## [1] E D D
## Levels: E D C3 C2 C1 AB
```

```r
nse[c(1, 3, 5)] #elementos especificos
```

```
## [1] E  D  C2
## Levels: E D C3 C2 C1 AB
```

```r
nse[37] #no existe
```

```
## [1] <NA>
## Levels: E D C3 C2 C1 AB
```

```r
nse[c(T,F)] #Podemos seleccionar con vectores lógicos, en este caso nos dará elemento por medio
```

```
## [1] E    D    C2   C1   <NA>
## Levels: E D C3 C2 C1 AB
```

```r
nse[nse=="AB"] #Seleccionar a los que cumplan ciertas características
```

```
## [1] AB   <NA>
## Levels: E D C3 C2 C1 AB
```

```r
length(nse)
```

```
## [1] 9
```

```r
class(nse)
```

```
## [1] "factor"
```

## 6. Listas

Para agrupar elementos de distintos tipos en un objeto debemos utilizar listas. Un caso particular de las listas, como veremos son los data frame o marcos de datos (comunmente llamados bases de datos).


```r
x <- list(u=c(2,3,4), v="abc")
x #el elemento u de la lista es un vector con 3 números, y el elemento v es abc
```

```
## $u
## [1] 2 3 4
## 
## $v
## [1] "abc"
```

Existen distintas formas de selecciones elementos de una lista, a partir del nombre de cada elemento con el operador **$**, o a partir de su posición dentro de la lista, ocupando corchetes dobles.  


```r
x$u
```

```
## [1] 2 3 4
```

```r
x[[2]]
```

```
## [1] "abc"
```

```r
x[[1]][2]
```

```
## [1] 3
```

```r
str(x) #este comando muestra la estructura de un objeto de manera resumida
```

```
## List of 2
##  $ u: num [1:3] 2 3 4
##  $ v: chr "abc"
```

## 7. Data frames

Un data frame es una tabla en la que cada columna es un vector de valores del mismo tipo. Los data frames son fundamentales para el manejo de datos en R.


```r
base<-data.frame(edad,
           sexof,
           nse)

base
```

```
##   edad  sexof  nse
## 1   18 Hombre    E
## 2   25 Hombre    D
## 3   33 Hombre    D
## 4   38  Mujer   C3
## 5   67 Hombre   C2
## 6   25  Mujer   C1
## 7   35  Mujer   C1
## 8   57  Mujer   AB
## 9   99     NC <NA>
```

Ver nombre de las columnas (variables)


```r
colnames(base)
```

```
## [1] "edad"  "sexof" "nse"
```

Cambiar nombre de las columnas (variables)


```r
colnames(base)<-c("edad","sexo","nse")
```

Podemos seleccionar variables con el operador $


```r
base$edad #base$variable
```

```
## [1] 18 25 33 38 67 25 35 57 99
```

Tambien podemos usar corchetes base[filas,columnas]


```r
base[5,2]
```

```
## [1] Hombre
## Levels: Mujer Hombre NC
```

```r
base[1:5,2]
```

```
## [1] Hombre Hombre Hombre Mujer  Hombre
## Levels: Mujer Hombre NC
```

```r
base[1:5,c(1,3)]
```

```
##   edad nse
## 1   18   E
## 2   25   D
## 3   33   D
## 4   38  C3
## 5   67  C2
```

Sobre una columna podemos seleccionar elementos como un un vector


```r
base$edad[1]
```

```
## [1] 18
```

```r
base$edad[base$sexo=="Hombre"] #podemos usar condiciones lógicas
```

```
## [1] 18 25 33 67
```

Funciones útiles y manejo de datos
R ofrece numerosas funciones para el análisis y manejo de datos, en las cuales iremos profundizando a lo larago del curso. Aquí introducimos algunas básicas.


```r
head(base)  #entrega los primeros elementos
```

```
##   edad   sexo nse
## 1   18 Hombre   E
## 2   25 Hombre   D
## 3   33 Hombre   D
## 4   38  Mujer  C3
## 5   67 Hombre  C2
## 6   25  Mujer  C1
```

```r
View(base) #Permite ver la base
str(base) #Nos muestra la estructura de un objeto
```

```
## 'data.frame':	9 obs. of  3 variables:
##  $ edad: num  18 25 33 38 67 25 35 57 99
##  $ sexo: Factor w/ 3 levels "Mujer","Hombre",..: 2 2 2 1 2 1 1 1 3
##  $ nse : Factor w/ 6 levels "E","D","C3","C2",..: 1 2 2 3 4 5 5 6 NA
```

```r
table(base$sexo) #tabla de frecuencias
```

```
## 
##  Mujer Hombre     NC 
##      4      4      1
```

```r
help(table) #ayuda sobre una función
```

```
## starting httpd help server ... done
```

```r
?table #Equivalente a lo anterior

mean(base$edad)
```

```
## [1] 44.11111
```

Podemos guardar la base de datos


```r
save(base, file = "base.RData") #Se indica primero el objeto a guardar 
                            #y luego el nombre del archivo, entre comillas.
```

## 8. Limpieza del entorno de trabajo
Es importante mantener un entorno de trabajo organizado, guardando y eliminando objetos según sea necesario. Podemos hacer esto a partir de la función remove().


```r
remove(edad) #borrar un objeto particular
remove(list = ls()) #Borrar todo
```




