library(testthat)

if (interactive()) {
    base_dir <- 'shiny/'
} else {
    base_dir <- './'
}

fxns <- list.files(normalizePath(paste0(base_dir, 'functions')), full.names = TRUE)
sapply(fxns, source, .GlobalEnv)


context("Network Vis")

test_df <- data_frame(
    meta_construct = c('A', 'B', 'A'),
    construct = c('aa', 'bb', 'aa'),
    definition = c('defa1', 'defb', 'defa2')
)

expected_nodes <- data.frame(
    id = c('A', 'B', 'bb', 'aa'),
    label = c('A', 'B', 'Bb', 'Aa'),
    definition_network = c(
        NA,
        NA,
        'defb',
        'Definition 1<br>defa1<br><br>Definition 2<br>defa2'
    ),
    title = c(
        '<p><b>A</b></p><br>NA',
        '<p><b>B</b></p><br>NA',
        '<p><b>Bb</b></p><br>defb',
        '<p><b>Aa</b></p><br>Definition 1<br>defa1<br><br>Definition 2<br>defa2'
    ),
    stringsAsFactors = FALSE
)

expected_edges <- data_frame(
    from = c('A', 'B', 'A'),
    to = c('aa', 'bb', 'aa')
)

expected_output <- list(
    'nodes' = expected_nodes,
    'edges' = expected_edges
)

calculated <- clean_network_df(test_df)
row.names(calculated$nodes) <- 1:nrow(calculated$nodes)
testthat::expect_equal(calculated$edges, expected_edges)
testthat::expect_equal(calculated$nodes, expected_nodes)

context("Combine Definitions")

testthat::expect_equal(combine_defs_str('hello'), 'Definition 1\nhello')
testthat::expect_equal(combine_defs_str(c('hello', 'world')), 'Definition 1\nhello\n\nDefinition 2\nworld')
testthat::expect_equal(
    combine_defs('bb', test_df, def_name = 'definition'),
    "Definition 1<br>defb"
)

testthat::expect_equal(
    combine_defs('aa', test_df, def_name = 'definition'),
    "Definition 1<br>defa1<br><br>Definition 2<br>defa2"
)
