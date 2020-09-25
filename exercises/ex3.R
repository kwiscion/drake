# EXERCISE 3
#
# TASK: Use plan from Exercise 2 and play with it for a while.
# 
# Run `make(plan)` again. Have you noticed any difference?
# 
# Execute `clean()` and run `make(plan)` once again. What happened now?
# 
# Try functions `readd()` and `loadd()` (you need to provide a target(s) name!). What is the difference?
# 
# Visualize dependency graph (`vis_drake_graph(plan)`) and play with it.
# How do the graph change after you clean one of the targets? And after you run `make(plan, 'model')`?
# 
# Remove one of terms from GAM model (make sure to source the function!).
# What was the impact on plan? Check `vis_drake_graph(plan)` and `outdated(plan)`.
# 
# Edit input file by hand. What happened?