---
title: "Tarea 1. Procesamiento de datos en R"
linktitle: "1: Procesamiento de datos en R"
date: "2021-09-08"
due_date: "2022-09-26"
due_time: "11:59 PM"
menu:
  assignment:
    parent: Tareas
    weight: 1
type: docs
toc: true
editor_options:
  chunk_output_type: console
---

Esta tarea debe ser resuelta en GitHub Class Room. Para acceder a la <i class="fas fa-external-link-square-alt"></i>  [Tarea N°1 hacer click aquí](https://classroom.github.com/a/uLbXEXPF). Si aún tienes dudas de cómo interactuar con [GitHub Class Roomm revisa el práctico](https://learn-r-uah.netlify.app/example/01-practico/)

## Objetivo

La tarea N°1 consiste en la creación de un script (archivo .R) en R, este les permitirá construir datos limpios y procesados, que a la vez servirán de "input" para los análisis exploratorios a reportar (tarea N°2). El ejercicio que deben realizar se basa en un caso simulado de "trabajo" que les han solicitado

### Instrucciones

En su nuevo trabajo como investigadores/as les han encargado hacer un estudio sobre el efecto de la pandemia sobre el empleo. Para ello, les han solicitado a ustedes la recopilación y procesamiento de una serie de datos relevantes para iniciar el estudio. De manera preliminar, le solicitan los siguientes puntos

1. Debe ocupar la Encuesta Nacional de Empleo (ENE) del Instituto Nacional de Estadísticas, particularmente el trimestre *Octubre-Noviembre-Diciembre* del año 2019 y del 2021. 

2. Las variables que más interesan para el informe son: condición de actividad económica general (*CAE*), no general (*Condición de actividad*) y las horas de trabajo de la actividad principal (*Modulo C*)

3. También le han indicado que hay ciertas variables socio demográficas de interés como el nivel educacional (*CINE*), edad y sexo 

### Instrucciones específicas

En su equipo de investigación quieren realizar los siguientes análisis, para lo cuál usted debe construir un data set procesado llamado *datos_proc.RData* que permita realizar estos análisis de manera debida

0. Los análisis solo deben considerar a las personas en edad de trabajar *según las definiciones del Instituto Nacional de Estadística.*

1. Un análisis de la distribución de socio demográficos de nivel educacional, edad y sexo. Le han solicitado que el nivel educacional esté solo clasificado en *"Superior completa", "Media y básica completa" y "Básica o menos incompleta"*, que la edad esté clasificada *en tramos de "15 a 39 años", "40 a 64 años" y "65 y más"*; sexo debe estar codificada como *"Mujer" y "Hombre".* 

2. Un análisis de la distribución de la condición de actividad económica, situación de empleo y las suma de horas trabajadas en la actividad principal para la muestra del 2019 y 2021.

3. Una persona del equipo sospecha de la variable de condición de actividad que no es general (*activ*). Por ello, le piden que cree una nueva variable llamada *"cae_corregido"* en base a la definición que se hace de esta variable en el manual metodológico.

**Atención**: la ejecución concreta de los análisis serán parte de la tarea N°3. **Por ahora usted debe preocuparse** de: 

1. Construir un Rproject ordenado según los criterios establecidos en el curso (01-tarea.Rproj)

2. Construir un script llamado *procesamiento-datos.R* que esté alojado en la carpeta que corresponda. Este script debe tener un orden y utilizar los comentarios (#) para hacer referencia a los procesos realizados

3. Cargar los paquetes y datos necesarios para el procesamiento

4. Filtrar, seleccionar y crear las variables indicadas (no olvides crear el índice sumativo)

5. Una vez limpios los datos del 2019 y del 2021, unir los datos en un único objeto llamado "ene_unida"

6. Guardar los datos procesados del 2019, 2021 y la unión de ambos en un archivo llamado *datos_proc.RData*. 

7. Deben dejar los datos originales en la carpeta correspondiente (si son muy pesados, indicar en el .gitignore) 


## Puntaje adicional

Si incorporan un README.md con la explicación de dónde sacaron los datos e información metodológica, será bonificado con 0,4 décimas.

Si logran cargar los datos mediante link **Y**, explica cómo hacerlo en el canal #tareas (0.2 décimas)

## Pauta

1. RMarkdown, este ítem evalúa aspectos propios de los archivos .Rmd, desde su estructura hasta su correcto funcionamiento. Es necesario considerar:

   a. Aspectos formales: títulos, nombres, información institucional, fecha, etc.
    
   b. Estructura de los archivos .Rmd
    
   c. Uso correcto y constante de markdown
    
   d. Aspectos solicitados según cada tarea, por ejemplo:
    - Análisis: en estos archivos irán tanto sus reportes como el análisis que realicen
    - Replicación de informes: esto incluye la replicación de análisis con sus outputs, ya sean tablas, gráficos o lo que se solicite en la respectiva tarea.



1. Flujo: Este ítem se encarga de evaluar el flujo de trabajo desarrollado en el curso, para ello se debe considerar los elementos que hacen posible el correcto uso del flujo, para obtener buen puntaje en este ítem deben:

   a. Seguir detalladamente las instrucciones
  
   b. Crear las carpetas y archivos requeridos en cada tarea
  
   c. Nombrar **adecuadamente** los archivos/datos/carpetas 
  
   d. Todos los archivos por utilizar deben estar en su lugar correspondiente.
   


1. R: Este ítem evalúa elementos relacionados a archivos .R. Este puede dividirse en dos etapas a lo largo del curso (Debe seguir un orden lógico):

   a. Carga: esta etapa es necesaria para pasar a procesamiento 
  
   b. Procesamiento: etapa donde se preparan los datos para ser utilizados en el análisis. 



1. Markdown: este ítem evalúa aspectos propios del formato en markdown, ya que su uso será constante en este curso [ver recursos](https://learn-r-uah.netlify.app/resource/markdown/) 


1. Reproducibilidad: En este curso es muy relevante la reproducibilidad, para ello es necesario tener en cuenta lo siguiente:
    
   a. El archivo .R debe poder ejecutarse sin problemas por cualquier persona con el programa, siguiendo el orden lógico requerido para ello.
  
   b. El archivo .Rmd debe poder ejecutarse sin problemas por cualquier persona con el programa. Esto implica que tanto los archivos/tablas/códigos deben visualizarse correctamente en su producto (output) final
Este punto será esencial para lo que más adelante veremos como condición de suficiencia.

1. Condición de suficiencia: son elementos esenciales que si no son cumplidos la asignación de puntaje del ítem será 0, independiente de si lo que sigue a ese punto está realizado correctamente. Deben tener en cuenta que este ítem no será inmediato, sino que será a medida vaya avanzando el curso.

1. Bonus: En el curso habrá constantemente aspectos que brindarán puntos y/o décimas dependiendo de la tarea.

1. Descuentos: ítem que considera descuentos en puntos o décimas por el no logro o ausencia de aspectos de los ítems anteriores.

Si utiliza otros paquetes para resolver la tarea **DEBE** explicar la razón del uso esos paquetes y qué ventajas tienen por sobre los utilizados en el curso, de no ser así se descontará con 0.5 puntos. 


## Formato

- Recuerden que puede ser realizada en pareja, la que les fue asignada. 


## Recursos

- <i class="fas fa-book"></i> Hadley Wickham, ["R para ciencia de datos - Como usar RMarkdown"](https://es.r4ds.hadley.nz/r-markdown.html) 

- <i class="fab fa-book"></i> Recursos
  - [Recursos del curso](https://learn-r-uah.netlify.app/resource/) 
  - [Tutorial dplyr](https://www.youtube.com/watch?v=APzU10EMMjg)

- <i class="fas fa-external-link-square-alt"></i> [Sesión N°2](/content/02-content)
- <i class="fas fa-external-link-square-alt"></i> [Sesión N°3](/content/03-content)
- <i class="fas fa-external-link-square-alt"></i> [Sesión N°4](/content/04-content)
- <i class="fas fa-external-link-square-alt"></i> [Sesión N°5](/content/05-content)

- <i class="fas fa-external-link-square-alt"></i> [Práctico N°2](/example/02-practico)
- <i class="fas fa-external-link-square-alt"></i> [Práctico N°3](/example/03-practico)
- <i class="fas fa-external-link-square-alt"></i> [Práctico N°4](/example/04-practico)
- <i class="fas fa-external-link-square-alt"></i> [Práctico N°5](/example/05-practico)

