# EXERCISE 3
#
# TASK: Use plan from Exercise 2 and play with it for a while.
# 
# Run `make(plan)` again. Have you noticed any difference?
# 
# Execute `clean()` and run `make(plan)` once again. What happened now?
# 
# Try functions `readd()` and `loadd()` (you need to provide a target(s) name!). What is the difference?
# 
# Visualize dependency graph (`vis_drake_graph(plan)`) and play with it.
# How do the graph change after you clean one of the targets? And after you run `make(plan, 'model')`?
# 
# Remove one of terms from GAM model (make sure to source the function!).
# What was the impact on plan? Check `vis_drake_graph(plan)` and `outdated(plan)`.
# 
# Edit input file by hand. What happened?

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
  test_predictions = predictNewData(model, data)
)

make(plan)

make(plan)
clean()
make(plan)

readd(data)
loadd(data)

vis_drake_graph(plan)

clean(data)
vis_drake_graph(plan)

make(plan, 'model')
vis_drake_graph(plan)
outdated(plan)
