library(readr)
library(tibble)
library(MASS)

read_dataset = function(datafile) {
  data = read_csv(datafile)
  data$`Total Bsmt SF`[is.na(data$`Total Bsmt SF`)] = 0 
  data$`Bsmt Half Bath`[is.na(data$`Bsmt Half Bath`)] = 0
  data$`Bsmt Full Bath`[is.na(data$`Bsmt Full Bath`)] = 0
  data$`Mas Vnr Area`[is.na(data$`Mas Vnr Area`)] = 0
  data$`BsmtFin SF 1`[is.na(data$`BsmtFin SF 1`)] = 0
  data$`BsmtFin SF 2`[is.na(data$`BsmtFin SF 2`)] = 0
  data$`Bsmt Exposure`[is.na(data$`Bsmt Exposure`)] = 0
  data$`Bsmt Unf SF`[is.na(data$`Bsmt Unf SF`)] = 0 
  data$`Bsmt Qual`[is.na(data$`Bsmt Qual`)] = 0
  data$`Garage Area`[is.na(data$`Garage Area`)] = 0 
  data$`Garage Yr Blt`[is.na(data$`Garage Yr Blt`)] = 0
  data$`Garage Cars`[is.na(data$`Garage Cars`)] = 0
  data$`Open Porch SF`[is.na(data$`Open Porch SF`)] = 0
  data$`Lot Frontage`[is.na(data$`Lot Frontage`)] = 0 
  data$`3Ssn Porch`[is.na(data$`3Ssn Porch`)] = 0 
  data$`2nd Flr SF`[is.na(data$`2nd Flr SF`)] = 0
  data$`Low Qual Fin SF`[is.na(data$`Low Qual Fin SF`)] = 0
  data$`Pool Area`[is.na(data$`Pool Area`)] = 0 
  data$Alley[is.na(data$Alley)] = "None"
  data$Fence[is.na(data$Fence)] = "None"
  data$Utilities[is.na(data$Utilities)] = "None"
  data$`Pool QC`[is.na(data$`Pool QC`)] = "None"
  data$`Land Contour`[is.na(data$`Land Contour`)] = "None"
  data$`Fireplace Qu`[is.na(data$`Fireplace Qu`)] = "None"
  data$`Land Slope`[is.na(data$`Land Slope`)] = "None"
  
  data$`Lot Config`[is.na(data$`Lot Config`)] = "None"
  data$`BsmtFin Type 2`[is.na(data$`BsmtFin Type 2`)] = "None"
  data$`BsmtFin Type 1`[is.na(data$`BsmtFin Type 1`)] = "None" 
  data$`Bsmt Cond`[is.na(data$`Bsmt Cond`)] = "None"
  data$`Electrical`[is.na(data$`Electrical`)] = "None"
  data$`Mas Vnr Type`[is.na(data$`Mas Vnr Type`)] = "None"
  data$`Misc Val`[is.na(data$`Misc Val`)] = "None"
  data$`Garage Finish`[is.na(data$`Garage Finish`)] = "None"
  data$`Garage Qual`[is.na(data$`Garage Qual`)] = "None"
  data$`Garage Cond`[is.na(data$`Garage Cond`)] = "None"
  data$`Garage Type`[is.na(data$`Garage Type`)] = "None"
  data$`Roof Matl`[is.na(data$`Roof Matl`)] = "None"
  
  
  ## hack to coerce all character columns from a tibble to factor
  data = as.data.frame(unclass(as.data.frame(data)))

  ## These two neighborhoods only have 1 and 2 observations respectively.
  ## Remove them from the dataset
  data = data[-which(data$Neighborhood %in% c("GrnHill","Landmrk")),]

  ## These observations have 0 recorded bedrooms, might be invalid.
  data = data[-which(data$Bedroom.AbvGr == 0),]
  
  data = data[-which(data$SalePrice > 4e5),]
  data = data[-which(data$Gr.Liv.Area > 3e3),]

  ## We don't need this column - this is an ID column.
  data = data[, -which(names(data) %in% c("PID"))]
  data = data[, -which(names(data) %in% c("Order"))]

  ## This numeric columns might make more sense as factor variables.
  data$Mo.Sold = as.factor(data$Mo.Sold)

  return(as_tibble(data))
}




