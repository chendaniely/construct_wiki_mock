library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$vis_network <- renderVisNetwork({
        visNetwork(network_dfs$nodes, network_dfs$edges, width = "100%", height = "75%") %>%
            visEdges(arrows = "from") %>%
            visOptions(manipulation = TRUE,
                       collapse = TRUE) %>%
            visLayout(randomSeed = 42)
    })

    output$construct_definition <- renderUI({
        # md_text <- .GlobalEnv$parse_md_a('[A document](https://drive.google.com/open?id=0B7onm2yXv1-wX2FJVkxVUUZ3a2c)')
        # print(sprintf('selected: %s', input$construct_name))
        construct_row_dat <- .GlobalEnv$constructs[.GlobalEnv$constructs$construct == input$construct_name, ]

        def_count_text <- if_else(nrow(construct_row_dat) == 1,
                                  sprintf("There is %s definition for this construct", nrow(construct_row_dat)),
                                  sprintf("There are %s definitions for this construct", nrow(construct_row_dat)))

        .GlobalEnv$def_meta_boxes(construct_row_dat, def_count_text)

    })

    output$construct_dt <- DT::renderDataTable({
        .GlobalEnv$constructs
    }, options = list(pageLength = nrow(.GlobalEnv$constructs),
                      lengthMenu = c(5, 10, 15, 20, 50, 100, nrow(.GlobalEnv$constructs)),
                      colReorder = TRUE,
                      fixedHeader = TRUE,
                      extensions = 'Responsive'))
})
