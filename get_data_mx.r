# Bibliotecas necesarias
## install.packages(c("tabulizer","dplyr","lubridate","stringr"))
library("tabulizer")
library("dplyr")
library("lubridate")
library("stringr")

# Lectura de archivos oficiales

## PDF actualizado
pdf_file <- "https://www.gob.mx/cms/uploads/attachment/file/541827/Tabla_casos_positivos_resultado_InDRE_2020.03.17.pdf"

out <- extract_tables(pdf_file)
## Concatena las tablas de todas las hojas
final <- do.call(rbind, out)

## Remueve las primeras filas que corresponden al encabezado
final<-data.frame(final[-1:-max(which(final[,1]=="")),])

colnames(final)<-c("Caso","Estado","Sexo","Edad","Inicio","Confirmación","Procedencia","Llegada")

## Escribe la base mexicana
write.csv(final,file="data/covid19_cases.csv",quote=F,row.names = F)

# Modificación al ejemplo Midas
## Corrección de formato de fechas
final$Inicio<-ymd(as.Date(final$Inicio,format="%d/%m/%y"))
final$Llegada<-ymd(as.Date(final$Llegada,format="%d/%m/%y"))

## Cambiar el formato de texto en el nombre de estados
final$Estado<-str_to_title(final$Estado)

## Cambiar la M por male y F por female
final$Sexo<-str_replace_all(final$Sexo,c("M"="male","F"="female"))

## Cambiar el Procedencia: Contacto por NA, los otros campos son paises
final$Procedencia[final$Procedencia=="Contacto"]<-NA

## Hacer la columna de Summary
final<-final%>%
  mutate(summary=paste0(
    "new COVID-19 patient confirmed in Mexico: ",Estado)) %>% 
  mutate(summary=paste(summary,Sexo,Edad,sep=","))%>%
  mutate(summary=ifelse(!is.na(Procedencia),paste0(summary,", travelled to ",Procedencia),summary))

## Todas son muestras mexicanas
final$country<-"Mexico"

## Aquí debería reportar cuando se reportaron estos nuevos casos pero debería tener un sistema que detecte los nuevos casos y vaya actualizando esta fecha, por el momento lo dejo como NA
final$`reporting date`<-NA
## No conozco muy bien que campo o tipo de variable esperan las siguientes columnas
final$If_onset_approximated<-NA
final$international_traveler<-NA
final$domestic_traveler<-NA
final$exposure_start<-NA
final$exposure_end<-NA
final$traveler<-NA
final$`visiting Wuhan`<-NA
final$`from Wuhan`<-NA
final$death<-NA
final$recovered<-NA
final$symptom<-NA

## Fuente oficial
final$source<-"SINAVE/DGE/InDRE"
final$link<-pdf_file

### Ojo que falta el número de caso internacional
midas<-final[,c("Caso",
                "reporting date",
                "summary",
                "Estado",
                "country",
                "Sexo",
                "Edad",
                "Inicio",
                "If_onset_approximated",
                "Llegada",
                "international_traveler",
                "domestic_traveler",
                "exposure_start",
                "exposure_end",
                "traveler",
                "visiting Wuhan",
                "from Wuhan",
                "death",
                "recovered",
                "symptom",
                "source",
                "link")]

colnames(midas)<-c("case_in_country",
                   "reporting date",
                   "summary",
                   "location",
                   "country",
                   "gender",
                   "age",
                   "symptom_onset",
                   "If_onset_approximated",
                   "hosp_visit_date",
                   "international_traveler",
                   "domestic_traveler",
                   "exposure_start",
                   "exposure_end",
                   "traveler",
                   "visiting Wuhan",
                   "from Wuhan",
                   "death",
                   "recovered",
                   "symptom",
                   "source",
                   "link")

# Salida de archivo midas
write.table(midas,file="midas_MX.txt",sep="\t",quote=F,row.names=F)
