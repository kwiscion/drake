# EXERCISE 4
#
# TASK: Use plan from Exercise 2 and:
#       1. Add input file tracking to the plan
#       2. Add to the plan rendering of `report.Rmd` (Hint: Use `kintr_in()` and `file_out()`)
#       3. Test what happens to the plan after modification to input file or removal of rendered report (html)

library(drake)
library(tidyverse)
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
    mutate(day_type == as.factor(day_type)) %>%
    select(day_type, temp, rain_1h, clouds_all, hour, traffic_volume)
}

splitData <- function(data, p) {
  tr_idx <- caret::createDataPartition(data$traffic_volume, p = p)$Resample1
  list(train = data[tr_idx,], test = data[-tr_idx,])
}

fitModel <- function(data) {
  gam(traffic_volume ~ s(hour) + day_type + temp + rain_1h + clouds_all, data = data)
}

predictNewData <- function(model, newdata) {
  newdata %>%
    mutate(prediction = predict(model, .))
}

calculateMetrics <- function(data) {
  data %>%
    summarize(rmse = yardstick::rmse_vec(traffic_volume, prediction),
              r2 = yardstick::rsq_vec(traffic_volume, prediction)) %>%
    pivot_longer(c(rmse, r2), names_to = 'metric')
}


# Analysis ----------------------------------------------------------------

plan <- drake_plan(
  # Data
  data_in = read_csv(file_in('data/Metro_Interstate_Traffic_Volume.csv')),
  data = preprocessData(data_in),
  
  # Model
  splited = splitData(data, p = 0.7),
  model = fitModel(splited$train),
  
  # Performance
  test_predictions = predictNewData(model, splited$test),
  metrics = calculateMetrics(test_predictions),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

make(plan)
