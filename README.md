Students names
--------------

-   Hari Manan (NetID: nfnh2)
-   Javier Matias (NetID: javierm4)
-   Francisco Vargas (NetID: fav3)

Title
-----

Iowa house price prediction using regression analysis

Dataset description
-------------------

The Ames Housing Dataset describes the sale of Ames, Iowa housing properties from 2006 to 2010. It is composed by 80 explanatory variables (23 nominal, 23 ordinal, 14 discrete, and 20 continuous) describing many elements of thos houses that can potentially help to predict the house price. It also has 1460 observations that include the real price of the house which is the response we would like to work with.

The observations are not limited to objective measurements like area or size, but also subjective measurements like rates of overall conditions.

The predictors can be generally divided into 5 categories:

-   Sale characteristics
-   Space measurements
-   Quality ratings
-   Constructive characteristics and materials
-   Zone and location classification

The following link has a description of each of the predictors: <https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data>

The dataset complies with all the requirements for the final project on STAT-420.

Background
----------

This dataset was put together by Dean De Cock to be openly used on Data Science education. It was an effort towards upgrading a famous dataset about Boston Housing. The main purpose was to expand the amount of variables provided on the Boston Housing dataset so researchers could implement more complex methodologies and techniques.

The link to the original paper can be found here: <https://ww2.amstat.org/publications/jse/v19n3/decock.pdf>

The dataset is also openly available here: <https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data>

Motivation
----------

-   Simplicity
-   Cleanness
-   Many variables available to test various methods.
-   We can take what we learned from here and apply it to more specific tasks with less amount of variables of data available.

-   Add questions here as well and how we are planning to answer them (which methods. This like an hypothesis)

Load proof
----------

``` r
library(readr)

data = read_csv("data/houseprices.csv")
head(data$SalePrice)
```

    ## [1] 208500 181500 223500 140000 250000 143000

``` r
data
```

    ## # A tibble: 1,460 x 81
    ##       Id MSSubClass MSZoning LotFrontage LotArea Street Alley LotShape
    ##    <int>      <int> <chr>          <int>   <int> <chr>  <chr> <chr>   
    ##  1     1         60 RL                65    8450 Pave   <NA>  Reg     
    ##  2     2         20 RL                80    9600 Pave   <NA>  Reg     
    ##  3     3         60 RL                68   11250 Pave   <NA>  IR1     
    ##  4     4         70 RL                60    9550 Pave   <NA>  IR1     
    ##  5     5         60 RL                84   14260 Pave   <NA>  IR1     
    ##  6     6         50 RL                85   14115 Pave   <NA>  IR1     
    ##  7     7         20 RL                75   10084 Pave   <NA>  Reg     
    ##  8     8         60 RL                NA   10382 Pave   <NA>  IR1     
    ##  9     9         50 RM                51    6120 Pave   <NA>  Reg     
    ## 10    10        190 RL                50    7420 Pave   <NA>  Reg     
    ## # ... with 1,450 more rows, and 73 more variables: LandContour <chr>,
    ## #   Utilities <chr>, LotConfig <chr>, LandSlope <chr>, Neighborhood <chr>,
    ## #   Condition1 <chr>, Condition2 <chr>, BldgType <chr>, HouseStyle <chr>,
    ## #   OverallQual <int>, OverallCond <int>, YearBuilt <int>,
    ## #   YearRemodAdd <int>, RoofStyle <chr>, RoofMatl <chr>,
    ## #   Exterior1st <chr>, Exterior2nd <chr>, MasVnrType <chr>,
    ## #   MasVnrArea <int>, ExterQual <chr>, ExterCond <chr>, Foundation <chr>,
    ## #   BsmtQual <chr>, BsmtCond <chr>, BsmtExposure <chr>,
    ## #   BsmtFinType1 <chr>, BsmtFinSF1 <int>, BsmtFinType2 <chr>,
    ## #   BsmtFinSF2 <int>, BsmtUnfSF <int>, TotalBsmtSF <int>, Heating <chr>,
    ## #   HeatingQC <chr>, CentralAir <chr>, Electrical <chr>, `1stFlrSF` <int>,
    ## #   `2ndFlrSF` <int>, LowQualFinSF <int>, GrLivArea <int>,
    ## #   BsmtFullBath <int>, BsmtHalfBath <int>, FullBath <int>,
    ## #   HalfBath <int>, BedroomAbvGr <int>, KitchenAbvGr <int>,
    ## #   KitchenQual <chr>, TotRmsAbvGrd <int>, Functional <chr>,
    ## #   Fireplaces <int>, FireplaceQu <chr>, GarageType <chr>,
    ## #   GarageYrBlt <int>, GarageFinish <chr>, GarageCars <int>,
    ## #   GarageArea <int>, GarageQual <chr>, GarageCond <chr>,
    ## #   PavedDrive <chr>, WoodDeckSF <int>, OpenPorchSF <int>,
    ## #   EnclosedPorch <int>, `3SsnPorch` <int>, ScreenPorch <int>,
    ## #   PoolArea <int>, PoolQC <chr>, Fence <chr>, MiscFeature <chr>,
    ## #   MiscVal <int>, MoSold <int>, YrSold <int>, SaleType <chr>,
    ## #   SaleCondition <chr>, SalePrice <int>

References
----------

1.  De Cock, Dean. (2011). Ames, Iowa: Alternative to the Boston Housing Data as an End of Semester Regression Project. Journal of Statistics Education.
