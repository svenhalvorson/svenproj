
# Run scripts -------------------------------------------------------------

library('tidyverse')
source(here::here('code/functions/get_project_functions.R'))
get_project_functions()

here::here( 'code/build_sequence') |>
  list.files(full.names = TRUE, pattern = '(?i)\\.R$') |>
  walk(
    .f = function(x){
      cat(
        '\n\n*********************************\n\n',
        last(unlist(str_split(x, '/'))),
        '\n\n*********************************\n\n'
      )
      source(x, local = new.env())
      invisible(NULL)
    }
  )


# Render reports ----------------------------------------------------------

# May need to set this:
# Sys.setenv("RSTUDIO_PANDOC" = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools")

here::here( 'code/reports') |>
  list.files(full.names = TRUE, pattern = '(?i)\\.Rmd$') |>
  walk(
    .f = function(x){
      cat(
        '\n\n*********************************\n\n',
        last(unlist(str_split(x, '/'))),
        '\n\n*********************************\n\n'
      )
      rmarkdown::render(x)
      invisible(NULL)
    }
  )

