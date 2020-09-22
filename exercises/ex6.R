# EXERCISE 6
#
# TASK: Run your pipeline with and without standarization of numeric predictors. 
# - Add `standardize = c(TRUE, FALSE)` argument to preprocessing function and implement the functionality. (Hint: use `scale()`).
# - Put command that creates `data` target inside `target(..., map(standatdize = c(TRUE, FALSE)))` function.
# - Comment out rest of the targets and test if the plan works.
# - Uncomment rest of the plan* and add `target(..., map(...))` to each target (Hint: substitute dots inside map with upstream target name)
# - * Keep report commented out. We will deal with it in a moment.
# - Visualize dependency graph.