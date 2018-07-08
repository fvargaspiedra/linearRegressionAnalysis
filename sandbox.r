library(readr)
library(tibble)

read_dataset = function(datafile) {
    responses = read_csv(datafile)
    ## hack to coerce all character columns from a tibble to factor
    responses = as.data.frame(unclass(as.data.frame(responses)))
    responses = as_tibble(responses)
}

#"data/responses.csv"
responses = read_dataset("data/houseprices.csv")
str(responses)
pairs(responses, col = "dodgerblue")

