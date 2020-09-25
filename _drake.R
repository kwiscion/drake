library(tidyverse)
library(drake)

plan <- drake_plan(
  
  data_scaled = data %>% modify_if(is.numeric, scale),
  
  km = target(kmeans(data_scaled[1:4], centers = centers_),
              transform = map(centers_ = c(3, 4, 5), 
                              fun = list(data.frame(a = 10), list(), iris),
                              .id = centers_)),
  
  data_cluster = target(cbind(data, km$cluster),
                        transform = map(km)),
  
  data = iris,
  
)

# make(plan)
drake_config(plan, verbose = 2L)


build_times() %>% View
predict_runtime(plan)

drake_history()

drake_debug(km_3, plan)
