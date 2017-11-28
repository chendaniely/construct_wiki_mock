library(shiny)
library(data.tree)
library(networkD3)
library(DT)

pokemon <- read.csv('data/pokemon.csv', sep = '\t')

tree <- FromDataFrameNetwork(pokemon[, 1:2])
lol <- ToListExplicit(tree, unname = TRUE)


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
