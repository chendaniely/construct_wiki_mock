clean_network_df <- function(df) {
    constructs <- df  ## I just didn't want to find/replace my original code

    constructs$defs_wraped <- .GlobalEnv$strwrap_br(constructs$definition)

    edge_list <- constructs[, c("meta_construct", 'construct')]
    names(edge_list) <- c('from', 'to')
    # el <- graph.data.frame(edge_list)

    nodes <- data.frame('id' = unique(c(unique(edge_list$from),
                                        unique(edge_list$to))),
                        stringsAsFactors = FALSE)

    nodes$label <- .GlobalEnv$strwrap_sep(str_to_title(nodes$id), width = 15, sep = '\n')

    multi_defs <- constructs %>%
        group_by_("construct") %>%
        summarize(n = n()) %>%
        filter(n > 1)

    nodes_def_eq1 <- nodes[!nodes$id %in% multi_defs$construct, ]
    nodes_def_ge1 <- nodes[nodes$id %in% multi_defs$construct, ]

    to_merge <- constructs[, c("construct",
                               "defs_wraped")]

    nodes_def_eq1 <- merge(x = nodes_def_eq1,
                           y = to_merge,
                           by.x = 'id',
                           by.y = "construct",
                           all.x = TRUE)[, c("id", "label", "defs_wraped")]
    names(nodes_def_eq1)[names(nodes_def_eq1) == "defs_wraped"] <- "definition_network"

    nodes_def_ge1$definition_network <- sapply(X = as.character(nodes_def_ge1$id),
                                               FUN = .GlobalEnv$combine_defs,
                                               df = constructs)

    nodes <- rbind(nodes_def_eq1, nodes_def_ge1)

    nodes$title <- paste0("<p><b>", nodes$label, "</b></p><br>", nodes$definition_network)

    return(list('nodes' = nodes, 'edges' = edge_list))
}
