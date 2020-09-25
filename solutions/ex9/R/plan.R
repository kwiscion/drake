plan <- drake_plan(
  # Data
  data_in = read.csv('data/Metro_Interstate_Traffic_Volume.csv'),
  data = preprocessData(data_in) %>% split(.$day_type),
  
  # Model
  model = target(fitModel(data[[1]], gam_k = 3),
                 dynamic = map(data)),
  
  #Performance
  test_predictions = predictNewData(model[[1]], data[[1]]),
  
  # Report
  # report = rmarkdown::render(
  #   knitr_in("report.Rmd"),
  #   output_file = file_out("report.html"),
  #   quiet = TRUE
  # )
)

