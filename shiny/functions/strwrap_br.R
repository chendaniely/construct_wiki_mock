strwrap_br <- function(input_string, width = 79, sep = '<br>') {
    wrapped <- strwrap_sep(input_string, sep, width = 79)
    return(wrapped)
}
