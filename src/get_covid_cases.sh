#!/usr/bin/env bash

datadir=$(pwd)/
FILE=$1

wget -O $datadir/$FILE https://www.gob.mx/cms/uploads/attachment/file/541539/Tabla_casos_positivos_resultado_InDRE_2020.03.15.pdf
