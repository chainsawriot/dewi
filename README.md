
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dewi

<!-- badges: start -->

<!-- badges: end -->

The goal of dewi is to query German Wikitionary for a noun and its
possible alternative forms. For example, querying the word “Japaner”
(Male Japanese) will generate the plural form “Japaner”, the genitive
form “Japaners”, the dative plural form “Japanern”, the female
counterpart “Japanerin”, the plural female counterpart “Japanerinnen”.

## Installation

You can install the Github version of dewi with:

``` r
devtools::install_github("chainsawriot/dewi")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(dewi)
dewi("Japaner")
#> # A tibble: 16 × 4
#>    genus kasus     numerus  wort        
#>    <chr> <chr>     <chr>    <chr>       
#>  1 m     Nominativ Singular Japaner     
#>  2 m     Nominativ Plural   Japaner     
#>  3 m     Genitiv   Singular Japaners    
#>  4 m     Genitiv   Plural   Japaner     
#>  5 m     Dativ     Singular Japaner     
#>  6 m     Dativ     Plural   Japanern    
#>  7 m     Akkusativ Singular Japaner     
#>  8 m     Akkusativ Plural   Japaner     
#>  9 f     Nominativ Singular Japanerin   
#> 10 f     Nominativ Plural   Japanerinnen
#> 11 f     Genitiv   Singular Japanerin   
#> 12 f     Genitiv   Plural   Japanerinnen
#> 13 f     Dativ     Singular Japanerin   
#> 14 f     Dativ     Plural   Japanerinnen
#> 15 f     Akkusativ Singular Japanerin   
#> 16 f     Akkusativ Plural   Japanerinnen
```

``` r
dewi("Japanerin")
#> # A tibble: 16 × 4
#>    genus kasus     numerus  wort        
#>    <chr> <chr>     <chr>    <chr>       
#>  1 f     Nominativ Singular Japanerin   
#>  2 f     Nominativ Plural   Japanerinnen
#>  3 f     Genitiv   Singular Japanerin   
#>  4 f     Genitiv   Plural   Japanerinnen
#>  5 f     Dativ     Singular Japanerin   
#>  6 f     Dativ     Plural   Japanerinnen
#>  7 f     Akkusativ Singular Japanerin   
#>  8 f     Akkusativ Plural   Japanerinnen
#>  9 m     Nominativ Singular Japaner     
#> 10 m     Nominativ Plural   Japaner     
#> 11 m     Genitiv   Singular Japaners    
#> 12 m     Genitiv   Plural   Japaner     
#> 13 m     Dativ     Singular Japaner     
#> 14 m     Dativ     Plural   Japanern    
#> 15 m     Akkusativ Singular Japaner     
#> 16 m     Akkusativ Plural   Japaner
```

``` r
## N-deklination
dewi("Asiat")
#> # A tibble: 16 × 4
#>    genus kasus     numerus  wort      
#>    <chr> <chr>     <chr>    <chr>     
#>  1 m     Nominativ Singular Asiat     
#>  2 m     Nominativ Plural   Asiaten   
#>  3 m     Genitiv   Singular Asiaten   
#>  4 m     Genitiv   Plural   Asiaten   
#>  5 m     Dativ     Singular Asiaten   
#>  6 m     Dativ     Plural   Asiaten   
#>  7 m     Akkusativ Singular Asiaten   
#>  8 m     Akkusativ Plural   Asiaten   
#>  9 f     Nominativ Singular Asiatin   
#> 10 f     Nominativ Plural   Asiatinnen
#> 11 f     Genitiv   Singular Asiatin   
#> 12 f     Genitiv   Plural   Asiatinnen
#> 13 f     Dativ     Singular Asiatin   
#> 14 f     Dativ     Plural   Asiatinnen
#> 15 f     Akkusativ Singular Asiatin   
#> 16 f     Akkusativ Plural   Asiatinnen
```

``` r
dewi("Mannheimer")
#> # A tibble: 16 × 4
#>    genus kasus     numerus  wort           
#>    <chr> <chr>     <chr>    <chr>          
#>  1 m     Nominativ Singular Mannheimer     
#>  2 m     Nominativ Plural   Mannheimer     
#>  3 m     Genitiv   Singular Mannheimers    
#>  4 m     Genitiv   Plural   Mannheimer     
#>  5 m     Dativ     Singular Mannheimer     
#>  6 m     Dativ     Plural   Mannheimern    
#>  7 m     Akkusativ Singular Mannheimer     
#>  8 m     Akkusativ Plural   Mannheimer     
#>  9 f     Nominativ Singular Mannheimerin   
#> 10 f     Nominativ Plural   Mannheimerinnen
#> 11 f     Genitiv   Singular Mannheimerin   
#> 12 f     Genitiv   Plural   Mannheimerinnen
#> 13 f     Dativ     Singular Mannheimerin   
#> 14 f     Dativ     Plural   Mannheimerinnen
#> 15 f     Akkusativ Singular Mannheimerin   
#> 16 f     Akkusativ Plural   Mannheimerinnen
```

``` r
dewi("Frau")
#> # A tibble: 8 × 4
#>   genus kasus     numerus  wort  
#>   <chr> <chr>     <chr>    <chr> 
#> 1 f     Nominativ Singular Frau  
#> 2 f     Nominativ Plural   Frauen
#> 3 f     Genitiv   Singular Frau  
#> 4 f     Genitiv   Plural   Frauen
#> 5 f     Dativ     Singular Frau  
#> 6 f     Dativ     Plural   Frauen
#> 7 f     Akkusativ Singular Frau  
#> 8 f     Akkusativ Plural   Frauen
```
