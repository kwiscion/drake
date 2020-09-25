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

# Read Traffic Volume dataset ---------------------------------------------
data <- read.csv('data/Metro_Interstate_Traffic_Volume.csv')

data %>%
  modify_if(is_character, as.factor) %>%
  summary


# Preprocess data ---------------------------------------------------------
data <- data %>%
  mutate(date = as.Date(date_time),
         hour = lubridate::hour(date_time))

data %>%
  filter(holiday != 'None')

data <- data %>%
  group_by(date) %>%
  mutate(day_type = case_when(any(holiday != 'None') ~ 'Holiday',
                              lubridate::wday(date, week_start = 1) >= 6 ~ 'Weekend',
                              T  ~ 'Weekday')) %>%
  ungroup()

data <- data %>%
  select(day_type, temp, hour, traffic_volume)

data$day_type <- as.factor(data$day_type)

summary(data)

data <- data %>% filter(temp > 0)

# Fit model ---------------------------------------------------------------
library(mgcv)

model <- gam(traffic_volume ~ s(hour, k = -1) + day_type + temp, data = data)

# Predict test set --------------------------------------------------------
test_predictions <- data %>%
  mutate(prediction = predict(model, .))

