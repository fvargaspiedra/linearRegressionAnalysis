Students names
--------------

-   Hari Manan (NetID: nfnh2)
-   Javier Matias (NetID: javierm4)
-   Francisco Vargas (NetID: fav3)

Title
-----

Prediction of house prices in Ames, Iowa by using regression analysis techniques

Dataset description
-------------------

The Ames Housing dataset describes the sale of Ames, Iowa housing properties from 2006 to 2010. It is composed by 80 explanatory variables (23 nominal/categorical, 23 ordinal, 14 discrete, and 20 continuous) describing 1460 houses that can potentially help to predict the house price. Each of those 1460 observations include the real price of the house which is the response we would like to predict.

The observations are not limited to objective measurements like area or size, but also subjective measurements like rates of overall conditions.

The predictors can be generally divided into 5 categories. We are including some relevant examples on each category:

- **Sale characteristics**: Bedroom (number of bedrooms above basement level)
- **Space measurements**: LotArea (lot size in square feet)
- **Quality ratings**: OverallCond (overall condition rating)
- **Constructive characteristics and materials**: RoofMatl (roof material)
- **Zone and location classification**: MSZoning (the general zoning classification)

The following link has a description of each of the predictors: <https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data>

The dataset complies with all the requirements for the final project on STAT-420.

Background
----------

This dataset was put together by Dean De Cock to be openly used on Data Science education and research. It was an effort towards upgrading a famous dataset about Boston Housing. The main purpose was to expand the number of variables provided on the Boston Housing dataset, so researchers could implement more complex methodologies and techniques.

The link to the original paper can be found here: <https://ww2.amstat.org/publications/jse/v19n3/decock.pdf>

The dataset is also openly available here: <https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data>

Motivation
----------

The main goal of this project is trying to find a simple model (by not using all the predictors but finding the most relevant) that allows to predict the price of a house with the smallest prediction interval possible for an acceptable confidence level.

There are several reasons why the workgroup decided to use this dataset for the final project. Most of them are related to research and personal motivations and are enumerated below:

1. **Model simplicity challenge**: this dataset has many explanatory variables on every category studied on this course. Just as stated in the course book: "As a model gets more predictors, errors will get smaller and its prediction will be better, but it will be harder to interpret. This is why, if we are interested in explaining the relationship between the predictors and the response, we often want a model that fits well, but with a small number of predictors with little correlation." In other words, besides focusing on predicting the price of a house in Ames, Iowa, which is our main goal, we would like to challenge ourselves to do it with only those predictors that really matter and try to obtain a model where the relationship between the predictors are not extremely hard to explain. This is of our personal interest because the process followed can be re-used on any other real use case.
2. **Cleanness**: from a research perspective, the proposed dataset doesn't seem to have many null or blank values. This will allow us to spend more time on research by implementing different methodologies and executing a deeper analysis, which is the core theme of this course.
3. **Questions**: from a personal interest perspective, this dataset is related to a frequent activity: buying a house. This activity is so well-known that allows us to formulate some interesting questions we would love to answer through the completion of this project. We are also listing possible techniques we can apply to answer them:
    - **How effectively can we predict the price of a house given a set of explanatory variables?** A test/training set evaluation process can help us to measure the accuracy under acceptable error ranges.
    - **Can we identify outliers that might be affecting the model?** Techniques like high-leverage, larger residuals, and hat matrices will be useful.
    - **Are interactions models required to better predict the price of the houses?** Experimenting with dummy variables and interaction models is necessary to answer the question.
    - **What are the most influential predictors?** Hypothesis tests might be the best path in this case.
    - **Can we obtain a small model with a decent accuracy and easy to explain relationship between explanatory variables?** ANOVA analysis will be relevant for this question.
    - **Are transformations necessary to improve the accuracy of the model?** Transformation techniques and assumption tests might lead us to the answer.

The questions and motivations exposed are not limited to this proposal. During the execution of the project some of them can change or a new set can appear. Our goal is to try to answer as much as we can.

Load proof
----------

``` r
library(readr)

housing_data = read_csv("data/houseprices.csv")
head(housing_data$SalePrice, 10)
```

    ##  [1] 208500 181500 223500 140000 250000 143000 307000 200000 129900 118000

References
----------

1. De Cock, Dean. (2011). *Ames, Iowa: Alternative to the Boston Housing Data as an End of Semester Regression Project*. Journal of Statistics Education.
2. *House Prices: Advanced Regression Techniques*. Obtained on July 9th, 2018, from: https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data
3. Dalpiaz, D. (2018). *Applied Statistics with R*. Obtained on July 9th, 2018, from: https://daviddalpiaz.github.io/appliedstats/
