rm(list = ls())

library(shiny)
#library(data.tree)
#library(networkD3)
library(DT)
#library(igraph)
library(visNetwork)
library(dplyr)
library(stringr)

strwrap_br <- function(input_string, width=79, br = '<br>') {
    wrapped <- sapply(input_string, strwrap, width = width)
    wrapped <- unlist(lapply(wrapped, paste0, collapse = br))
    return(wrapped)
}

# setwd("~/git/hub/construct_wiki/shiny")

read.csv('data/pokemon.csv', sep = '\t', stringsAsFactors = FALSE)
constructs <- read.csv('data/ari2/original/construct_data.tsv', sep = '\t', stringsAsFactors = FALSE)

# def_strwrap <- sapply(constructs$Construct.definition..verbatim., strwrap)
# constructs$defs_wraped <- unlist(lapply(def_strwrap, paste0, collapse = '<br>'))

constructs$defs_wraped <- strwrap_br(constructs$Construct.definition..verbatim.)

edge_list <- constructs[, c(3, 2)]
names(edge_list) <- c('from', 'to')
# el <- graph.data.frame(edge_list)

nodes <- data.frame('id' = unique(c(unique(edge_list$from),
                                      unique(edge_list$to))),
                    stringsAsFactors = FALSE)

nodes$label <- strwrap_br(str_to_title(nodes$id), width = 15, br = '\n')

multi_defs <- constructs %>%
    group_by_("Name.of.construct.determinant") %>%
    summarize(n = n()) %>%
    filter(n > 1)

combine_defs <- function(construct, df = constructs,
                         construct_name = 'Name.of.construct.determinant',
                         def_name = 'defs_wraped') {
    sub_df <- df[df[construct_name] == construct, ]
    defs <- sub_df[, def_name]

    str_rep <- paste0(str_trim(sprintf('Definition %s\n%s', 1:length(defs), defs)), collapse = '\n\n')
    html_rep <- str_replace_all(str_rep, '\\\n', '<br>')
    return(html_rep)
}

nodes_def_eq1 <- nodes[!nodes$id %in% multi_defs$Name.of.construct.determinant, ]
nodes_def_ge1 <- nodes[nodes$id %in% multi_defs$Name.of.construct.determinant, ]

nodes_def_eq1 <- merge(x = nodes_def_eq1,
                       y = constructs[, c("Name.of.construct.determinant",
                                          "defs_wraped")],
                       by.x = 'id',
                       by.y = "Name.of.construct.determinant",
                       all.x = TRUE)[, c("id", "label", "defs_wraped")]
names(nodes_def_eq1)[names(nodes_def_eq1) == "defs_wraped"] <- "definition"

nodes_def_ge1$definition <- sapply(X = as.character(nodes_def_ge1$id), combine_defs)

nodes <- rbind(nodes_def_eq1, nodes_def_ge1)

nodes$title <- paste0("<p><b>", nodes$label, "</b></p><br>", nodes$definition)

visNetwork(nodes, edge_list, width = '100%', height = "1000px") %>%
visEdges(arrows = "to") %>%
    visOptions(manipulation = TRUE,
               collapse = TRUE) %>%
    visLayout(randomSeed = 42)

