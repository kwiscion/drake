##################################
# MOVE TO MAIN PROJECT DIRECTORY #
##################################

# EXERCISE 5
#
# TASK: Change code from exercises 1-4 into four files:
# - _drake.R
# - R/packages.R
# - R/functions.R
# - R/config.R
# - R/plan.R
# Test `r_make()` and other `r_*()` functions.


source('R/packages.R')
source('R/functions.R')
source('R/config.R')
source('R/plan.R')

drake_config(plan, verbose = 2L)