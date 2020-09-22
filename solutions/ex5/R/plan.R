plan <- drake_plan(
  # Data
  data_in = read_csv(file_in(!! input_file)),
  data = preprocessData(data_in),
  
  # Model
  splited = splitData(data, p = partition_rate),
  model = fitModel(splited$train),
  
  # Performance
  test_predictions = predictNewData(model, splited$test),
  metrics = calculateMetrics(test_predictions),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)
