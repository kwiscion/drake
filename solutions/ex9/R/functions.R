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
