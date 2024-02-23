get_project_functions = function(){

  list.files(
    here::here('code/functions/'),
    full.names = TRUE
  ) |>
    setdiff(here::here('code/functions/get_project_functions.R')) |>
    purrr::walk(source)

  invisible(NULL)

}

