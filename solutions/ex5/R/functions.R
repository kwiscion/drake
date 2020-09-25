
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