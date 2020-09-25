# EXERCISE 8
#
# TASK: Play with `drake` a bit more
# 
# Set `map(gam_k = c(-1, 3, 5, 8, 10, 15))` and test `max_expand` argument of `drake_plan()`
# 
# Check what `build_times()` and `predict_runtime(plan)` do
# 
# Check what `drake_history()`
# Use some `hash` obtained from `drake_history()` to retrive targer from `drake_cache()`
# HINT: Use `drake_cache()$get_value()`
# 
# Try debuging one of the targets
# HINT: Use `drake_debug()`

plan <- drake_plan(
  # Data
  data_in = read.csv('data/Metro_Interstate_Traffic_Volume.csv'),
  data = preprocessData(data_in),
  
  # Model
  model = target(fitModel(data, gam_k = gam_k),
                 transform = map(gam_k = c(-1, 3, 5, 8, 10, 15))),
  
  #Performance
  test_predictions = target(predictNewData(model, data),
                            transform = map(model)),
  
  test_predictions_all = target(bind_rows(test_predictions),
                                combine(test_predictions)),
  
  max_expand = 2
)


build_times()
predict_runtime(plan)

drake_history()
drake_history() %>%
  filter(target == "data") %>%
  pull(hash) %>%
  head(n = 1) %>%
  {drake_cache()$get_value}()

drake_debug(data, plan)