library(MASS)

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

get_loocv_rmse = function(model) {
  sqrt(mean((resid(model) / (1 - hatvalues(model))) ^ 2))
}