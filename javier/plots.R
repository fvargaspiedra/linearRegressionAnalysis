
qqplot = function(model, pcol="grey", lcol="dodgerblue", cex=1, title="Normal Q-Q Plot") {
  if( length(model$fitted.values) > 1000 ) {
    cex = cex*.5 # If there are a lot of points, make them smaller.
  }
  qqnorm(resid(model), col = pcol, cex = cex, main=title)
  qqline(resid(model), col = lcol, lwd = 2)
}
