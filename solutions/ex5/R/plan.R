plan <- drake_plan(
  # Data
  data_in = read.csv('data/Metro_Interstate_Traffic_Volume.csv'),
  data = preprocessData(data_in),
  
  # Model
  model = fitModel(data, gam_k = -1),
  
  #Performance
  test_predictions = predictNewData(model, data),
  
  # Report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)