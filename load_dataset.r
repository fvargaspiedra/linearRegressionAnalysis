library(readr)
library(tibble)

read_dataset = function(datafile) {
  data = read_csv(datafile)
  
  ## hack to coerce all character columns from a tibble to factor
  data = as.data.frame(unclass(as.data.frame(data)))

  ## These two neighborhoods only have 1 and 2 observations respectively.
  ## Remove them from the dataset
  data = data[-which(data$Neighborhood %in% c("GrnHill","Landmrk")),]

  ## These observations have 0 recorded bedrooms, might be invalid.
  data = data[-which(data$Bedroom.AbvGr == 0),]

  ## We don't need this column - this is an ID column.
  data = data[, -which(names(data) %in% c("PID"))]

  ## This numeric columns might make more sense as factor variables.
  data$Mo.Sold = as.factor(data$Mo.Sold)

  return(as_tibble(data))
}

