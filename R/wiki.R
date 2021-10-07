.extract_what <- function(x = "\\{\\{Weibliche", parsed, ending = "") {
    idx <- which(stringr::str_detect(parsed, x)) + 1
    if (identical(idx, numeric(0))) {
        return(NA)
    }
    ans <- c()
    while(TRUE) {
        if (parsed[idx] == ending) {
            return(ans)
        } else {
            ans <- c(ans, parsed[idx])
            idx <- idx + 1
        }
    }
}

.clean_text <- function(x, dot = FALSE) {
    ## clean up all non-german characters
    if (dot) {
        rex <- "[^a-zA-Z \u00e4\u00f6\u00fc\u00c4\u00d6\u00dc\u00df\u00b7]"
    } else {
        rex <- "[^a-zA-Z \u00e4\u00f6\u00fc\u00c4\u00d6\u00dc\u00df]"
    }
    stringr::str_trim(stringr::str_replace_all(x, rex, ""))
}

.parse_uebersicht <- function(x) {
    if (length(x) == 1) {
        if (is.na(x)) {
            return(NA)
        }
    }
    uebersicht <- purrr::keep(x, ~stringr::str_detect(., "^\\|Genus|^\\|Nominativ|^\\|Genitiv|^\\|Dativ|^\\|Akkusativ")) %>%  stringr::str_replace("^\\|", "") %>% stringr::str_split("\\=")
    genus <- uebersicht[[1]][2]
    kasus <- uebersicht[-1] %>% purrr::map_chr(1) %>% stringr::str_split(" ") %>% purrr::map_chr(1)
    numerus <- uebersicht[-1] %>% purrr::map_chr(1) %>% stringr::str_split(" ") %>% purrr::map_chr(2)
    wort <- uebersicht[-1] %>% purrr::map_chr(2)
    tibble::tibble("genus" = genus, "kasus" = kasus, "numerus" = numerus, "wort" = wort)
}

.get_wiki_content <- function(title) {
    res <- httr::content(httr::GET("https://de.wiktionary.org/w/api.php", query=list(action = "query", titles = title, format = "json", prop = "revisions", rvlimit = 1, rvprop = 'content')))
    res$query$pages[[1]]$revisions[[1]]$`*`
}

#' @export
dewi <- function(title) {
    wiki_content <- .get_wiki_content(title)
    parsed <- stringr::str_split(wiki_content, "\n")[[1]]
    uebersicht1 <- .parse_uebersicht(.extract_what(x = "Deutsch Substantiv Übersicht", parsed = parsed))
    if (!"tbl_df" %in% class(uebersicht1)) {
        return(NA)
    }
    genus1 <- unique(uebersicht1$genus)
    if (genus1 == "f") {
        alternativ_genus <- "M\u00e4nnliche"
    } else if (genus1 == "m") {
        alternativ_genus <- "Weibliche"
    } else if (genus1 == "n") {
        return(uebersicht1)
    }
    alternativ_title <- .clean_text(.extract_what(x = alternativ_genus, parsed))
    if (is.na(alternativ_title)) {
        return(uebersicht1)
    }
    wiki_content2 <- .get_wiki_content(alternativ_title)
    parsed2 <- stringr::str_split(wiki_content2, "\n")[[1]]
    uebersicht2 <- .parse_uebersicht(.extract_what(x = "Deutsch Substantiv Übersicht", parsed = parsed2))
    dplyr::bind_rows(uebersicht1, uebersicht2)
}
