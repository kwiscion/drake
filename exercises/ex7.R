# EXERCISE 7
#
# TASK: Combine test set predictions for standardized and unstandardized data into single data.frame. 
# - Add colmnt with target name to `test_predictions` data.frame. (Hint: use `id_chr()` to get name of current target).
# - Use `.id` argument of `map()` to simplify target names.
# - Use `target(bind_rows(test_predictions), transform = combine(test_predictions))` to create a single target.
# - Modify metrics calculation to use grouping variable and newly created combined target.
# - Uncomment the report.
# - Move `standardize = c(TRUE, FALSE)` from `plan.R` to `config.R` (Hint: remember to use `!!` in `plan.R`)