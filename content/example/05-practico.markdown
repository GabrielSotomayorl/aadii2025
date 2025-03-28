---
title: "5. Análisis de Encuestas Complejas con `srvyr`"
linktitle: "5. Análisis con `srvyr`" 
date: "2025-04-07" 
menu:
  example:
    parent: Ejemplos
    weight: 5 
type: docs
toc: true
editor_options: 
  chunk_output_type: console
---



## 0. Objetivos del Práctico

En esta sesión, pondremos en práctica los conceptos de análisis de encuestas complejas utilizando principalmente el paquete `srvyr` por su sintaxis amigable estilo `tidyverse`. Al finalizar, podrás:

1.  **Crear** un objeto de diseño muestral (`tbl_svy`) utilizando `srvyr`.
2.  **Calcular** estimaciones descriptivas ponderadas (medias, proporciones, totales) usando `summarise` y las funciones `survey_*`.
3.  **Obtener e interpretar** medidas de incertidumbre como errores estándar (SE) e intervalos de confianza (IC) para estas estimaciones.
4.  Realizar **análisis descriptivos por subgrupos** de manera eficiente usando `group_by`.
5.  **Visualizar** resultados ponderados utilizando `ggplot2` después de calcular las estadísticas con `srvyr`.

## 1. Preparación y Declaración del Diseño con `srvyr`

Comenzamos cargando los paquetes necesarios y los datos de CASEN 2022 (igual que en el práctico anterior). Además de `tidyverse`, `haven` y `survey`, ahora cargamos `srvyr`.


``` r
# Cargar paquetes
library(tidyverse)
library(haven)
library(survey)
library(srvyr) # ¡El paquete clave de hoy!

# --- Código para cargar CASEN 2022 (del práctico anterior) ---
# Crear un archivo temporal para la descarga
temp <- tempfile() 

# Descargar el archivo .zip que contiene la base de datos SPSS
download.file("https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2022/Base%20de%20datos%20Casen%202022%20SPSS.sav.zip", temp, mode = "wb") 

# Leer el archivo .sav 
casen <- haven::read_sav(unz(temp, "Base de datos Casen 2022 SPSS.sav")) 

# Eliminar el archivo temporal
unlink(temp)
remove(temp) 

# (Recodificación de pobreza del práctico anterior, por si acaso)
if (!"pobre_dic" %in% names(casen)) {
  casen <- casen %>% 
    mutate(pobre_dic = ifelse(pobreza %in% c(1, 2), 1, 0))
}

print("Paquetes y datos CASEN 2022 cargados.")
```

```
## [1] "Paquetes y datos CASEN 2022 cargados."
```

``` r
# --- Fin del código de carga ---
```

Ahora, creamos el objeto de diseño `tbl_svy` usando `srvyr::as_survey_design()`.


``` r
# Crear el objeto tbl_svy con srvyr
casen_design_srvyr <- as_survey_design(casen, 
                                       ids = varunit,    # Variable de conglomerados (UPM)
                                       strata = varstrat, # Variable de estratos
                                       weights = expr,    # Variable de ponderador regional
                                       nest = TRUE)       # IDs de UPM se repiten entre estratos

# Inspeccionar el objeto creado con srvyr
print(casen_design_srvyr)
```

```
## Stratified 1 - level Cluster Sampling design (with replacement)
## With (12062) clusters.
## Called via srvyr
## Sampling variables:
##   - ids: varunit 
##   - strata: varstrat 
##   - weights: expr 
## Data variables: 
##   - id_vivienda (dbl), folio (dbl), id_persona (dbl), region (dbl+lbl), area
##     (dbl+lbl), cod_upm (dbl), nse (dbl+lbl), estrato (dbl), hogar (dbl), expr
##     (dbl), expr_osig (dbl), varstrat (dbl), varunit (dbl), fecha_entrev (date),
##     p1 (dbl+lbl), p2 (dbl+lbl), p3 (dbl+lbl), p4 (dbl+lbl), p9 (dbl), p10
##     (dbl+lbl), p11 (dbl), tot_per_h (dbl), h1 (dbl+lbl), edad (dbl),
##     mes_nac_nna (dbl+lbl), ano_nac_nna (dbl+lbl), sexo (dbl+lbl), pco1_a
##     (dbl+lbl), pco1_b (dbl+lbl), pco1 (dbl+lbl), h5_cp (dbl+lbl), h5_sp
##     (dbl+lbl), h5_b1_1 (dbl), h5_b1_2 (dbl), h5a_2 (dbl+lbl), h5_b2_1 (dbl),
##     h5_b2_2 (dbl), h5a_3 (dbl+lbl), h5_b3_1 (dbl), h5_b3_2 (dbl), h5a_4
##     (dbl+lbl), h5b (dbl), ecivil (dbl+lbl), h5_10 (dbl+lbl), h5_1a (dbl), h5_1b
##     (dbl), h5_20 (dbl+lbl), h5_2 (dbl), n_nucleos (dbl), nucleo (dbl), pco2_a
##     (dbl+lbl), pco2_b (dbl+lbl), pco2 (dbl+lbl), h7a (dbl+lbl), h7b (dbl+lbl),
##     h7c (dbl+lbl), h7d (dbl+lbl), h7e (dbl+lbl), h7f (dbl+lbl), informante
##     (dbl+lbl), e1 (dbl+lbl), e3 (dbl+lbl), e4a (dbl+lbl), e4a_esp (chr), e5a
##     (dbl+lbl), e5a_esp (chr), e5b (dbl+lbl), e6a_asiste (dbl+lbl),
##     e6a_no_asiste (dbl+lbl), e6a (dbl+lbl), e6b_asiste (dbl+lbl), e6b_no_asiste
##     (dbl+lbl), e6b (dbl+lbl), e6c_completo (dbl+lbl), e6d_preg (dbl+lbl),
##     e6d_postg (dbl+lbl), e7 (chr), cinef13_area (dbl+lbl), cinef13_subarea
##     (dbl+lbl), e8 (dbl+lbl), e9nom (chr), e9dir (chr), e9com_cod (dbl+lbl),
##     e9pais_cod (dbl+lbl), e9rbd (dbl+lbl), e9rbd_sup (dbl+lbl), e9dv (chr),
##     e9depen (dbl+lbl), e10 (dbl+lbl), e11 (dbl+lbl), e12a (dbl+lbl), e12b
##     (dbl+lbl), e12c (dbl+lbl), e12d (dbl+lbl), e12e (dbl+lbl), e13a (dbl+lbl),
##     e13b_1 (dbl+lbl), e13b_2 (dbl+lbl), e13b_3 (dbl+lbl), e13b_4 (dbl+lbl),
##     e13b_5 (dbl+lbl), e13b_6 (dbl+lbl), e13b_7 (dbl+lbl), e13b_8 (dbl+lbl),
##     e13b_9 (dbl+lbl), e13b_10 (dbl+lbl), e13b_11 (dbl+lbl), e13b1 (dbl+lbl),
##     e13b2 (dbl+lbl), e13b_esp1 (chr), e13b_esp2 (chr), e14a (dbl+lbl), e14b
##     (dbl+lbl), e14c (dbl+lbl), e14d (dbl+lbl), e14e (dbl+lbl), e16 (dbl+lbl),
##     e18 (dbl+lbl), o1 (dbl+lbl), o2 (dbl+lbl), o3 (dbl+lbl), o4 (dbl+lbl), o5
##     (dbl+lbl), o6 (dbl+lbl), o7 (dbl+lbl), o7_esp (chr), o8 (dbl+lbl), o9a
##     (chr), o9b (chr), oficio1_08 (dbl+lbl), oficio4_08 (dbl+lbl), o10
##     (dbl+lbl), o11 (dbl+lbl), o12 (dbl+lbl), o14 (dbl+lbl), o15 (dbl+lbl), o16
##     (dbl+lbl), o19 (dbl+lbl), o18 (dbl+lbl), o20 (dbl+lbl), o21 (dbl+lbl), o22
##     (dbl+lbl), o23 (chr), o24 (chr), rama1_sub (dbl+lbl), rama4_sub (dbl+lbl),
##     rama1 (dbl+lbl), rama4 (dbl+lbl), o25 (dbl+lbl), o26a (dbl+lbl), o26b
##     (dbl+lbl), o26c (dbl+lbl), o26d (dbl+lbl), o28a_hr (dbl+lbl), o28a_min
##     (dbl+lbl), o28b (dbl+lbl), o28c (dbl+lbl), o28c_esp (chr), o28d (dbl+lbl),
##     o28e (dbl+lbl), o29 (dbl+lbl), o30 (dbl+lbl), o31 (dbl+lbl), o32 (dbl+lbl),
##     o32_esp (chr), o32b (dbl+lbl), y1 (dbl+lbl), y2_dias (dbl+lbl), y2_hrs
##     (dbl+lbl), y3a_preg (dbl+lbl), y3b_preg (dbl+lbl), y3c_preg (dbl+lbl),
##     y3d_preg (dbl+lbl), y3e_preg (dbl+lbl), y3f_preg (dbl+lbl), y3a (dbl+lbl),
##     y3ap (dbl+lbl), y3b (dbl+lbl), y3bp (dbl+lbl), y3c (dbl+lbl), y3cp
##     (dbl+lbl), y3d (dbl+lbl), y3dp (dbl+lbl), y3e (dbl+lbl), y3ep (dbl+lbl),
##     y3f_esp (chr), y3f (dbl+lbl), y3fp (dbl+lbl), y4a_preg (dbl+lbl), y4b_preg
##     (dbl+lbl), y4c_preg (dbl+lbl), y4d_preg (dbl+lbl), y4a (dbl+lbl), y4b
##     (dbl+lbl), y4c (dbl+lbl), y4d_esp (chr), y4d (dbl+lbl), y5a_preg (dbl+lbl),
##     y5b_preg (dbl+lbl), y5c_preg (dbl+lbl), y5d_preg (dbl+lbl), y5e_preg
##     (dbl+lbl), y5f_preg (dbl+lbl), y5g_preg (dbl+lbl), y5h_preg (dbl+lbl),
##     y5i_preg (dbl+lbl), y5j_preg (dbl+lbl), y5k_preg (dbl+lbl), y5l_preg
##     (dbl+lbl), y5a (dbl+lbl), y5b (dbl+lbl), y5c (dbl+lbl), y5d (dbl+lbl), y5e
##     (dbl+lbl), y5f (dbl+lbl), y5g (dbl+lbl), y5h (dbl+lbl), y5i (dbl+lbl), y5j
##     (dbl+lbl), y5k (dbl+lbl), y5l (dbl+lbl), y6 (dbl+lbl), y7 (dbl+lbl), y8
##     (dbl+lbl), y9 (dbl+lbl), y10 (dbl+lbl), y11_preg (dbl+lbl), y11 (dbl+lbl),
##     y12a_preg (dbl+lbl), y12a (dbl+lbl), y12b_preg (dbl+lbl), y12b (dbl+lbl),
##     y13a_preg (dbl+lbl), y13a (dbl+lbl), y13b_preg (dbl+lbl), y13b (dbl+lbl),
##     y13c_preg (dbl+lbl), y13c (dbl+lbl), y14a_preg (dbl+lbl), y14a (dbl+lbl),
##     y14b_preg (dbl+lbl), y14b (dbl+lbl), y14c_preg (dbl+lbl), y14c (dbl+lbl),
##     y15a_preg (dbl+lbl), y15a (dbl+lbl), y15b_preg (dbl+lbl), y15b (dbl+lbl),
##     y15c_preg (dbl+lbl), y15c (dbl+lbl), y16a_preg (dbl+lbl), y16a (dbl+lbl),
##     y16b_preg (dbl+lbl), y16b (dbl+lbl), y17_preg (dbl+lbl), y17 (dbl+lbl),
##     y18a_preg (dbl+lbl), y18a (dbl+lbl), y18b_preg (dbl+lbl), y18b (dbl+lbl),
##     y18c_preg (dbl+lbl), y18c (dbl+lbl), y18d_preg (dbl+lbl), y18d_esp (chr),
##     y18d (dbl+lbl), y19 (dbl+lbl), y19t (dbl+lbl), y19n (dbl+lbl), y20a
##     (dbl+lbl), y20b (dbl+lbl), y20c (dbl+lbl), y20d (dbl+lbl), y20e (dbl+lbl),
##     y20amonto (dbl), y20bmonto (dbl), y20cmonto (dbl), y20dmonto (dbl),
##     y20emonto (dbl), y21_canasta (dbl+lbl), y22_preg (dbl+lbl), y22 (dbl+lbl),
##     y22amonto (dbl), y22bmonto (dbl), y22cmonto (dbl), y22dmonto (dbl),
##     y23a_preg (dbl+lbl), y23a (dbl+lbl), y23b (dbl+lbl), y23c (dbl+lbl),
##     y23bmonto (dbl), y23cmonto (dbl), y24_preg (dbl+lbl), y24 (dbl+lbl),
##     y25a_preg (dbl+lbl), y25a (dbl+lbl), y25amonto (dbl), y25b_preg (dbl+lbl),
##     y25b (dbl+lbl), y25bmonto (dbl), y25c (dbl+lbl), y25cmonto (dbl), y25d
##     (dbl+lbl), y25dmonto (dbl), y25ep (dbl+lbl), y25e (dbl+lbl), y25fp
##     (dbl+lbl), y25f (dbl+lbl), y25g_preg (dbl+lbl), y25g (dbl+lbl), y25h_preg
##     (dbl+lbl), y25hp (dbl+lbl), y25h (dbl+lbl), y25i_preg (dbl+lbl), y25imonto
##     (dbl+lbl), y25ip (dbl+lbl), y25j_preg (dbl+lbl), y25j (dbl+lbl), y25jmonto
##     (dbl+lbl), y26d_hog (dbl+lbl), y26d_preg (dbl+lbl), y26d_integrantes
##     (dbl+lbl), y26d_monto (dbl+lbl), y27_preg (dbl+lbl), y27_esp (chr), y27
##     (dbl+lbl), y28_1b (dbl+lbl), y28_1c (dbl+lbl), y28_1d (dbl+lbl),
##     y28_1dmonto (dbl), y28_1e (dbl+lbl), y28_1f (dbl+lbl), y28_1g (dbl+lbl),
##     y28_1h (dbl+lbl), y28_1i (dbl+lbl), y28_1j (dbl+lbl), y28j_esp (chr),
##     y28_2b1 (dbl+lbl), y28_2b2 (dbl+lbl), y28_3b (dbl+lbl), y28_4b (dbl+lbl),
##     y28_1c1 (dbl+lbl), y28_1c2 (dbl+lbl), y28_1c2monto (dbl), y28_2c1
##     (dbl+lbl), y28_2c2 (dbl+lbl), y28_2c (dbl+lbl), y28_3c (dbl+lbl), y28_4c
##     (dbl+lbl), y28_2e1 (dbl+lbl), y28_2e2 (dbl+lbl), y28_3e (dbl+lbl), y28_4e
##     (dbl+lbl), y28_2f (dbl+lbl), y28_3f (dbl+lbl), y28_4f (dbl+lbl), y28_1g1
##     (dbl+lbl), y28_2g1 (dbl+lbl), y28_2g2 (dbl+lbl), y28_2g (dbl+lbl), y28_3g
##     (dbl+lbl), y28_4g (dbl+lbl), y28_2h (dbl+lbl), y28_3h (dbl+lbl), y28_4h
##     (dbl+lbl), y28_1i1 (dbl+lbl), y28_2i1 (dbl+lbl), y28_2i2 (dbl+lbl), y28_2i
##     (dbl+lbl), y28_2j (dbl+lbl), y28_3j (dbl+lbl), y28_4j (dbl+lbl), s2
##     (dbl+lbl), s2c (dbl+lbl), s3_1 (dbl+lbl), s3_2 (dbl+lbl), s3_3 (dbl+lbl),
##     s3_4 (dbl+lbl), s3_5 (dbl+lbl), s3_6 (dbl+lbl), s3_7 (dbl+lbl), s3_8
##     (dbl+lbl), s3_88 (dbl+lbl), s3a1 (dbl+lbl), s3a2 (dbl+lbl), s4 (dbl+lbl),
##     s5 (dbl+lbl), s6 (dbl+lbl), s7 (dbl+lbl), s7_meses (dbl+lbl), s8 (dbl+lbl),
##     s9a (dbl+lbl), s9b (dbl+lbl), s10 (dbl+lbl), s11a (dbl+lbl), s11b
##     (dbl+lbl), s12 (dbl+lbl), s13 (dbl+lbl), s13_fonasa (dbl+lbl), s15
##     (dbl+lbl), s16 (dbl+lbl), s17 (dbl+lbl), s17b (dbl+lbl), s18 (dbl+lbl),
##     s18_esp (chr), s19a (dbl+lbl), s19b (dbl+lbl), s19c (dbl+lbl), s19d
##     (dbl+lbl), s19e (dbl+lbl), s20a_preg (dbl+lbl), s20a (dbl+lbl), s20b
##     (dbl+lbl), s21a_preg (dbl+lbl), s21a (dbl+lbl), s21b (dbl+lbl), s22a_preg
##     (dbl+lbl), s22a (dbl+lbl), s22b (dbl+lbl), s23a_preg (dbl+lbl), s23a
##     (dbl+lbl), s23b (dbl+lbl), s24a_preg (dbl+lbl), s24a (dbl+lbl), s24b
##     (dbl+lbl), s25a1_preg (dbl+lbl), s25b1 (dbl+lbl), s25a2_preg (dbl+lbl),
##     s25b2 (dbl+lbl), s26a (dbl+lbl), s26b_1 (dbl+lbl), s26b_2 (dbl+lbl), s26b_3
##     (dbl+lbl), s26b_4 (dbl+lbl), s26b_5 (dbl+lbl), s26b_6 (dbl+lbl), s26b_7
##     (dbl+lbl), s26b_8 (dbl+lbl), s26b_88 (dbl+lbl), s26b_esp (chr), s26u
##     (dbl+lbl), s26c (dbl+lbl), s27a (dbl+lbl), s27b (dbl+lbl), s27c (dbl+lbl),
##     s28 (dbl+lbl), s28_esp (chr), s29 (dbl+lbl), s30 (dbl+lbl), s30_esp (chr),
##     s31_1 (dbl+lbl), s31_2 (dbl+lbl), s31_3 (dbl+lbl), s31_4 (dbl+lbl), s31_5
##     (dbl+lbl), s31_6 (dbl+lbl), s31_7 (dbl+lbl), s32a (dbl+lbl), s32b
##     (dbl+lbl), s32c (dbl+lbl), s32d (dbl+lbl), s32e (dbl+lbl), s32f (dbl+lbl),
##     s32g (dbl+lbl), s32h (dbl+lbl), s32i (dbl+lbl), s32j (dbl+lbl), s33a
##     (dbl+lbl), s33b (dbl+lbl), s33c (dbl+lbl), s33d (dbl+lbl), s33e (dbl+lbl),
##     s33f (dbl+lbl), s33g (dbl+lbl), s33h (dbl+lbl), s33i (dbl+lbl), s33j
##     (dbl+lbl), s34a (dbl+lbl), s34b (dbl), s34c (dbl+lbl), r1a (dbl+lbl),
##     r1a_esp (chr), r1a_esp_cod (dbl+lbl), r1b (dbl+lbl), r1b_comuna_esp (chr),
##     r1b_comuna_esp_cod (dbl+lbl), r1b_pais_esp (chr), r1b_pais_esp_cod
##     (dbl+lbl), r1c (dbl+lbl), r1cp (dbl+lbl), r2 (dbl+lbl), r2_comuna_esp
##     (chr), r2_comuna_esp_cod (dbl+lbl), r2_pais_esp (chr), r2_pais_esp_cod
##     (dbl+lbl), r3 (dbl+lbl), r4 (dbl+lbl), r5 (dbl+lbl), r6 (dbl+lbl), r7a
##     (dbl+lbl), r7b (dbl+lbl), r7c (dbl+lbl), r7d (dbl+lbl), r7e (dbl+lbl), r7f
##     (dbl+lbl), r7g (dbl+lbl), r7h (dbl+lbl), r7i (dbl+lbl), r7j (dbl+lbl), r7k
##     (dbl+lbl), r8a (dbl+lbl), r8b (dbl+lbl), r8c (dbl+lbl), r8d (dbl+lbl), r8e
##     (dbl+lbl), r8f (dbl+lbl), r8g (dbl+lbl), r8h (dbl+lbl), r9a (dbl+lbl), r9b
##     (dbl+lbl), r9c (dbl+lbl), r9d (dbl+lbl), r9e (dbl+lbl), r9f (dbl+lbl), r9g
##     (dbl+lbl), r9h (dbl+lbl), r9i (dbl+lbl), r9j (dbl+lbl), r9k (dbl+lbl), r9l
##     (dbl+lbl), r9m (dbl+lbl), r9n (dbl+lbl), r9o (dbl+lbl), r9p (dbl+lbl), r9q
##     (dbl+lbl), r9r (dbl+lbl), r9s (dbl+lbl), r9t (dbl+lbl), r9_esp (chr), r11
##     (dbl+lbl), r12a (dbl+lbl), r12b (dbl+lbl), r13a (dbl+lbl), r13b (dbl+lbl),
##     r14 (dbl+lbl), r15 (dbl+lbl), r17a (dbl+lbl), r17b (dbl+lbl), r17c
##     (dbl+lbl), r17d (dbl+lbl), r17e (dbl+lbl), r18 (dbl+lbl), v1 (dbl+lbl), v2
##     (dbl+lbl), v3 (dbl+lbl), v4 (dbl+lbl), v5 (dbl+lbl), v6 (dbl+lbl), v7
##     (dbl+lbl), v9 (dbl+lbl), v10 (dbl+lbl), v11_o1 (dbl), v11_o2 (dbl), v12
##     (dbl+lbl), v12mt (dbl+lbl), v13 (dbl+lbl), v13_propia (dbl+lbl),
##     v13_arrendada (dbl+lbl), v13_cedida (dbl+lbl), v13b_1 (dbl+lbl), v13b_2
##     (dbl+lbl), v13b_3 (dbl+lbl), v13b_4 (dbl+lbl), v13b_5 (dbl+lbl), v13b_6
##     (dbl+lbl), v13b_7 (dbl+lbl), v14 (dbl+lbl), v15 (dbl+lbl), v16 (dbl+lbl),
##     v17 (dbl+lbl), v18 (dbl+lbl), v19 (dbl+lbl), v20 (dbl+lbl), v20_esp (chr),
##     v20_red (dbl+lbl), v21 (dbl+lbl), v22 (dbl+lbl), v23 (dbl+lbl), v23_sistema
##     (dbl+lbl), v23_cajon (dbl+lbl), v24 (dbl+lbl), v25 (dbl+lbl), v26
##     (dbl+lbl), v27a (dbl+lbl), v27b (dbl+lbl), v28 (dbl+lbl), v29a (dbl+lbl),
##     v29b (dbl+lbl), v30 (dbl+lbl), v31 (dbl+lbl), v32 (dbl+lbl), v33 (dbl+lbl),
##     v34a (dbl+lbl), v34b (dbl+lbl), v34c (dbl+lbl), v35a (dbl+lbl), v35b
##     (dbl+lbl), v35c (dbl+lbl), v35d (dbl+lbl), v35e (dbl+lbl), v35f (dbl+lbl),
##     v35g (dbl+lbl), v35h (dbl+lbl), v35i (dbl+lbl), v36a (dbl+lbl), v36b
##     (dbl+lbl), v36c (dbl+lbl), v36d (dbl+lbl), v36e (dbl+lbl), v37a (dbl+lbl),
##     v37b (dbl+lbl), v37c (dbl+lbl), v37d (dbl+lbl), v37e (dbl+lbl), v37f
##     (dbl+lbl), v37g (dbl+lbl), v38 (dbl+lbl), os_presente (dbl+lbl), os1
##     (dbl+lbl), os1_esp (chr), genero (dbl+lbl), genero_esp (chr), trans
##     (dbl+lbl), y0101 (dbl), y0301 (dbl), y0302 (dbl), y0303 (dbl), y0304 (dbl),
##     y0305 (dbl), y0306 (dbl), y0401 (dbl), y0402 (dbl), y0403 (dbl), y0404
##     (dbl), y0501 (dbl), y0502 (dbl), y0503 (dbl), y0504 (dbl), y0505 (dbl),
##     y0506 (dbl), y0507 (dbl), y0508 (dbl), y0509 (dbl), y0510 (dbl), y0511
##     (dbl), y0512 (dbl), yosa (dbl), y0701 (dbl), y0801 (dbl), y0901 (dbl), yosi
##     (dbl), y1101 (dbl), yre1 (dbl), yama (dbl), ymes (dbl), yfa1 (dbl), yfa2
##     (dbl), ytro (dbl), yta1 (dbl), yta2 (dbl), ydes (dbl), yah1 (dbl), yah2
##     (dbl), yrut (dbl), yre2 (dbl), yre3 (dbl), yac2 (dbl), yids (dbl), ydon
##     (dbl), ydim (dbl), yotr (dbl), yfam (dbl), y2001 (dbl), y2002 (dbl), y2003
##     (dbl), y2004 (dbl), y2005 (dbl), y2101 (dbl), y2201 (dbl), y2202 (dbl),
##     y2203 (dbl), y2204 (dbl), y2301 (dbl), y2302 (dbl), y2303 (dbl), y2401
##     (dbl), y2501 (dbl), y2502 (dbl), y2503 (dbl), y2504 (dbl), y2505 (dbl),
##     y2506 (dbl), y2507 (dbl), y2508p (dbl+lbl), y2508 (dbl), y2509 (dbl), y2510
##     (dbl), y2604 (dbl), y2701 (dbl), y2804 (dbl), y280201 (dbl), y280202 (dbl),
##     y280101 (dbl), y280301 (dbl), y280302 (dbl), y2803 (dbl), yinv0101 (dbl),
##     yinv0102 (dbl), yinv02 (dbl), ymon0101 (dbl), ymon0102 (dbl), ymon02 (dbl),
##     yorf (dbl), yesp0101 (dbl), yesp0102 (dbl), yesp (dbl), yotp (dbl), yaut
##     (dbl), ysub1 (dbl), ysub2 (dbl), ysub (dbl), ytot (dbl), y0101h (dbl),
##     y0301h (dbl), y0302h (dbl), y0303h (dbl), y0304h (dbl), y0305h (dbl),
##     y0306h (dbl), y0401h (dbl), y0402h (dbl), y0403h (dbl), y0404h (dbl),
##     y0501h (dbl), y0502h (dbl), y0503h (dbl), y0504h (dbl), y0505h (dbl),
##     y0506h (dbl), y0507h (dbl), y0508h (dbl), y0509h (dbl), y0510h (dbl),
##     y0511h (dbl), y0512h (dbl), yosah (dbl), y0701h (dbl), y0801h (dbl), y0901h
##     (dbl), yosih (dbl), y1101h (dbl), yre1h (dbl), yamah (dbl), ymesh (dbl),
##     yfa1h (dbl), yfa2h (dbl), ytroh (dbl), yta1h (dbl), yta2h (dbl), ydesh
##     (dbl), yah1h (dbl), yah2h (dbl), yruth (dbl), yre2h (dbl), yre3h (dbl),
##     yac2h (dbl), yidsh (dbl), ydonh (dbl), ydimh (dbl), yotrh (dbl), yfamh
##     (dbl), y2001h (dbl), y2002h (dbl), y2003h (dbl), y2004h (dbl), y2005h
##     (dbl), y2101h (dbl), y2201h (dbl), y2202h (dbl), y2203h (dbl), y2204h
##     (dbl), y2301h (dbl), y2302h (dbl), y2303h (dbl), y2401h (dbl), y2501h
##     (dbl), y2502h (dbl), y2503h (dbl), y2504h (dbl), y2505h (dbl), y2506h
##     (dbl), y2507h (dbl), y2508h (dbl), y2509h (dbl), y2510h (dbl), y2604h
##     (dbl), y2701h (dbl), y2804h (dbl), y280201h (dbl), y280202h (dbl), y280101h
##     (dbl), y280301h (dbl), y280302h (dbl), y2803h (dbl), yinv0101h (dbl),
##     yinv0102h (dbl), yinv02h (dbl), ymon0101h (dbl), ymon0102h (dbl), ymon02h
##     (dbl), yorfh (dbl), yesp0101h (dbl), yesp0102h (dbl), yesph (dbl), yotph
##     (dbl), yauth (dbl), ysub1h (dbl), ysub2h (dbl), ysubh (dbl), yaimh (dbl),
##     ytoth (dbl), ypch (dbl), y0101c (dbl), y0701c (dbl), y280201c (dbl),
##     y280301c (dbl), y2803c (dbl), yautcor (dbl), ytotcor (dbl), y0101ch (dbl),
##     y0701ch (dbl), y280201ch (dbl), y280301ch (dbl), y2803ch (dbl), yautcorh
##     (dbl), yaimcorh (dbl), ytotcorh (dbl), ypc (dbl), li (dbl), lp (dbl), nae
##     (dbl), yae (dbl), pobreza (dbl+lbl), yoprcor (dbl), yoprcorh (dbl),
##     ytrabajocor (dbl), ytrabajocorh (dbl), ymonecorh (dbl), ypchtrabcor (dbl),
##     ypchautcor (dbl), dau (dbl+lbl), qaut (dbl+lbl), dautr (dbl+lbl), qautr
##     (dbl+lbl), hh_d_asis (dbl+lbl), hh_d_rez (dbl+lbl), hh_d_esc (dbl+lbl),
##     hh_d_mal (dbl+lbl), hh_d_prevs (dbl+lbl), hh_d_acc (dbl+lbl), hh_d_act
##     (dbl+lbl), hh_d_cot (dbl+lbl), hh_d_jub (dbl+lbl), hh_d_hacina (dbl+lbl),
##     hh_d_estado (dbl+lbl), hh_d_habitab (dbl+lbl), hh_d_servbas (dbl+lbl),
##     hh_d_medio (dbl+lbl), hh_d_equipo (dbl+lbl), hh_d_tiempo (dbl+lbl),
##     hh_d_accesi (dbl+lbl), hh_d_entorno (dbl+lbl), hh_d_hapoyo (dbl+lbl),
##     hh_d_part (dbl+lbl), hh_d_tsocial (dbl+lbl), hh_d_seg (dbl+lbl),
##     hh_d_appart (dbl+lbl), pobreza_multi_5d (dbl+lbl), pobreza_multi_4d
##     (dbl+lbl), disc_wg (dbl+lbl), esc (dbl), desercion (dbl+lbl), rezago (dbl),
##     asiste (dbl+lbl), educ (dbl+lbl), depen (dbl+lbl), activ (dbl+lbl), asal
##     (dbl+lbl), contrato (dbl+lbl), cotiza (dbl+lbl), lugar_nac (dbl+lbl),
##     pueblos_indigenas (dbl+lbl), n_ocupados (dbl), n_desocupados (dbl),
##     n_inactivos (dbl), conyuge_jh (dbl+lbl), numper (dbl), numnuc (dbl), men18c
##     (dbl+lbl), may60c (dbl+lbl), tipohogar (dbl+lbl), tot_hog (dbl), ind_hacina
##     (dbl+lbl), indsan (dbl+lbl), ten_viv (dbl+lbl), ten_viv_f (dbl+lbl),
##     allega_ext (dbl+lbl), allega_int (dbl+lbl), pobre_dic (dbl)
```

## 2. Análisis Descriptivo con `srvyr`

Usaremos el flujo `objeto_srvyr %>% summarise(...)` para calcular estadísticas descriptivas ponderadas.

### Medias Ponderadas

Calculemos la media de edad y escolaridad, pidiendo directamente el Intervalo de Confianza (IC) al 95% (`vartype = "ci"`).


``` r
# Calcular medias ponderadas con IC 95%
medias_ci <- casen_design_srvyr %>%
  summarise(
    edad_media = survey_mean(edad, na.rm = TRUE, vartype = "ci"),
    esc_media = survey_mean(esc, na.rm = TRUE, vartype = "ci") 
  )

print(medias_ci)
```

```
## # A tibble: 1 × 6
##   edad_media edad_media_low edad_media_upp esc_media esc_media_low esc_media_upp
##        <dbl>          <dbl>          <dbl>     <dbl>         <dbl>         <dbl>
## 1       37.2           37.0           37.4      12.0          11.9          12.0
```

**Interpretación:** Observa la estimación puntual (`_media`), el límite inferior (`_low`) y superior (`_upp`) del IC 95% para edad y escolaridad.

### Proporciones Ponderadas

Calcularemos la tasa de pobreza (usando `pobre_dic`) y la proporción por sexo.


``` r
# 1. Proporción de pobreza usando survey_mean en dummy
tasa_pobreza <- casen_design_srvyr %>%
  summarise(pobreza_prop = survey_mean(pobre_dic, na.rm = TRUE, vartype = "ci"))

print(tasa_pobreza)
```

```
## # A tibble: 1 × 3
##   pobreza_prop pobreza_prop_low pobreza_prop_upp
##          <dbl>            <dbl>            <dbl>
## 1       0.0650           0.0622           0.0678
```

``` r
# 2. Proporción por sexo usando group_by + survey_prop
prop_sexo <- casen_design_srvyr %>%
  # Usamos as_factor para obtener etiquetas si haven las cargó
  mutate(sexo_factor = haven::as_factor(sexo)) %>% 
  group_by(sexo_factor) %>% 
  summarise(proporcion = survey_prop(vartype = "ci")) 

print(prop_sexo)
```

```
## # A tibble: 2 × 4
##   sexo_factor proporcion proporcion_low proporcion_upp
##   <fct>            <dbl>          <dbl>          <dbl>
## 1 1. Hombre        0.493          0.491          0.496
## 2 2. Mujer         0.507          0.504          0.509
```

**Interpretación:** Interpreta la tasa de pobreza y su IC. Luego, observa las proporciones estimadas para hombres y mujeres y sus ICs.

### Totales Poblacionales Estimados (Opcional)


``` r
# Estimar el número total de personas 
total_personas <- casen_design_srvyr %>%
  summarise(total_pers = survey_total(vartype = "ci"))

print(total_personas)
```

```
## # A tibble: 1 × 3
##   total_pers total_pers_low total_pers_upp
##        <dbl>          <dbl>          <dbl>
## 1   19878573      19622617.      20134529.
```

``` r
# Estimar el número total de personas en pobreza
total_pobres <- casen_design_srvyr %>%
  summarise(total_pob = survey_total(pobre_dic, na.rm = TRUE, vartype = "ci"))
  
print(total_pobres)
```

```
## # A tibble: 1 × 3
##   total_pob total_pob_low total_pob_upp
##       <dbl>         <dbl>         <dbl>
## 1   1291824      1234083.      1349565.
```

## 3. Análisis por Subgrupos (`group_by`)

Usemos `group_by()` para calcular estadísticas para diferentes subgrupos.


``` r
# Media de ingreso del hogar (ytotcorh) por región
ingreso_x_region <- casen_design_srvyr %>%
  mutate(region_factor = haven::as_factor(region)) %>% # Usar etiquetas
  filter(!is.na(region)) %>% 
  group_by(region_factor) %>%
  summarise(ingreso_medio_hogar = survey_mean(ytotcorh, na.rm = TRUE, vartype = "se"))

# Mostramos solo las primeras filas por brevedad
head(ingreso_x_region) 
```

```
## # A tibble: 6 × 3
##   region_factor                       ingreso_medio_hogar ingreso_medio_hogar_se
##   <fct>                                             <dbl>                  <dbl>
## 1 Región de Tarapacá                             1515201.                 39538.
## 2 Región de Antofagasta                          1819321.                 46307.
## 3 Región de Atacama                              1487318.                 47337.
## 4 Región de Coquimbo                             1438892.                 39039.
## 5 Región de Valparaíso                           1499137.                 26803.
## 6 Región del Libertador Gral. Bernar…            1460124.                 29905.
```

``` r
# Tasa de pobreza (proporción de pobre_dic == 1) por zona (urbana/rural)
pobreza_x_zona <- casen_design_srvyr %>%
  mutate(zona_factor = haven::as_factor(area)) %>% # Usar etiquetas
  filter(!is.na(area)) %>%
  group_by(zona_factor) %>%
  summarise(tasa_pobreza = survey_mean(pobre_dic, na.rm = TRUE, vartype = "ci"))

print(pobreza_x_zona)
```

```
## # A tibble: 2 × 4
##   zona_factor tasa_pobreza tasa_pobreza_low tasa_pobreza_upp
##   <fct>              <dbl>            <dbl>            <dbl>
## 1 Urbano            0.0606           0.0576           0.0636
## 2 Rural             0.0994           0.0919           0.107
```

``` r
# Media de escolaridad por sexo
esc_x_sexo <- casen_design_srvyr %>%
  mutate(sexo_factor = haven::as_factor(sexo)) %>% # Usar etiquetas
  filter(!is.na(sexo)) %>%
  group_by(sexo_factor) %>%
  summarise(esc_media = survey_mean(esc, na.rm = TRUE, vartype = "ci"))

print(esc_x_sexo)
```

```
## # A tibble: 2 × 4
##   sexo_factor esc_media esc_media_low esc_media_upp
##   <fct>           <dbl>         <dbl>         <dbl>
## 1 1. Hombre        12.0          12.0          12.1
## 2 2. Mujer         11.9          11.8          11.9
```

**Interpretación y Reflexión:**

*   Observa las diferencias en ingreso medio por región. ¿Son grandes? ¿Qué indican los errores estándar?
*   Compara la tasa de pobreza entre zona urbana y rural. ¿Se solapan los intervalos de confianza?
*   Analiza la escolaridad media por sexo. ¿Hay diferencias aparentes?

## 4. Visualización de Resultados Ponderados con `ggplot2`

Un error común es intentar usar `ggplot2` directamente con la base de datos original (`casen`) o incluso con el objeto `casen_design_srvyr` esperando que "mágicamente" aplique los ponderadores y calcule los errores correctamente. **¡Esto no funciona!**

`ggplot2` necesita un **data frame resumen** que ya contenga las **estadísticas ponderadas** (medias, proporciones, etc.) y, si queremos graficar la incertidumbre, los **límites de los intervalos de confianza** o los **errores estándar**.

**El flujo correcto es:**

1.  Usar `srvyr` (con `group_by` y `summarise`) para calcular las estadísticas deseadas (ej. proporciones y sus ICs). Guardar este resultado en un **nuevo tibble**.
2.  Usar ese **nuevo tibble** como el argumento `data` en `ggplot()`.
3.  Mapear las estadísticas calculadas (ej. proporción, límite inferior, límite superior) a las estéticas (`aes`) de `ggplot` (ej. `y`, `ymin`, `ymax`).

**Ejemplo: Graficar la tasa de pobreza por zona**

Primero, volvemos a calcular la tasa de pobreza por zona, asegurándonos de guardar el resultado.


``` r
# 1. Calcular estadísticas ponderadas con srvyr
pobreza_x_zona_data <- casen_design_srvyr %>%
  mutate(zona_factor = haven::as_factor(area)) %>% 
  filter(!is.na(area)) %>%
  group_by(zona_factor) %>%
  summarise(
    tasa_pobreza = survey_mean(pobre_dic, na.rm = TRUE, vartype = "ci") 
    # pedimos el IC directamente (obtendremos _low y _upp)
  )

print(pobreza_x_zona_data) # Verificamos el tibble resultante
```

```
## # A tibble: 2 × 4
##   zona_factor tasa_pobreza tasa_pobreza_low tasa_pobreza_upp
##   <fct>              <dbl>            <dbl>            <dbl>
## 1 Urbano            0.0606           0.0576           0.0636
## 2 Rural             0.0994           0.0919           0.107
```

Ahora, usamos `pobreza_x_zona_data` (¡NO `casen` ni `casen_design_srvyr`!) en `ggplot`.


``` r
# 2. Crear el gráfico con ggplot2 usando el tibble resumen
ggplot(pobreza_x_zona_data, aes(x = zona_factor, y = tasa_pobreza, fill = zona_factor)) +
  geom_col(width = 0.6) + # Gráfico de columnas
  geom_errorbar(
    aes(ymin = tasa_pobreza_low, ymax = tasa_pobreza_upp), # Usamos los límites del IC
    width = 0.2, # Ancho de las barras de error
    linewidth = 0.8 # Grosor de la línea (ajustar si es necesario)
  ) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + # Eje Y en porcentaje
  scale_fill_viridis_d(option = "E", begin = 0.3, end = 0.8) + # Paleta de colores accesible
  labs(
    title = "Tasa de Pobreza Estimada por Zona",
    subtitle = "Encuesta CASEN 2022 (con IC 95%)",
    x = "Zona Geográfica",
    y = "Tasa de Pobreza Estimada",
    fill = "Zona" # Etiqueta para la leyenda
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom") 
```

<img src="/example/05-practico_files/figure-html/unnamed-chunk-8-1.png" width="672" />

**Interpretación del Gráfico:** Este gráfico muestra la tasa de pobreza estimada para las zonas urbana y rural, basada en los cálculos ponderados de CASEN 2022. Las barras representan la estimación puntual, y las líneas negras indican el intervalo de confianza del 95%. Podemos ver claramente que la tasa de pobreza estimada es más alta en la zona rural y que los intervalos de confianza no se solapan, sugiriendo una diferencia estadísticamente significativa.

**Recuerda:** Siempre calcula primero con `srvyr`/`survey`, luego visualiza con `ggplot2`.

## 5. Conclusión

¡Excelente trabajo! En esta sesión práctica has aprendido a:

*   Usar `srvyr` para declarar el diseño muestral de forma `tidyverse`.
*   Calcular medias, proporciones y totales ponderados usando `summarise` y las funciones `survey_*`.
*   Obtener e interpretar errores estándar e intervalos de confianza que reflejan el diseño complejo.
*   Realizar análisis por subgrupos fácilmente con `group_by`.
*   **Visualizar correctamente** los resultados ponderados usando `ggplot2` después de calcular las estadísticas necesarias.

Ahora tienes las herramientas fundamentales para empezar a analizar datos de encuestas complejas como CASEN de manera rigurosa y eficiente en R, incluyendo la capacidad de crear visualizaciones informativas y correctas. ¡El siguiente paso es practicar con diferentes variables y preguntas de investigación!
