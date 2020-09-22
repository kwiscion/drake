input_file <- 'data/Metro_Interstate_Traffic_Volume.csv'
partition_rate <- 0.7

standardize <- c(TRUE, FALSE)
model_functions <- rlang::syms(c("fitGLM", "fitGAM"))