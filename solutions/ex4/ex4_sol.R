# EXERCISE 4
#
# TASK: Use plan from Exercise 2 and:
#       1. Add input file tracking to the plan
#       2. Add to the plan rendering of `report.Rmd` (Hint: Use `kintr_in()` and `file_out()`)
#       3. Test what happens to the plan after modification to input file or removal of rendered report (html)

library(drake)
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
plan <- drake_plan(
  # Data
  data_in = read_csv('data/Metro_Interstate_Traffic_Volume.csv'),
  data = preprocessData(data_in),
  
  # Model
  model = fitModel(data, gam_k = -1),
  
  #Performance
  test_predictions = predictNewData(model, data),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

make(plan)
