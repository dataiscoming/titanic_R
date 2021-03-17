# Packages

# Do not forget to install Rtools before !

# list of the R package to install
packages_cran <- c("rlang","dplyr", "stringr", "naniar", "VIM", "ggplot2", "reticulate", "mice", "corrplot", "Hmisc", "aod",
              "lmtest","pscl","ResourceSelection","tibble","broom","ggimage","rsvg","ggnewscale", "pROC", "remotes",
              "cvms", "caret")

packages_python <- c("kaggle")

install_load_packages(list_packages_cran = packages_cran, 
                      list_packages_python = packages_python)

rm(packages_cran, packages_python, files.sources)

# Change the environnement variable for the kaggle file
Sys.setenv(KAGGLE_CONFIG_DIR = "#1_input/")