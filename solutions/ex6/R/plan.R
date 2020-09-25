plan <- drake_plan(
  # Data
  data_in = read.csv('data/Metro_Interstate_Traffic_Volume.csv'),
  data = preprocessData(data_in),
  
  # Model
  model = target(fitModel(data, gam_k = gam_k),
                 transform = map(gam_k = c(-1, 5, 10))),
  
  #Performance
  test_predictions = target(predictNewData(model, data),
                            transform = map(model)),
  
  # Report
  # report = rmarkdown::render(
  #   knitr_in("report.Rmd"),
  #   output_file = file_out("report.html"),
  #   quiet = TRUE
  # )
)
