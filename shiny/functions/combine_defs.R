
combine_defs_str <- function(strs, str_prefix = "Definition", numbered_from = 1, col = '\n\n') {
    # make sure you pass in a vector for strs, not a tibble of 1 column
    # length will not work properly otherwise
    formatted <- sprintf('%s %s\n%s',
                         str_prefix, numbered_from:length(strs), strs)
    paste0(str_trim(formatted), collapse = col)

}

combine_defs <- function(construct, df,
                         construct_name = 'construct',
                         def_name = 'defs_wraped') {
    sub_df <- as.data.frame(df[df[construct_name] == construct, ])
    defs <- sub_df[, def_name]
    str_rep <- combine_defs_str(defs)
    html_rep <- str_replace_all(str_rep, '\\\n', '<br>')
    return(html_rep)
}

combine_values <- function(construct, df, combin_col, construct_col = 'construct') {
    sub_df <- as.data.frame(df[df[construct_col] == construct, c(construct_col, combin_col)])
}
