library(shiny)
library(readr)
library(DT)
library(visNetwork)
library(dplyr)
library(stringr)
library(igraph)
library(shinydashboard)

if (interactive()) {
    base_dir <- 'shiny/'
} else {
    base_dir <- './'
}

fxns <- list.files(normalizePath(paste0(base_dir, 'functions')), full.names = TRUE)
sapply(fxns, source, .GlobalEnv)

mods <- list.files(normalizePath(paste0(base_dir, 'modules')), full.names = TRUE)
sapply(mods, source, .GlobalEnv)

# pokemon <- read.csv('data/pokemon.csv', sep = '\t', stringsAsFactors = FALSE)
constructs <- read_delim('https://docs.google.com/spreadsheets/d/e/2PACX-1vR2imOgIzmv8ayb7rDrvVySZ0vFDGNULSGNgT5ObdXOyEEnrok-JlW4MP0jWNSJl1aP_UuKgVDsFZer/pub?gid=432933410&single=true&output=tsv',
                         delim = '\t',
                         skip = 1,
                         col_names = c('timestamp', 'email', 'construct',
                                       'meta_construct', 'definition', 'reference',
                                       'bibtex', 'field', 'military', 'population',
                                       'measurement', 'instrument', 'notes', 'bibkey'))

construct_values <- constructs$construct
names(construct_values) <- str_to_title(construct_values)

network_dfs <- .GlobalEnv$clean_network_df(constructs)

G <- igraph::graph_from_data_frame(network_dfs$edges)

# neighbors(G, 'character')

# this is just to test if the thing actually works...
# visNetwork(network_dfs$nodes, network_dfs$edges, width = '100%', height = "1000px") %>%
# visEdges(arrows = "to") %>%
#     visOptions(manipulation = TRUE,
#                collapse = TRUE) %>%
#     visLayout(randomSeed = 42)
