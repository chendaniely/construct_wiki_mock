library(shiny)
library(readr)
library(DT)
library(visNetwork)
library(dplyr)
library(stringr)
library(igraph)
library(shinydashboard)
library(here)

print(R.utils::sourceDirectory(here('shiny', 'functions')))
# print(R.utils::sourceDirectory(here('shiny', 'modules')))

ORIGINAL_DATA <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vR2imOgIzmv8ayb7rDrvVySZ0vFDGNULSGNgT5ObdXOyEEnrok-JlW4MP0jWNSJl1aP_UuKgVDsFZer/pub?gid=432933410&single=true&output=tsv'
ORIGINAL_DATA_DF <- read_delim(ORIGINAL_DATA,
                               delim = '\t',
                               skip = 1,
                               col_names = c('timestamp', 'email', 'construct',
                                             'meta_construct', 'definition', 'reference',
                                             'bibtex', 'field', 'military', 'population',
                                             'measurement', 'instrument', 'notes', 'bibkey'))
ADJUSTED_DATA <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSsKx4GLFQEw_2S5nWZ1vswFK0W92J4_o21FtaGTD6e4SLSkmXcCuUiYhX6WOkGWBp8cFguF47IoSFa/pub?gid=384432168&single=true&output=tsv'
ADJUSTED_DATA_DF <- read_delim(ADJUSTED_DATA,
                               delim = '\t',
                               skip = 1,
                               col_names = c('timestamp', 'email', 'construct', 'meta_construct',
                                             'meta_construct_ori', 'definition', 'reference',
                                             'bibtex', 'field', 'military', 'population',
                                             'measurement', 'instrument', 'notes', 'bibkey'))
ADJUSTED_DATA_DF$construct <- stringr::str_to_lower(ADJUSTED_DATA_DF$construct)
ADJUSTED_DATA_DF$meta_construct <- stringr::str_to_lower(ADJUSTED_DATA_DF$meta_construct)
ADJUSTED_DATA_DF$meta_construct_ori <- stringr::str_to_lower(ADJUSTED_DATA_DF$meta_construct_ori)
