# EXERCISE 9
#
# TASK: Use dynamic branching to prepare separate model for each `day_type`
# - use `split()` inside data preprocessing to create separate subtarger for each day_type
# - in next target(s) use `dynamic = map(...)` for iteration over subtargets
# - HINT: In plan, change data to data[[1]]

source('R/packages.R')
source('R/functions.R')
source('R/config.R')
source('R/plan.R')

drake_config(plan, verbose = 2L)