library(readr)
library(tibble)
library(MASS)

read_dataset = function(datafile) {
  data = read_csv(datafile)
  data$`Total Bsmt SF`[is.na(data$`Total Bsmt SF`)] = 0
  data$`BsmtFin SF 1`[is.na(data$`BsmtFin SF 1`)] = 0 
  data$`Bsmt Qual`[is.na(data$`Bsmt Qual`)] = 0
  data$`Garage Area`[is.na(data$`Garage Area`)] = 0
  data$Alley[is.na(data$Alley)] = "None"
  data$Fence[is.na(data$Fence)] = "None"
  data$Utilities[is.na(data$Utilities)] = "None"
  data$`Pool QC`[is.na(data$`Pool QC`)] = "None"
  data$`Land Contour`[is.na(data$`Land Contour`)] = "None"
  
  data$`Lot Config`[is.na(data$`Lot Config`)] = "None"
  
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

qqplot = function(model, pcol="grey", lcol="dodgerblue", cex=1, title="Normal Q-Q Plot") {
  if( length(model$fitted.values) > 1000 ) {
    cex = cex*.5 # If there are a lot of points, make them smaller.
  }
  qqnorm(resid(model), col = pcol, cex = cex, main=title)
  qqline(resid(model), col = lcol, lwd = 2)
}

invBoxCox = function(x, lambda){
  if (lambda == 0) lol = exp(x) 
  else lol = (lambda*x + 1)^(1/lambda)
  return(lol)
}

boxCoxTransform = function(x, lambda) {
  return(if (lambda == 0) log(x) else ( (x**lambda) - 1) /lambda )
}

calculateBoxCoxLambda = function(model) {
  #bc = boxcox(model,lambda = seq(0, 8, by = 0.1))
  bc = boxcox(model,lambda = seq(0, 8, by = 0.1),plotit=T)
  alpha = bc$x[which.max(bc$y)]
  return(alpha)
}

