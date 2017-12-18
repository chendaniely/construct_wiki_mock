def_meta_boxes_single <- function(single_row_dat,
                                  input = .GlobalEnv$input, output = .GlobalEnv$output, session = .GlobalEnv$session) {
    construct_row_dat <- single_row_dat

    fluidRow(
        box(
            construct_row_dat$definition,
            title = "Definition",
            solidHeader = TRUE,
            collapsible = FALSE,
            collapsed = FALSE,
            status = 'warning'
        ),
        box(
            h3("Neighboring Construct(s)"),

            p(str_to_title(unique(neighbors(.GlobalEnv$G, input$construct_name, mode = 'all')$name))),

            h3("Field(s) of study"),

            p(construct_row_dat$field),

            h3("Funded by military?"),

            p(construct_row_dat$military),

            h3("Empirical study..."),

            h4("Target population"),

            p(construct_row_dat$population),

            h4("Type of measurement"),

            p(construct_row_dat$measurement),

            h4("Instrument used"),

            p(construct_row_dat$instrument),

            h4("Additional Notes"),

            p(construct_row_dat$notes),

            # a(md_text$display_name, href = md_text$url, target = "_blank"),
            title = "Metadata",
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = TRUE,
            status = 'danger'
        )
    )
}

def_meta_boxes <- function(dat, count_text,
                           input = .GlobalEnv$input, output = .GlobalEnv$output, session = .GlobalEnv$session) {
    construct_row_dat <- dat
    def_count_text <- count_text

    fluidPage(
        fluidRow(
            p(def_count_text)
        ),
        def_meta_boxes_single(construct_row_dat[1, ])

    )
}
