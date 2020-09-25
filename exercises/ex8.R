# EXERCISE 8
#
# TASK: Play with `drake` a bit more
# 
# Set `map(gam_k = c(-1, 3, 5, 8, 10, 15))` and test `max_expand` argument of `drake_plan()`
# 
# Check what `build_times()` and `predict_runtime(plan)` do
# 
# Check what `drake_history()` does
# Use some `hash` obtained from `drake_history()` to retrive targer from `drake_cache()`
# HINT: Use `drake_cache()$get_value()`
# 
# Try debuging one of the targets
# HINT: Use `drake_debug()`