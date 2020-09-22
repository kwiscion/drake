plan <- drake_plan(
  # Data
  data_in = read_csv(file_in(!! input_file)),
  data = target(
    preprocessData(data_in, standardize),
    transform = map(standardize = c(TRUE, FALSE))
  ),
  
  # Model
  splited = target(
    splitData(data, p = partition_rate),
    transform = map(data)
  ),
  
  model = target(
    fitModel(splited$train),
    transform = map(splited)
  ),
  
  # Performance
  test_predictions = target(
    predictNewData(model, splited$test),
    transform = map(model)
  ),
  
  metrics = target(
    calculateMetrics(test_predictions),
    transform = map(test_predictions)
  ),
  
  # Report
  # report = rmarkdown::render(
  #   knitr_in("report.Rmd"),
  #   output_file = file_out("report.html"),
  #   quiet = TRUE
  # )
)
