library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$vis_network <- renderVisNetwork({
        visNetwork(nodes, edge_list, width = "100%", height = "800px") %>%
            visEdges(arrows = "from") %>%
            visOptions(manipulation = TRUE,
                       collapse = TRUE) %>%
            visLayout(randomSeed = 42)
    })


    output$construct_dt <- DT::renderDataTable({
        pokemon
    })

    output$construct_definition <- renderText({
        row_dat <- pokemon[pokemon$name == input$construct_name, ]
        sprintf("Construct: %s\nEmbedded under: %s\nDefinition:%s",
                row_dat$name, row_dat$meta.contruct, row_dat$definition)
    })
})
