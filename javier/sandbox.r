library(lmtest)
library(faraway)
library(MASS)
library(emmeans)

source("load_dataset.r")
source("transformations.r")
source("plots.r")

housing_data = read_dataset("../data/AmesHousing.csv")

splits = splitDataset(housing_data)
training_data = splits$train
test_data = splits$test


### Train a simple additive model with all predictors
model_add = lm(SalePrice ~ . , data=housing_data)
summary(model_add)


### Determine if Neighborhood is colinear or not.




### Search for the most significant predictors from a linear model
stepwise_search_init_formula = formula(SalePrice ~ .)
full = lm(stepwise_search_add_result_formula, data = housing_data)
model = step(full, direction = "both", trace = 2, k = log(n))


stepwise_search_add_result_formula = formula(SalePrice ~ (Lot.Area + Street + Neighborhood + Condition.1 + 
                                               Bldg.Type + Overall.Qual + Overall.Cond + Year.Built + Year.Remod.Add + 
                                               Exter.Qual + Bsmt.Qual + Bsmt.Exposure + BsmtFin.SF.1 + BsmtFin.SF.2 + 
                                               Bsmt.Unf.SF + X1st.Flr.SF + X2nd.Flr.SF + Low.Qual.Fin.SF + 
                                               Bsmt.Full.Bath + Bedroom.AbvGr + Kitchen.AbvGr + Kitchen.Qual + 
                                               Functional + Fireplaces + Garage.Finish + Garage.Cars + Garage.Area + 
                                               Screen.Porch + Sale.Condition)^2)

stepwise_search_result_formula = formula(SalePrice ~ Overall.Qual + X1st.Flr.SF + X2nd.Flr.SF + Neighborhood + 
                                           BsmtFin.SF.1 + Kitchen.Qual + Bldg.Type + Year.Built + Overall.Cond + 
                                           Sale.Condition + Lot.Area + Garage.Cars + Bsmt.Exposure + 
                                           Fireplaces + Screen.Porch + Bsmt.Full.Bath + Bsmt.Unf.SF + 
                                           BsmtFin.SF.2 + Bsmt.Qual + Low.Qual.Fin.SF + Condition.1 + 
                                           Year.Remod.Add + Overall.Qual:X1st.Flr.SF + Overall.Qual:Garage.Cars + 
                                           BsmtFin.SF.1:Year.Built + Overall.Qual:Sale.Condition + Overall.Qual:X2nd.Flr.SF + 
                                           Year.Built:Overall.Cond + X1st.Flr.SF:Kitchen.Qual + Overall.Qual:Bldg.Type + 
                                           X1st.Flr.SF:Overall.Cond + Overall.Qual:Bsmt.Full.Bath + 
                                           X1st.Flr.SF:Year.Built + BsmtFin.SF.1:Lot.Area + Bsmt.Full.Bath:Bsmt.Unf.SF + 
                                           X2nd.Flr.SF:Year.Remod.Add + Overall.Cond:Year.Remod.Add)

null = lm(SalePrice ~ 1, data=housing_data)
full = lm(stepwise_search_add_result_formula, data = housing_data)
model_add = lm(SalePrice ~ . , data=housing_data)
scope = list(lower=null,upper=full)
n = nrow(housing_data)
#model = step(full, direction = "both", trace = 2, k = log(n))
model = step(null, direction = "both",scope=scope, trace = 2, k = log(n))

model = lm(stepwise_search_result_formula, data=training_data)
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


with(housing_data, interaction.plot(Neighborhood, Gr.Liv.Area, SalePrice, lwd = 2, col=1:8))
with(housing_data, interaction.plot(Gr.Liv.Area, Neighborhood, SalePrice, lwd = 2, col=1:8))


interaction = aov(SalePrice ~  Neighborhood * Garage.Cars, data=housing_data)
summary(interaction)
(tukey = TukeyHSD(aov(SalePrice ~ Neighborhood * Garage.Cars, data = housing_data),which=c('Neighborhood:Garage.Cars'), ordered=T))
tukey$`Neighborhood:Bedroom.AbvGr`
?TukeyHSD
qplot(y = SalePrice, x = GrLivArea, col= Neighborhood, data=housing_data)


par(mfrow = c(1, 2))
with(warpbreaks, interaction.plot(wool, tension, breaks, lwd = 2, col = 2:4))
with(warpbreaks, interaction.plot(tension, wool, breaks, lwd = 2, col = 2:3))
