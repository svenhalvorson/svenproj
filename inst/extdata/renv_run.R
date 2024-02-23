# Run a script through renv using the command line:

script_name = commandArgs(trailingOnly = TRUE)[1]

renv::run(
  script = paste0(
    '##PROJ_DIR##/code/scripts/',
    script_name
  ),
  project = '##PROJ_DIR##'
)
