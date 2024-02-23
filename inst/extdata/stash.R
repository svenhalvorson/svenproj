stash = function(
    df,
    df_name,
    data_dir = 'processed',
    format = 'rds',
    predicate_fun
  ){

  if(missing(predicate_fun)){
    predicate_fun = function(){lubridate::wday(Sys.Date()) %in% c(2, 5)}
  }

  write_fun = switch(
    format,
    rds = readr::write_rds,
    csv = readr::write_excel_csv
  )

  write_fun(
    df,
    here::here(
      'data',
      data_dir,
      paste0(df_name, '.', format)
    )
  )

  if(predicate_fun()){

    extract_date = format(Sys.Date(), '%Y%m%d')

    write_fun(
      df,
      here::here(
        'data',
        data_dir,
        df_name,
        paste0(df_name, '_', extract_date, '.', format)
      )
    )
  }

}
