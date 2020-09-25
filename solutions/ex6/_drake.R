##################################
# MOVE TO MAIN PROJECT DIRECTORY #
##################################

# EXERCISE 6
#
# TASK: Test few `gam_k` parameter values
# use `map()` to parametrize targets affected
# comment out report rendering
# 
# BONUS TASK: Try modifying the report (both `report.Rmd` and rendering function)
# to make it work with branching (HINT: `id_chr()` gives current target name)

source('R/packages.R')
source('R/functions.R')
source('R/config.R')
source('R/plan.R')

drake_config(plan, verbose = 2L)