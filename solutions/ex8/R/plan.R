plan <- drake_plan(
  # Data
  data_in = read_csv(file_in(!! input_file)),
  data = target(
    preprocessData(data_in, standardize),
    transform = map(standardize = !! standardize)
  ),
  
  # Model
  splited = target(
    splitData(data, p = partition_rate),
    transform = map(data)
  ),

  model = target(
    model_function(splited$train),
    transform = cross(splited, model_function = !! model_functions)
  ),

  # Performance
  test_predictions_int = target(
    predictNewData(model, splited$test) %>%
      mutate(id = id_chr()),
    transform = map(model, .id = c(model_function, standardize))
  ),

  test_predictions = target(
    bind_rows(test_predictions_int),
    combine(test_predictions_int)
  ),

  metrics = calculateMetrics(test_predictions, id),

  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

