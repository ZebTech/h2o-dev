setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

test.nbayes.golden <- function(H2Oserver) {
  Log.info("Importing iris_wheader.csv data...") 
  irisR <- read.csv(locate("smalldata/iris/iris_wheader.csv"), header = TRUE)
  irisH2O <- h2o.uploadFile(H2Oserver, locate("smalldata/iris/iris_wheader.csv"), key = "irisH2O")
  
  smoothing <- rnorm(1, mean = 1e-6, sd = 5)^2
  Log.info(paste("Compare with Naive Bayes when x = 1:4, y = 5, laplace =", smoothing))
  fitR <- naiveBayes(class ~ ., irisR, laplace = smoothing)
  fitH2O <- h2o.naiveBayes(x = 1:4, y = 5, training_frame = irisH2O, laplace = smoothing)
  checkNaiveBayesModel(fitH2O, fitR, nrow(irisR), tolerance = 1e-4)
  
  Log.info("Compare Predictions between Models")
  classR <- predict(fitR, irisR, type = "class")
  postR <- predict(fitR, irisR, type = "raw")
  predH2O <- predict(fitH2O, irisH2O)
  checkNaiveBayesPrediction(predH2O, classR, type = "class", tolerance = 1e-4)
  checkNaiveBayesPrediction(predH2O, postR, type = "raw", tolerance = 1e-4)
  
  testEnd()
}

doTest("Naive Bayes Golden Test: Iris with Laplace Smoothing", test.nbayes.golden)
