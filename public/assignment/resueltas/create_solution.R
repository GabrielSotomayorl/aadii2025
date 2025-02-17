nom_bases <- list.files(pattern="*.sav",
                        path="bases")

# Creates one solution for each dataframe named in 'nom_bases' using the parameter base in Rmd
for (i in 1:length(nom_bases)) {
    rmarkdown::render("2020-regresion_guia1_resuelta.Rmd", 
                      params = list(base = nom_bases[i]),
                      output_file = paste0("guia1resuelta-", gsub("^guia1|\\.sav?","", nom_bases[i]), ".pdf"),
                      output_dir = 'resueltas',
                      encoding="UTF-8")
}


for (i in 1:length(nom_bases)) {
    rmarkdown::render("C:/Users/CM/Dropbox/2018_I/regresion/evaluacion/ejercicio1/2019-regresion_guia1_resuelta.Rmd", 
                      params = list(base = nom_bases[i]),
                      output_file = paste0("guia_1-", gsub("^guia1|\\.sav?","", nom_bases[i]), ".docx"),
                      output_dir = 'C:/Users/CM/Dropbox/2019_I/regresion/evaluacion/ejercicio1/solucion',
                      encoding="UTF-8")
}



