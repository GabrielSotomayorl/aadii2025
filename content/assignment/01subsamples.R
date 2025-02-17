# Exportar múltiples sub muestras de base de datos


# 1. Cargar datos ---------------------------------------------------------
pacman::p_load(haven, dplyr)

datos <- haven::read_dta(url("https://movid-impact.netlify.app/input/data/MOVID-IMPACT.dta"))

# 2. Filtrar y seleccionar ------------------------------------------------
dato_mg <- datos %>% filter(entrevistado == 1) %>% 
  select(cuidarse = f7_3,riesgo =f6, trabaja = g1, edad) %>% 
  mutate(trabaja = as_factor(trabaja),
         cuidarse = car::recode(cuidarse, c("c(8,9)=NA")),
         riesgo  = car::recode(riesgo, c("c(8,9)=NA")),
    edad = as_factor(car::recode(edad, c("18:39='Joven';40:60='Adulto'; 61:hi='Adulto mayor'"),
                            as.factor = T, levels = c("Joven", "Adulto", "Adulto mayor"))))

dato_dip <- datos %>% filter(entrevistado == 1) %>% 
  select(cuidarse = f7_3,riesgo =f6, trabaja = g1, sexo) %>% 
  mutate(cuidarse = car::recode(cuidarse, c("c(8,9)=NA")),
    riesgo  = car::recode(riesgo, c("c(8,9)=NA")),
         trabaja = as_factor(trabaja),
         sexo = as_factor(sexo))


# 3. Datasets -------------------------------------------------------------
set.seed(12072018)

# Magister data -----------------------------------------------------------
magister <- unlist(readxl::read_excel("../../Admin/08. Acta Análisis de Regresión Múltiple - M. Gerber.xlsx",range = "C16:C36"))
magister <- iconv(magister, to='ASCII//TRANSLIT')

for (i in 1:length(magister)) {
  write_sav(dato_mg[sample(nrow(dato_mg),1000),],
            paste0("bases/magister/",
                   magister[i], ".sav"))
}

# Diplomado data ----------------------------------------------------------
diplomado <- unlist(readxl::read_excel("../../Admin/04. Acta Análisis Regresión Múltiple - Cristobal Moya actualizada.xlsx",range = "C16:C38"))
diplomado <- iconv(diplomado, to='ASCII//TRANSLIT')

for (i in 1:length(diplomado)) {
  write_sav(dato_dip[sample(nrow(dato_dip),1000),],
            paste0("bases/diplomado/",
                   diplomado[i], ".sav"))
}

