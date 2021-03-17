# This a function the will install all packages that are not already insatlled, and then load them.

install_load_packages <- function(list_packages_cran=NULL, list_packages_github=NULL, list_packages_python=NULL){
  
  # Loop to iterate the actions below on all the packages listed from the CRAN
  for(i in c(1:length(list_packages_cran))){
    
    #  Check : is the packages already installed
    if(!is.element(list_packages_cran[i],installed.packages()[,1])){
      
      # Install the package that is not already insatlled
      install.packages(list_packages_cran[i],dep = TRUE,Ncpus=2) # parallel::detectCores() to set ncpus
    }
    
    # Then, load the package 
    library(list_packages_cran[i],character.only = TRUE)
  }
  
  # Loop to iterate the actions below on all the packages listed from the Github
  if(!is.null(list_packages_github)){
    for(i in c(1:length(list_packages_github))){
      if(!is.element(str_split(list_packages_github[i],"/",simplify = T)[,2],installed.packages()[,1])){
        install_github(list_packages_github[i], debug = T)
      }
      library(str_split(list_packages_github[i],"/",simplify = T)[,2],character.only = TRUE)
    }
  }
  
  
  # Loop to iterate the actions below on all the packages listed from the Python
  if(!is.null(list_packages_python)){
    for(i in c(1:length(list_packages_python))){
      #if(!str_detect(str_flatten(), list_packages_python[i])){
      if(!py_module_available(list_packages_python[i])){
        py_install(list_packages_python[i])
      }
      import(list_packages_python[i])
    }
  }
} 

# reference
# http://www.salemmarafi.com/code/install-r-package-automatically/