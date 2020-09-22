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

preprocessData <- function(data, standardize = FALSE) {
  tmp <- data %>%
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
  
  if(standardize) tmp[2:5] <- scale(tmp[2:5])
  
  tmp
}

splitData <- function(data, p) {
  tr_idx <- caret::createDataPartition(data$traffic_volume, p = p)$Resample1
  list(train = data[tr_idx,], test = data[-tr_idx,])
}

fitGLM <- function(data) {
  glm(traffic_volume ~ hour + day_type + temp + rain_1h + clouds_all, data = data)
}

fitGAM <- function(data) {
  gam(traffic_volume ~ s(hour) + day_type + temp + rain_1h + clouds_all, data = data)
}

fitGAM2 <- function(data) {
  gam(traffic_volume ~ s(hour) + temp + rain_1h + clouds_all, data = data)
}


predictNewData <- function(model, newdata) {
  newdata %>%
    mutate(prediction = predict(model, .))
}

calculateMetrics <- function(data, ...) {
  data %>%
    group_by(...) %>%
    summarize(rmse = yardstick::rmse_vec(traffic_volume, prediction),
              r2 = yardstick::rsq_vec(traffic_volume, prediction)) %>%
    pivot_longer(c(rmse, r2), names_to = 'metric')
}


# Analysis ----------------------------------------------------------------

standardize <- c(TRUE, FALSE)
model_functions <- rlang::syms(c("fitGLM", "fitGAM"))

plan <- drake_plan(
  # Data
  data_in = read_csv(file_in('data/Metro_Interstate_Traffic_Volume.csv')),
  data = target(
    preprocessData(data_in),
    transform = map(standardize = !! standardize)
  ),
  
  # Model
  splited = target(
    splitData(data, p = 0.7),
    transform = map(data)
  ),
  
  model = target(
    model_function(splited$train),
    transform = cross(splited, model_function = !! model_functions)
  ),
  
  # Performance
  test_predictions_int = target(
    predictNewData(model, splited$test) %>%
      mutate(id = id_chr()),
    transform = map(model, .id = c(model_function, standardize))
  ),

  test_predictions = target(
    bind_rows(test_predictions_int),
    combine(test_predictions_int)
    ),

  metrics = calculateMetrics(test_predictions, id),

  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

make(plan)
