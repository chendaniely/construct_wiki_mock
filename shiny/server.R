library(shiny)

# helpful
# https://gist.github.com/tbadams45/38f1f56e0f2d7ced3507ef11b0a2fdce
# https://www.rstudio.com/resources/webinars/understanding-shiny-modules/
# https://gist.github.com/bborgesr/e1ce7305f914f9ca762c69509dda632e
# https://stackoverflow.com/questions/21636023/r-shiny-simple-reactive-issue
# http://shiny.leg.ufpr.br/daniel/025-loop-ui/
# https://shiny.rstudio.com/gallery/creating-a-ui-from-a-loop.html


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    constructs <- reactive({
        if (input$radio_data == ORIGINAL_DATA) {
            read_delim(ORIGINAL_DATA,
                       delim = '\t',
                       skip = 1,
                       col_names = c('timestamp', 'email', 'construct',
                                     'meta_construct', 'definition', 'reference',
                                     'bibtex', 'field', 'military', 'population',
                                     'measurement', 'instrument', 'notes', 'bibkey'))
        } else if (input$radio_data == ADJUSTED_DATA) {
            read_delim(ADJUSTED_DATA,
                       delim = '\t',
                       skip = 1,
                       col_names = c('timestamp', 'email', 'construct', 'meta_construct',
                                     'meta_construct_ori', 'definition', 'reference',
                                     'bibtex', 'field', 'military', 'population',
                                     'measurement', 'instrument', 'notes', 'bibkey'))
        }
    })

    # pokemon <- read.csv('data/pokemon.csv', sep = '\t', stringsAsFactors = FALSE)

    construct_values <- reactive({
        cv <- constructs()$construct
        names(cv) <- str_to_title(cv)
        return(cv)
    })

    network_dfs <- reactive({
        .GlobalEnv$clean_network_df(constructs())
    })

    # G <- igraph::graph_from_data_frame(network_dfs$edges)

    # neighbors(G, 'character')

    # this is just to test if the thing actually works...
    # visNetwork(network_dfs$nodes, network_dfs$edges, width = '100%', height = "1000px") %>%
    # visEdges(arrows = "to") %>%
    #     visOptions(manipulation = TRUE,
    #                collapse = TRUE) %>%
    #     visLayout(randomSeed = 42)

    output$vis_network <- renderVisNetwork({
        visNetwork(network_dfs()$nodes, network_dfs()$edges, width = "100%", height = "75%") %>%
            visEdges(arrows = "from") %>%
            visOptions(manipulation = TRUE,
                       collapse = TRUE) %>%
            visLayout(randomSeed = 42)
    })

    output$construction_selection <- renderUI({
        selectizeInput('construct_name', 'Construct Name', sort(construct_values()))
    })

    output$construct_definition <- renderUI({
        # md_text <- .GlobalEnv$parse_md_a('[A document](https://drive.google.com/open?id=0B7onm2yXv1-wX2FJVkxVUUZ3a2c)')
        # print(sprintf('selected: %s', input$construct_name))
        construct_row_dat <- constructs()[constructs()$construct == input$construct_name, ]

        def_count_text <- if_else(nrow(construct_row_dat) == 1,
                                  sprintf("There is %s definition for this construct", nrow(construct_row_dat)),
                                  sprintf("There are %s definitions for this construct", nrow(construct_row_dat)))

        # .GlobalEnv$def_meta_boxes(construct_row_dat, def_count_text)

    })

    output$construct_dt <- DT::renderDataTable({
        constructs()
    }, options = list(pageLength = nrow(.GlobalEnv$constructs()),
                      lengthMenu = c(5, 10, 15, 20, 50, 100, nrow(.GlobalEnv$constructs())),
                      colReorder = TRUE,
                      fixedHeader = TRUE,
                      extensions = 'Responsive'))
})
