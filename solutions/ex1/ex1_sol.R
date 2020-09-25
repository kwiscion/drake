# EXERCISE 1
#
# TASK: 
# Below is a "standard" messy analysis.
# Please, clean it and rewrite so that every part of the analysis is done by a function.
# Keep this values as function parameters:
# input_file <- 'data/Metro_Interstate_Traffic_Volume.csv'
# gam_k <- -1

library(dplyr)
library(purrr)
library(mgcv)

# Functions ---------------------------------------------------------------

preprocessData <- function(data) {
  data %>%
    filter(temp > 0) %>%
    mutate(date = as.Date(date_time),
           hour = lubridate::hour(date_time)) %>%
    group_by(date) %>%
    mutate(day_type = case_when(any(holiday != 'None') ~ 'Holiday',
                                lubridate::wday(date, week_start = 1) >= 6 ~ 'Weekend',
                                T  ~ 'Weekday')) %>%
    ungroup() %>%
    mutate(day_type = as.factor(day_type)) %>%
    select(day_type, temp, hour, traffic_volume)
}

fitModel <- function(data, gam_k) {
  gam(traffic_volume ~ s(hour, k = gam_k) + day_type + temp, data = data)
}

predictNewData <- function(model, newdata) {
  newdata %>%
    mutate(prediction = predict(model, .))
}


# Analysis ----------------------------------------------------------------
# Data
data_in <- read.csv('data/Metro_Interstate_Traffic_Volume.csv')
data <- preprocessData(data_in)

# Model
model <- fitModel(data, gam_k = -1)

#Performance
test_predictions <- predictNewData(model, data)
