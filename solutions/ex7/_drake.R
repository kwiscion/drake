##################################
# MOVE TO MAIN PROJECT DIRECTORY #
##################################

# EXERCISE 7
#
# TASK: Combine test set predictions targets into a single target
# HINT: use `bind_rows()`

source('R/packages.R')
source('R/functions.R')
source('R/config.R')
source('R/plan.R')

drake_config(plan, verbose = 2L)