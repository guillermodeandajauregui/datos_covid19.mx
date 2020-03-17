########################################
##           COVID Pipeline           ##
##     Ollin Demian Langle Chimal     ##
########################################

# .PHONY: clean data lint init deps sync_to_gs sync_from_gs
.PHONY: clean data

########################################
##            Variables               ##
########################################

## Project Directory
PROJ_DIR:=$(shell pwd)

PROJECT_NAME:=$(shell cat .project-name)
# PROJECT_VERSION:=$(shell cat .project-version)

PDF_FILE:=$(shell cat .pdf-file)
TABLE_FILE:=$(shell cat .table-file)

## Python Version
VERSION_PYTHON:=$(shell python -V)

SHELL := /bin/bash

########################################
##       Environment Tasks            ##
########################################

init: prepare ##@dependencias Prepara la computadora para el funcionamiento del proyecto

prepare: deps
#	pyenv virtualenv ${PROJECT_NAME}_venv
#	pyenv local ${PROJECT_NAME}_venv

#pyenv: .python-version
#	@pyenv install $(VERSION_PYTHON)

deps: pip airdb

pip: requirements.txt
	@pip install -r $<

info:
	@echo Project: $(PROJECT_NAME) ver. $(PROJECT_VERSION) in $(PROJ_DIR)
	@python --version
	@pip --version

deldata:
	@ yes | rm data/*

getdata:
	@sh $(PROJ_DIR)/src/get_covid_cases.sh data/$(PDF_FILE)

tocsv:
	@sh $(PROJ_DIR)/src/pdf_to_csv.sh $(PROJ_DIR)/data/$(PDF_FILE) > $(PROJ_DIR)/data/$(TABLE_FILE)
