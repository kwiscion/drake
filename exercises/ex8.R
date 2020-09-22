# EXERCISE 8
#
# TASK: Prepare separate functions for GAM and GLM and fit both to the data.
# - Create functions `fitGAM()` and `fitGLM()`
# - Put `model_functions <- rlang::syms(c("fitGLM", "fitGAM"))` in `config.R`
# - For target `model` substitute `map()` with `cross()` and add `model_functions` argument