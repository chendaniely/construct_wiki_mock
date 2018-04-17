strwrap_sep <- function(input_string, sep, width=79) {
    wrapped <- sapply(input_string, strwrap, width = width)
    wrapped <- unlist(lapply(wrapped, paste0, collapse = sep))
    wrapped <- str_trim(wrapped)
    return(wrapped)
}
