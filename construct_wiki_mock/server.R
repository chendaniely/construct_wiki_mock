library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$radial_network <- renderRadialNetwork({
      radialNetwork(lol)
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
