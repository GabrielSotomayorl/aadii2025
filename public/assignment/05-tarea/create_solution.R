nom_bases <- list.files(pattern="*.sav",
                        path="bases/procesadas")

# Creates one solution for each dataframe named in 'nom_bases' using the parameter base in Rmd
for (i in 1:length(nom_bases)) {
    rmarkdown::render("05-tarea.Rmd", 
                      params = list(base = nom_bases[i]),
                      output_file = paste0("05-tarearesuelta-", gsub("^05-tarea|\\.sav?","", nom_bases[i]), ".pdf"),
                      output_dir = 'resueltas',
                      encoding="UTF-8")
}


for (i in 1:length(nom_bases)) {
    rmarkdown::render("resueltas/05-tarea.Rmd", 
                      params = list(base = nom_bases[i]),
                      output_file = paste0("05-tarea-", gsub("^05-tarewa|\\.sav?","", nom_bases[i]), ".docx"),
                      output_dir = '/solucion',
                      encoding="UTF-8")
}



