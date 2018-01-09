library(shiny)
library(readr)
library(DT)
library(visNetwork)
library(dplyr)
library(stringr)
library(igraph)
library(shinydashboard)

if (interactive()) {
    base_dir <- './'
} else {
    base_dir <- './'
}

fxns <- list.files(normalizePath(paste0(base_dir, 'functions')), full.names = TRUE)
sapply(fxns, source, .GlobalEnv)

mods <- list.files(normalizePath(paste0(base_dir, 'modules')), full.names = TRUE)
sapply(mods, source, .GlobalEnv)
