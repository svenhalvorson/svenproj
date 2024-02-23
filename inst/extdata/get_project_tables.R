get_project_tables = function(
  dirs = here::here(c('data/interim', 'data/processed')),
  file_formats = c('rds', 'csv')
){


  # Argument checks ---------------------------------------------------------

  if(
    !all(
      purrr::map_lgl(dirs, dir.exists)
    )
  ){
    stop('Cannot find directories in dirs')
  }

  if(
    any(
      !is.character(file_formats),
      !length(file_formats) %in% 1:2,
      !file_formats %in% c('rds', 'csv')
    )
  ){
    stop('file_formats incorrectly specified')
  }


  # File table --------------------------------------------------------------

  file_paths = purrr::map(
    .x = dirs,
    .f = \(x){
      list.files(
        x,
        full.names = TRUE,
        pattern = paste0('\\.(', paste0(file_formats, collapse = '|'), ')$')
      )
    }
  ) |>
    purrr::reduce(c)

  file_path_df = data.frame(
    file_path = file_paths,
    file_name = purrr::map_chr(
      .x = file_paths,
      .f = \(x){
        x |>
          strsplit('/', fixed = TRUE) |>
          unlist() |>
          dplyr::last()
      }
    )
  )

  file_path_df[['file_format']] = ifelse(
    grepl('.rds', file_path_df[['file_name']], ignore.case = TRUE),
    'rds',
    'csv'
  )

  file_path_df[['table_name']] = gsub(
    pattern = '\\.(csv|rds)$',
    replacement = '',
    x = file_path_df[['file_name']]
  )


  # Uniqueness check --------------------------------------------------------

  if(
    length(unique(file_path_df[['table_name']])) < nrow(file_path_df)
  ){
    stop('Duplicate tables found within union of dirs')
  }



  # Read and return ---------------------------------------------------------

  project_data = Map(
    f = function(file_path, file_format){

      read_fun = ifelse(
        file_format == 'rds',
        readr::read_rds,
        \(x) {readr::read_csv(x, show_col_types = FALSE)}
      )
      read_fun(file_path)
    },
    file_path_df[['file_path']],
    file_path_df[['file_format']]
  ) |>
    purrr::set_names(file_path_df[['table_name']])

  project_data

}
