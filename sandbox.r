library(readr)
library(tibble)

read_dataset = function() {
    responses = read_csv("data/responses.csv")
    ## hack to coerce all character columns from a tibble to factor
    responses = as.data.frame(unclass(as.data.frame(responses)))
    responses = as_tibble(responses)
}

responses = read_dataset()

