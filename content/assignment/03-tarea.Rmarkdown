---
title: "Tarea 3. Muestras complejas"
linktitle: "3: Muestras complejas"
date: "2021-10-01"
due_date: "2022-11-07"
due_time: "23:59 PM"
menu:
  assignment:
    parent: Tareas
    weight: 1
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---

Esta tarea debe ser resuelta en GitHub Class Room. Para acceder a la <i class="fas fa-external-link-square-alt"></i>  [Tarea N°3 hacer click aquí](https://classroom.github.com/a/sh7Oqadk). Si aún tienes dudas de cómo interactuar con [GitHub Class Roomm revisa el práctico](https://learn-r-uah.netlify.app/example/01-practico/)

## Objetivo

La tarea N°3 busca evaluar la unidad de muestras complejas utilizando R, en base a la creación de un *informe reproducible en RMarkdown*. Este informe se basa en la replicación de estadísticos reportados por otras instituciones públicas y académicas. Considere que los conocimientos a evaluar en la tarea N°3 requieren de un manejo sustantivo de los contenidos anteriormente vistos en clases.   

### Instrucciones

Debe seleccionar alguno de los dos siguientes reportes para su replicación

1. [Radiografía del cambio social](https://drive.google.com/file/d/1Yh8KajQsmHs2X-kt5kSuliUFuBDfV5-h/view) en base a la Encuesta Longitudinal Social del Centro de Estudios de Conflicto y Cohesión Social [(COES)](https://coes.cl/encuesta-panel/)


2. [Modulo COVID - Boletín Complementario](https://www.ine.cl/docs/default-source/sueldos-y-salarios/boletines/espa%C3%B1ol/base-anual-2016-100/m%C3%B3dulo-covid-19-ir-icmo/bolet%C3%ADn-covid-19-(septiembre-a-diciembre-2021).pdf?sfvrsn=a9b3ae37_4) en base a la encuesta Índice de Remuneraciones e Índice de Costo de Mano de Obra (ICMO-IR) del [Instituto Nacional de Estadística](https://www.ine.cl/ine-ciudadano/definiciones-estadisticas/economia/indice-de-remuneraciones)


#### Instrucciones específicas para cada informe


**1. [Radiografía del cambio social](https://drive.google.com/file/d/1Yh8KajQsmHs2X-kt5kSuliUFuBDfV5-h/view)**

- Debe utilizar la Encuesta Longitudinal Social del Centro de Estudios de Conflicto y Cohesión Social [(COES)](https://coes.cl/encuesta-panel/) del año 2019

- Debe replicar los análisis reportados en la lámina 44, 45, 53, 58 y 74

- Además de la estimación puntual debe reportar los intervalos de confianza.

- Con los datos construidos debe crear al menos una tabla y un gráfico (puede seleccionar cualquier indicador para el gráfico).

- En caso de no llegar a los mismos resultados, investigue y discuta posibles razones de porqué no llegó al mismo resultado del informe. 

**2. [Modulo COVID - Boletín Complementario](https://www.ine.cl/docs/default-source/sueldos-y-salarios/boletines/espa%C3%B1ol/base-anual-2016-100/m%C3%B3dulo-covid-19-ir-icmo/bolet%C3%ADn-covid-19-(septiembre-a-diciembre-2021).pdf?sfvrsn=a9b3ae37_4)**

- Debe utilizar la encuesta Índice de Remuneraciones e Índice de Costo de Mano de Obra (ICMO-IR) del [Instituto Nacional de Estadística](https://www.ine.cl/ine-ciudadano/definiciones-estadisticas/economia/indice-de-remuneraciones) del mes de noviembre 2021.

- Debe replicar los análisis reportados en la tabla N°1, N°2, N°3 y N°6.

- Además de la estimación puntual, debe reportar los intervalos de confianza.

- Con los datos construidos debe crear al menos una tabla y un gráfico (puede seleccionar cualquier indicador para el gráfico).

- En caso de no llegar a los mismos resultados, investigue y discuta posibles razones de porqué no llegó al mismo resultado del informe. 


**En general**, su proyecto de R (03-tarea.Rproj) debe contener:

**1. R script con procesamiento de datos modificado (`R/01-proc.R`)**
  
  1.1 Datos originales en carpeta *input* (si son muy pesados, indicar en el .gitignore)     
  1.2 Datos procesados (`output/datos/datos_proc.rds`)

**2. Informe descriptivo de los datos**

  2.1 Archivo en RMarkdown que contiene los análisis solicitados en el equipo 02-analisis.Rmd
  2.2 Archivo en html que contiene el informe compilado (02-analisis.html). *Si logra dejar el informe en .pdf tendrá 0.3 adicionales a su nota. Hint: descargar y revisar el paquete tinytext*
  
**3. Adicionales** (0.2 décimas por cada uno)

- 3.1 README.md con explicaciones generales para que cualquier usuario pueda reproducir sus análisis (explicar las carpetas, datos descargados y desde donde). Algunos elementos del procesamiento deben ser indicados aquí

- 3.2 Contribuir con preguntas de compañeras/os sobre **problemas en código** (no sobre instrucciones sobre la tarea)

- 3.3 Documentos que [editen su formato en html](https://www.datadreaming.org/post/r-markdown-theme-gallery/)

- 3.4 Cambiar color y editar sus gráficos de sjPlot.  
  

### Sobre el reporte

Deben crear un reporte en RMarkdown reproducible que contenga

1. Título, subítulo, nombre de autores, fecha. Además información institucional que puede poner en los subtitulos (universidad, carrera, profesora, ayudante)

2. Presentación de la base

- Descripción de la base en fecha de realización, número de observaciones e indicar las variables utilizadas en el análisis.
  
- *No mostrar chunk de funciones que les dan dimensiones*

- Indicar paquetes con los cuales se realizará el análisis

- Mostrar chunk donde se cargan paquetes
  
3. Tablas y gráficos

- Deben ser realizados preferentemente con sjPlot

- Las tablas también pueden ser realizadas con *kable*

**No olvide los conocimientos evaluados en la tarea N°1** pues también son evaluados. Solo para recordar deben incorporar los siguientes elementos:

1. Un encabezado (YAML) con el título: “Tarea N°1”. También deben incorporar su nombre y fecha. Este encabezado debe tener una salida (output), esta debe ser en html (*si logran agregar una en pdf tendrán bonus*)

2. Texto que indique dos subtítulos que separarán los apartados del documento. Deben ocupar **negritas**, *cursivas* y otros aspectos del formato md cuando sea necesario.

3. Chunks: no olvide las opciones de los chunks (algunos deben estar ocultos y otros no).

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

- Recuerde revisar los materiales otorgados por las instituciones (de hecho, en algunos casos sus investigadores/as utilizan GitHub)
  

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
- <i class="fas fa-external-link-square-alt"></i> [Práctico N°6](/example/06-practico)
- <i class="fas fa-external-link-square-alt"></i> [Práctico N°7](/example/07-practico)

