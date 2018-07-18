library(readr)
library(tibble)

read_dataset = function(datafile) {
  data = read_csv(datafile)
  
  ## These two neighborhoods only have 1 and 2 observations respectively.
  ## Remove them from the dataset
  data = data[-which(data$Neighborhood %in% c("GrnHill","Landmrk")),]
  
  
  ## We don't need this column
  data = data[, -which(names(data) %in% c("PID"))]
  
  ## hack to coerce all character columns from a tibble to factor
  data = as.data.frame(unclass(as.data.frame(data)))
  data = as_tibble(data)
}

read_dataset("data/AmesHousing.csv")
