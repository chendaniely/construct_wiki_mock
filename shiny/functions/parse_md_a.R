parse_md_a <- function(md_str) {
    # get the text between the square brackets and the round brackets in a markdown url
    # taken from: https://stackoverflow.com/questions/1454913/regular-expression-to-find-a-string-included-between-two-characters-while-exclud
    url_name <- str_extract(md_str, '(?<=\\[)(.*?)(?=\\])')
    url_loc <- str_extract(md_str, '(?<=\\()(.*?)(?=\\))')
    return(list('display_name' = url_name,
                'url' = url_loc))
}
