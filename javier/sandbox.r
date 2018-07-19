library(readr)
library(tibble)
library(ggplot2)
library(GGally)
library(lmtest)
library(faraway)
library(MASS)

source("load_dataset.r")

interesting_cols = c('MS.Zoning','Lot.Area','Overall.Qual','Overall.Cond','SalePrice','Year.Built',
                     'Mo.Sold','Yr.Sold','Neighborhood','Gr.Liv.Area','MS.SubClass',
                     'Condition.1','Condition.2','Roof.Style','Roof.Matl','Exterior.1st','Exterior.2nd',
                     'Mas.Vnr.Type','Mas.Vnr.Area','Exter.Qual','Exter.Cond','Foundation','Bsmt.Qual','Bsmt.Cond',
                     'Bsmt.Exposure','BsmtFin.Type.1','BsmtFin.Type.2','BsmtFin.SF.1','BsmtFin.SF.2','Total.Bsmt.SF','Bsmt.Unf.SF',
                     'Heating', 'Heating.QC','Central.Air','Bedroom.AbvGr','Bldg.Type',
                     'Bsmt.Full.Bath','Bsmt.Half.Bath','Lot.Frontage','Electrical','X1st.Flr.SF','X2nd.Flr.SF','Kitchen.AbvGr',
                     'Kitchen.Qual','Street','Alley','Lot.Shape','House.Style','Year.Remod.Add',
                     'TotRms.AbvGrd','Functional','Fireplaces','Fireplace.Qu','Garage.Type',
                     'Garage.Yr.Blt','Garage.Finish','Garage.Cars','Garage.Area','Garage.Qual',
                     'Garage.Cond','Paved.Drive','Wood.Deck.SF','Open.Porch.SF','Enclosed.Porch',
                     'X3Ssn.Porch','Screen.Porch','Pool.Area','Pool.QC','Fence','Misc.Val',
                     'Land.Contour','Lot.Config','Land.Slope','Sale.Type','Sale.Condition')

#interesting_cols = c('Gr.Liv.Area', 'SalePrice','Bedroom.AbvGr')

housing_data = read_dataset("../data/AmesHousing.csv")
housing_data = housing_data[,interesting_cols]
dim(housing_data)
#housing_data$Bedroom.AbvGr = as.factor(housing_data$Bedroom.AbvGr)

null = lm(SalePrice ~ 1, data=housing_data)
model = lm(SalePrice ~ ., data = housing_data, na.action = na.exclude)
scope = list(lower=null,upper=model)
n = nrow(housing_data)
mod_a = step(null, direction = "forward",scope=scope, trace = 2, k = log(n))
(lambda = calculateBoxCoxLambda(model))
housing_data$SalePrice = boxCoxTransform(housing_data$SalePrice,lambda)
model = lm(SalePrice ~ ., data = housing_data)
hist(housing_data$SalePrice)
#factors = housing_data[,which(sapply(housing_data, is.factor))]
#sapply(factors, is.na )


#bptest(model)
shapiro.test(resid(model))$p.value

par(mfrow=c(1,1))
qqplot(model)
par(mfrow=c(1,2))
plot(model, pch=20, cex=.5)
summary(model)
plot(model)
highly_influential_observations = cooks.distance(model) > 4 / length(cooks.distance(model))
unname(which(highly_influential_observations))
housing_data = housing_data[-which(highly_influential_observations),]
dim(housing_data)
without_neighborhood  = lm(SalePrice ~ . - Bedroom.AbvGr , data=housing_data)
neighborhood_col      = glm(Bedroom.AbvGr ~ . - SalePrice, data=housing_data)
cor(resid(without_neighborhood),resid(neighborhood_col))


anova(lm(SalePrice~Neighborhood+Bedroom.AbvGr,data=housing_data),
      lm(SalePrice ~ Neighborhood * Bedroom.AbvGr, data = housing_data))

par(mfrow=c(1,1))
boxplot(SalePrice ~ Neighborhood, data = housing_data,las=2,
        col=2:8, pch=20, cex=.7)


(pairwise = with(housing_data, pairwise.t.test(SalePrice, Neighborhood, p.adj = "bonferroni")))
table(housing_data$Fireplace.Qu)
#table(housing_data$Bedroom.AbvGr[!is.na(housing_data$SalePrice)])
#View(housing_data[housing_data$Bedroom.AbvGr==0,c('Bedroom.AbvGr','Bldg.Type','Bsmt.Half.Bath','Bsmt.Full.Bath','SalePrice')])

m<-as.table(pairwise$p.value)
write.csv(m, file = "MyData.csv")

par(mfrow = c(1, 2))
with(housing_data, interaction.plot(Neighborhood, Bedroom.AbvGr, SalePrice, lwd = 2, col=1:8))
with(housing_data, interaction.plot(Bedroom.AbvGr, Neighborhood, SalePrice, lwd = 2, col=1:8))


interaction = aov(SalePrice ~ . + Neighborhood : Bedroom.AbvGr, data=housing_data)
summary(interaction)
(tukey = TukeyHSD(aov(SalePrice ~ Neighborhood * Bedroom.AbvGr, data = housing_data),which=c('Neighborhood:Bedroom.AbvGr'), ordered=T))
tukey$`Neighborhood:Bedroom.AbvGr`
?TukeyHSD
qplot(y = SalePrice, x = GrLivArea, col= Neighborhood, data=housing_data)


par(mfrow = c(1, 2))
with(warpbreaks, interaction.plot(wool, tension, breaks, lwd = 2, col = 2:4))
with(warpbreaks, interaction.plot(tension, wool, breaks, lwd = 2, col = 2:3))


