combine_defs <- function(construct, df,
                         construct_name = 'construct',
                         def_name = 'defs_wraped') {
    sub_df <- df[df[construct_name] == construct, ]
    defs <- sub_df[, def_name]

    str_rep <- paste0(str_trim(sprintf('Definition %s\n%s', 1:length(defs), defs)), collapse = '\n\n')
    html_rep <- str_replace_all(str_rep, '\\\n', '<br>')
    return(html_rep)
}
