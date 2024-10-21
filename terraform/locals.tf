locals {
  # Paths for loading the code related to the Lambda Functions
  module_path             = abspath(path.module)
  root_path               = abspath("${path.module}/..")
  src_root_path           = abspath("${path.module}/../app-python")
  lambda_layers_root_path = abspath("${path.module}/../lambda-layers")
  static_folder_root_path = abspath("${path.module}/../app-python/src/static")
  static_files  = fileset(local.static_folder_root_path, "**")  # Recursively get all files in the static folder
}
