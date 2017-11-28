library(shiny)

shinyUI(navbarPage("Construct Viewer",
                   tabPanel("Network",
                            radialNetworkOutput("radial_network")),
                   tabPanel("Definitions",
                            selectizeInput('construct_name', 'Construct Name', pokemon$name),
                            verbatimTextOutput('construct_definition')
                   ),
                   tabPanel("Data",
                            DT::dataTableOutput('construct_dt')),
                   navbarMenu("More",
                              tabPanel("Sub-Component A"),
                              tabPanel("Sub-Component B"))
))
