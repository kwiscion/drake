library(tidyverse)
library(drake)

plan <- drake_plan(
  
  data_scaled = data %>% modify_if(is.numeric, scale),
  
  km = kmeans(data_scaled[1:4], centers = 3),
  
  data_cluster = cbind(data, km$cluster),
  
  data = iris,
  
)

