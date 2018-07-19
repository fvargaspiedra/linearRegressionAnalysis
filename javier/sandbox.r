library(lmtest)
library(faraway)
library(MASS)

source("load_dataset.r")
source("transformations.r")
source("plots.r")

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
                     'Land.Contour','Lot.Config','Land.Slope','Sale.Type','Sale.Condition','Low.Qual.Fin.SF')

housing_data = read_dataset("../data/AmesHousing.csv")
housing_data = housing_data[,interesting_cols]
dim(housing_data)

trn_idx  = sample(nrow(housing_data), size = trunc(0.80 * nrow(housing_data)))
trn_data = housing_data[trn_idx, ]
tst_data = housing_data[-trn_idx, ]

stepwise_search_init_formula = formula(SalePrice ~ (Overall.Qual + Gr.Liv.Area + Neighborhood + 
                                                      BsmtFin.SF.1 + MS.SubClass + Kitchen.Qual + Bsmt.Exposure + 
                                                      Year.Built + Overall.Cond + Garage.Cars + Sale.Condition + 
                                                      Total.Bsmt.SF + Bsmt.Qual + Lot.Area + Fireplaces + Exter.Qual + 
                                                      Bedroom.AbvGr + Functional + BsmtFin.SF.2 + Garage.Yr.Blt + 
                                                      Screen.Porch + Year.Remod.Add + Condition.1 + Bsmt.Full.Bath + 
                                                      Street + Garage.Area + Low.Qual.Fin.SF)^2)

stepwise_search_result_formula = formula(SalePrice ~ Overall.Qual + Gr.Liv.Area + Neighborhood + BsmtFin.SF.1 + 
                                           MS.SubClass + Kitchen.Qual + Bsmt.Exposure + Year.Built + 
                                           Overall.Cond + Garage.Cars + Sale.Condition + Total.Bsmt.SF + 
                                           Lot.Area + Fireplaces + Screen.Porch + Bsmt.Full.Bath + BsmtFin.SF.2 + 
                                           Functional + Year.Remod.Add + Bedroom.AbvGr + Condition.1 + 
                                           Exter.Qual + BsmtFin.SF.1:Year.Built + Gr.Liv.Area:Sale.Condition + 
                                           Overall.Qual:Total.Bsmt.SF + Overall.Qual:Garage.Cars + Gr.Liv.Area:Kitchen.Qual + 
                                           Year.Built:Overall.Cond + Overall.Cond:Fireplaces + Gr.Liv.Area:Lot.Area + 
                                           Overall.Qual:Lot.Area + Total.Bsmt.SF:Year.Remod.Add + Overall.Qual:Bsmt.Full.Bath + 
                                           BsmtFin.SF.1:Bedroom.AbvGr + BsmtFin.SF.1:Lot.Area + Overall.Qual:Exter.Qual + 
                                           BsmtFin.SF.1:Bsmt.Full.Bath)

#null = lm(SalePrice ~ 1, data=housing_data)
#full = lm(stepwise_search_init_formula, data = housing_data)
model_add = lm(SalePrice ~ . , data=housing_data)
scope = list(lower=null,upper=full)
n = nrow(housing_data)
#model = step(full, direction = "both", trace = 2, k = log(n))
#model = step(null, direction = "both",scope=scope, trace = 2, k = log(n))

model = lm(stepwise_search_result_formula, data=trn_data)
sqrt(sum((trn_data$SalePrice - predict(model))^2) / (df.residual(model)))
summary(model)

(lambda = calculateBoxCoxLambda(model))
housing_data$SalePrice = boxCoxTransform(housing_data$SalePrice,lambda)
hist(trn_data$SalePrice, breaks=20)

trn_data = housing_data[trn_idx, ]
tst_data = housing_data[-trn_idx, ]

model = lm(stepwise_search_result_formula, data=trn_data)

summary(model)
sqrt(sum((invBoxCox(trn_data$SalePrice,lambda) - invBoxCox(predict(model),lambda))^2) / (df.residual(model)))
sqrt(sum((invBoxCox(tst_data$SalePrice,lambda) - invBoxCox(predict(model,newdata=tst_data),lambda))^2) / (df.residual(model)))

bptest(model)$p.value
shapiro.test(resid(model))$p.value
length(coef(model))

summary(housing_data) 


highly_influential_observations = cooks.distance(model) > 4 / length(cooks.distance(model))
unname(which(highly_influential_observations))
trn_data = trn_data[-which(highly_influential_observations),]
dim(housing_data)



par(mfrow=c(1,1))
qqplot(model)
par(mfrow=c(1,2))
plot(model, pch=20, cex=.5)
par(mfrow=c(1,1))


without_neighborhood  = lm(SalePrice ~ . - Garage.Area , data=housing_data)
neighborhood_col      = lm(Garage.Area~ . - SalePrice, data=housing_data)
cor(resid(without_neighborhood),resid(neighborhood_col))


anova(lm(SalePrice~Neighborhood+Bedroom.AbvGr,data=housing_data),
      lm(SalePrice ~ Neighborhood * Bedroom.AbvGr, data = housing_data))

par(mfrow=c(1,1))
boxplot(SalePrice ~ Neighborhood, data = housing_data,las=2,
        col=2:8, pch=20, cex=.7)


(pairwise = with(housing_data, pairwise.t.test(SalePrice, Neighborhood, p.adj = "bonferroni")))



m<-as.table(pairwise$p.value)
write.csv(m, file = "MyData.csv")

par(mfrow = c(1, 2))
with(housing_data, interaction.plot(Neighborhood, Bedroom.AbvGr, SalePrice, lwd = 2, col=1:8))
with(housing_data, interaction.plot(Bedroom.AbvGr, Neighborhood, SalePrice, lwd = 2, col=1:8))


par(mfrow = c(1, 2))
with(housing_data, interaction.plot(Neighborhood, Bedroom.AbvGr, SalePrice, lwd = 2, col=1:8))
with(housing_data, interaction.plot(Bedroom.AbvGr, Neighborhood, SalePrice, lwd = 2, col=1:8))
table(housing_data$Pool.QC)

with(housing_data, interaction.plot(Neighborhood, Garage.Cars, SalePrice, lwd = 2, col=1:8))
with(housing_data, interaction.plot(Garage.Cars, Neighborhood, SalePrice, lwd = 2, col=1:8))
table(housing_data$Garage.Type)

interaction = aov(SalePrice ~  Neighborhood * Garage.Cars, data=housing_data)
summary(interaction)
(tukey = TukeyHSD(aov(SalePrice ~ Neighborhood * Garage.Cars, data = housing_data),which=c('Neighborhood:Garage.Cars'), ordered=T))
tukey$`Neighborhood:Bedroom.AbvGr`
?TukeyHSD
qplot(y = SalePrice, x = GrLivArea, col= Neighborhood, data=housing_data)


par(mfrow = c(1, 2))
with(warpbreaks, interaction.plot(wool, tension, breaks, lwd = 2, col = 2:4))
with(warpbreaks, interaction.plot(tension, wool, breaks, lwd = 2, col = 2:3))


