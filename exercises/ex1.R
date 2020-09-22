# EXERCISE 1
#
# TASK: Below is a "standard" messy analysis.
#       Please, clean it and rewrite so that every part of the analysis is done by a function.
#       Avoid mutating existing objects!

library(tidyverse)

# Read Traffic Volume dataset ---------------------------------------------
data <- read_csv('data/Metro_Interstate_Traffic_Volume.csv')

data %>%
  modify_if(is_character, as_factor) %>%
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
  select(day_type, temp, rain_1h, snow_1h, clouds_all, hour, traffic_volume)

data$day_type <- as.factor(data$day_type)

summary(data)

data <- data %>% filter(temp > 0)

data %>%
  sample_n(1000) %>%
  GGally::ggpairs()

data <- data %>% select(-snow_1h)


# Partition data ----------------------------------------------------------
partition_rate <- 0.7
tr_idx <- caret::createDataPartition(data$traffic_volume, p = partition_rate)$Resample1
data <- list(train = data[tr_idx,], test = data[-tr_idx,])


# Fit model ---------------------------------------------------------------
library(mgcv)

model <- gam(traffic_volume ~ s(hour) + day_type + temp + rain_1h + clouds_all, data = data$train)
summary(model)
plot(model, residuals = TRUE, pages = 1)


# Predict test set --------------------------------------------------------
test_predictions <- data$test %>%
  mutate(prediction = predict(model, .))


# Evaluate test set performance -------------------------------------------
metrics <- test_predictions %>%
  summarize(rmse = yardstick::rmse_vec(traffic_volume, prediction),
            r2 = yardstick::rsq_vec(traffic_volume, prediction)) %>%
  pivot_longer(c(rmse, r2), names_to = 'metric')
