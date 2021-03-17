# Distribution plot : plot an histogram or a barplot for a variable according the explained variable

dist_plot <- function(df, x, y, bin){
  
  if(is.numeric(df[,x])){
    plot <- ggplot(data = df, aes(df[,x], fill=df[,y])) +
      theme_bw() +
      geom_histogram(binwidth = bin, col="grey")
  } else{
    plot <- ggplot(data = df, aes(df[,x], fill=df[,y])) +
      theme_bw() +
      geom_bar()
  }
  
  plot <- plot +
    labs(x= NULL, y =NULL) +
    guides(fill=guide_legend(title="Survived (0=No,\n1=Yes)"))

  return(plot)
}
