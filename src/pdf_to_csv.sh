#!/usr/bin/env bash

FILE=$1
# OFILE=$2

pdftotext -layout -nopgbrk $FILE -|\
    sed '$d' | sed -r "s/  +/|/g;" | sed -r "1,10d"|\
    head -n -4 | sed 's/^.//' | awk \
    'BEGIN {FS=OFS="|"} {if ($2 ~/*/) {print $0"|"1} else {print $0"|"0}}' |\
    sed 's/*//' | sed \
    '1i\Caso|Estado|Sexo|Edad|Inicio|Confirmación|Procedencia|Llegada|Recuperado'
