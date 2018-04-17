library(shiny)

dashboardPage(
    dashboardHeader(disable = TRUE),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        navbarPage(
            "Construct Viewer",
            tabPanel("Network",
                     fluidPage(
                         fluidRow(
                             h1("Construct Network Visualization"),
                             p(paste("Here you will find all the constructs and their relations to one another.",
                                     sep = ' ')),
                             p(paste("Hovering over a node will display the definition of the construct",
                                     sep = ' ')),
                             p("Multiple edges refer to multiple definitions for the construct"),
                             p("Zoom in to see the labels.")
                         ),
                         fluidRow(
                             column(10,
                                    visNetworkOutput("vis_network", width = "100%", height = "800px")),
                             column(2,
                                    radioButtons("radio_data", label = 'Dataset',
                                                 choices = list("Adjusted" = .GlobalEnv$ADJUSTED_DATA,
                                                                "Original" = .GlobalEnv$ORIGINAL_DATA
                                                 ),
                                                 selected = .GlobalEnv$ADJUSTED_DATA
                                    ),
                                    p(paste(
                                        "You can click the edit button to modify and explore the network directly (without)",
                                        "changing the underlying data structure.",
                                        "For example, you can add an edge to/from 'Education' to 'Wisdom and Knowledge' and see",
                                        "how the networks change.",
                                        sep = ' '
                                    )),
                                    p("Double-cliking nodes will collapse all connections."))
                         )
                     )
            ),
            tabPanel("Definitions",
                     h1("Construct Definitions"),
                     p(paste("Here you can select a specific construct and see the definition and more details.",
                             sep = ' ')),
                     uiOutput('construction_selection'),
                     DT::dataTableOutput('construct_definition_dt')
            ),
            tabPanel("Data",
                     DT::dataTableOutput('construct_dt')
            ),
            navbarMenu("More",
                       tabPanel("Raw Data View",
                                h1("Raw Data View"),
                                p("Here you can see the exact data from the underlying spreadsheet used to populate the construct viewer."),
                                HTML('<iframe src="https://docs.google.com/spreadsheets/d/e/2PACX-1vR2imOgIzmv8ayb7rDrvVySZ0vFDGNULSGNgT5ObdXOyEEnrok-JlW4MP0jWNSJl1aP_UuKgVDsFZer/pubhtml?gid=432933410&amp;single=true&amp;widget=true&amp;headers=false" style="position: absolute; height: 80%; width: 97%; border: none"></iframe>')),
                       tabPanel("Empty"))
        )
    )
)
