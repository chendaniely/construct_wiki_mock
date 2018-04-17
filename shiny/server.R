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
            return(ORIGINAL_DATA_DF)
        } else if (input$radio_data == ADJUSTED_DATA) {
            return(ADJUSTED_DATA_DF)
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

    construct_row_dat <- reactive({
        construct_row_dat <- constructs()[constructs()$construct == input$construct_name, ]
        print(construct_row_dat)
        return(construct_row_dat)
    })

    num_defs <- reactive({
        ndefs <- nrow(construct_row_dat)
        print(ndefs)
        return(ndefs)
    })

    output$construct_definition_dt <- DT::renderDataTable({
        construct_row_dat()[, c('definition', 'field', 'military', 'population', 'measurement', 'instrument', 'notes')]
    },
    extensions = c('Responsive', 'Buttons'),
    options = list(pageLength = num_defs(),
                   #lengthMenu = c(5, 10, 15, 20, 50, 100, nrow(.GlobalEnv$constructs())),
                   colReorder = TRUE,
                   fixedHeader = TRUE,
                   dom = 'Bt'
    )
    )

    output$construct_dt <- DT::renderDataTable({
        constructs()
    },
    extensions = 'Responsive',
    options = list(pageLength = num_defs(),
                   lengthMenu = c(5, 10, 15, 20, 50, 100, num_defs()),
                   colReorder = TRUE,
                   fixedHeader = TRUE))
})
