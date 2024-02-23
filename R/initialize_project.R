#' Initialize project
#'
#' @param project_name directory name for project
#' @param directory_parent parent directory for project
#'
#' @return NULL
#' @export
#'
initialize_project = function(
    project_name,
    directory_parent = getwd()
  ){

  # Directories -------------------------------------------------------------

  stopifnot(
    all(
      dir.exists(directory_parent),
      is.character(project_name),
      length(project_name) == 1
    )
  )

  directory_parent = paste0(
    gsub(
      pattern = '/$',
      replacement = '',
      x = directory_parent
    ),
    '/'
  )

  project_directory = paste0(
    directory_parent,
    project_name,
    '/'
  )

  stopifnot(
    "Project directory already exists!" = !dir.exists(project_directory),
    "Project directory not created!" = dir.create(project_directory)
  )

  subdirs = c(
    'code',
    'code/build_sequence',
    'code/experiments',
    'code/functions',
    'code/reports',
    'code/scripts',
    'data',
    'data/crosswalks',
    'data/interim',
    'data/processed',
    'data/raw',
    'data/requests',
    'references',
    'references/instruments'
  )

  Map(
    f = dir.create,
    paste0(project_directory, subdirs)
  )

  Map(
    f = function(con){
      writeLines(
        text = '',
        con = paste0(con, '/.gitignore')
      )
    },
    paste0(project_directory, subdirs)
  )

  # File copy ---------------------------------------------------------------

  # Few things we'll probably want to copy as templates.
  svenproj_file = function(file_name){
    system.file(
      'extdata',
      file_name,
      package = 'svenproj'
    )
  }

  # 1. Scripts
  file.copy(
    from = svenproj_file('driver.R'),
    to = paste0(project_directory, 'code/scripts')
  )
  file.copy(
    from = svenproj_file('renv_run.R'),
    to = paste0(project_directory, 'code/scripts')
  )

  # 2. Sequence template
  file.copy(
    from = svenproj_file('00_setup.R'),
    to = paste0(project_directory, 'code/build_sequence')
  )

  # 3. Report
  file.copy(
    from = svenproj_file('report_template.Rmd'),
    to = paste0(project_directory, 'code/reports')
  )

  # 4. Functions
  Map(
    f = function(x){
      file.copy(
        svenproj_file(x),
        paste0(project_directory, 'code/functions')
      )
    },
    c(
      'get_project_functions.R',
      'get_project_tables.R',
      'stash.R'
    )
  )

  # Initialize RStudio project ----------------------------------------------

  rstudioapi::initializeProject(project_directory)


  invisible(NULL)

}
