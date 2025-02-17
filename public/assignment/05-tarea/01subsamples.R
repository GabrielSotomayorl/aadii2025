# Exportar múltiples sub muestras de base de datos

# 1. Cargar datos ---------------------------------------------------------
pacman::p_load(haven, dplyr)

datos <- haven::read_dta(url("https://movid-impact.netlify.app/input/data/MOVID-IMPACT.dta"))

# 2. Filtrar y seleccionar ------------------------------------------------
dato_original <- datos %>% filter(entrevistado == 1) %>% 
  select(entrevistado, f7_3, f6, g1, edad, factor_expansion)

dato_resuelta <- datos %>%
  filter(entrevistado == 1) %>% 
  select(entrevistado, cuidarse = f7_3,riesgo =f6, trabaja = g1, edad, factor_expansion) %>% 
  mutate(trabaja = as_factor(trabaja),
         cuidarse = car::recode(cuidarse, c("c(8,9)=NA")),
         cuidarse_dummy = car::recode(cuidarse, c("c(1,2)=0;c(3,4,5)=1;c(8,9)=NA"), as.factor =  T,
                                      levels = c(0, 1)),
         riesgo  = car::recode(riesgo, c("c(8,9)=NA")),
         riesgo_fct = riesgo,
         edad = as_factor(car::recode(edad, c("18:39='Joven';40:60='Adulto'; 61:hi='Adulto mayor'"),
                                      as.factor = T, levels = c("Joven", "Adulto", "Adulto mayor")))) %>%
  mutate_at(vars(edad, trabaja, riesgo_fct),
            funs(forcats::as_factor(.)))
# 3. Datasets -------------------------------------------------------------
set.seed(12072018)

# Magister data -----------------------------------------------------------
uah <- unlist(googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1iAPSj6IbwuyRXTIdqimcjRFd1TteK437L2WiCIh0m24/edit?usp=sharing","asistencia") %>% 
  select(Apellido))
uah <- iconv(uah, to='ASCII//TRANSLIT')

for (i in 1:length(uah)) {
  write_sav(dato_original[sample(nrow(dato_original),1000),],
            paste0("bases/originales/",
                   uah[i], ".sav"))
}

for (i in 1:length(uah)) {
  write_sav(dato_resuelta[sample(nrow(dato_resuelta),1000),],
            paste0("bases/procesadas/",
                   uah[i], ".sav"))
}
