.extract_what <- function(x = "\\{\\{Weibliche", parsed, ending = "") {
    idx <- which(stringr::str_detect(parsed, x))[1] + 1
    if (identical(idx, numeric(0)) | is.na(idx)) {
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
        rex <- "[^a-zA-Z \u00e4\u00f6\u00fc\u00c4\u00d6\u00dc\u00df\u00b7/]"
    } else {
        rex <- "[^a-zA-Z \u00e4\u00f6\u00fc\u00c4\u00d6\u00dc\u00df/]"
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
    genus_rows <- purrr::keep(uebersicht, ~stringr::str_detect(.[1], "^Genus"))
    other_rows <- purrr::discard(uebersicht, ~stringr::str_detect(.[1], "^Genus"))
    if (length(genus_rows) == 0) {
        stop("Unknown Genus. Probably not a noun.", call.= FALSE)
    }
    if (length(genus_rows) > 1) {
        warning("This word has more than one Genus. Will only take the first one.")
    }
    genus <- genus_rows[[1]][2]
    kasus <- other_rows %>% purrr::map_chr(1) %>% stringr::str_split(" ") %>% purrr::map_chr(1)
    numerus <- other_rows %>% purrr::map_chr(1) %>% stringr::str_split(" ") %>% purrr::map_chr(2)
    wort <- other_rows %>% purrr::map_chr(2)
    tibble::tibble("genus" = genus, "kasus" = kasus, "numerus" = numerus, "wort" = wort)
}

.get_wiki_content <- function(title) {
    res <- httr::content(httr::GET("https://de.wiktionary.org/w/api.php", query=list(action = "query", titles = title, format = "json", prop = "revisions", rvlimit = 1, rvprop = 'content')))
    res$query$pages[[1]]$revisions[[1]]$`*`
}

.get_ueber <- function(title, just_ueber = TRUE) {
    wiki_content <- .get_wiki_content(title)
    if (is.null(wiki_content)) {
        warning("No German Wikitionary entry for \"", title, "\".", call.=FALSE)
        return(NA)
    }
    parsed <- stringr::str_split(wiki_content, "\n")[[1]]
    uebersicht <- .parse_uebersicht(.extract_what(x = "Deutsch Substantiv Übersicht", parsed = parsed))
    if (!"tbl_df" %in% class(uebersicht)) {
        return(NA)
    }
    if (just_ueber) {
        return(uebersicht)
    } else {
        return(list(uebersicht, parsed))
    }
}

#' @export
dewi <- function(title) {
    res <- .get_ueber(title, just_ueber = FALSE)
    if (!is.list(res)) {
        return(NA)
    }
    uebersicht1 <- res[[1]]
    genus1 <- unique(uebersicht1$genus)
    if (genus1 == "f") {
        alternativ_genus <- "M\u00e4nnliche"
    } else if (genus1 == "m") {
        alternativ_genus <- "Weibliche"
    } else if (genus1 == "n") {
        return(uebersicht1)
    }
    alternativ_title <- .clean_text(.extract_what(x = alternativ_genus, res[[2]]))
    if (is.na(alternativ_title)) {
        return(uebersicht1)
    }
    multiple_alternativ_titles <- stringr::str_split(alternativ_title, "[ /]")[[1]]
    uebersicht2_list <- purrr::map(multiple_alternativ_titles, .get_ueber)
    uebersicht2_list[!is.na(c(uebersicht2_list, NA))] %>% dplyr::bind_rows() -> uebersicht2
    dplyr::bind_rows(uebersicht1, uebersicht2)
}
