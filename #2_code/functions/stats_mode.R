# Function to compute the statistical mode 

Mode <- function(x, na.rm = TRUE) {
  if(na.rm){
    x = x[!is.na(x)]
  }
  
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

# source 
# https://stackoverflow.com/questions/2547402/how-to-find-the-statistical-mode