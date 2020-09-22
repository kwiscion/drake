plan <- drake_plan(
  # Data
  data_in = read_csv(file_in(!! input_file)),
  data = target(
    preprocessData(data_in) %>% split(.$day_type)
  ),
  
  # Model
  splited = target(
    splitData(data[[1]], p = partition_rate),
    dynamic = map(data)
  ),
  
  model = target(
    fitGAM2(splited$train),
    dynamic = map(splited)
  ),
  
  # Performance
  test_predictions = target(
    predictNewData(model, splited$test),
    dynamic = map(model)
  ),
  
  metrics = calculateMetrics(test_predictions),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

