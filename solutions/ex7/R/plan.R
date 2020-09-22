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
    model_function(splited$train),
    transform = map(splited)
  ),
  
  # Performance
  test_predictions = target(
    predictNewData(model, splited$test) %>%
      mutate(id = id_chr()),
    transform = map(model, .id = c(model_function, standardize))
  ),
  
  test_predictions_combined = target(
    bind_rows(test_predictions),
    transform = combine(test_predictions)
  ),
  
  metrics = calculateMetrics(test_predictions, id),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)
