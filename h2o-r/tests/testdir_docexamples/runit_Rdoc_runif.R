
setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../h2o-runit.R')

test.rdocrunif.golden <- function(H2Oserver) {

prosPath <- system.file("extdata", "prostate.csv", package="h2o")
prostate.hex <- h2o.importFile(H2Oserver, path = prosPath, key = "prostate.hex")
s <- h2o.runif(prostate.hex)
summary(s)
prostate.train <- prostate.hex[s <= 0.8,]
prostate.test <- prostate.hex[s > 0.8,]
nrow(prostate.train) + nrow(prostate.test)
count <- nrow(prostate.train) + nrow(prostate.test)
sum <- summary(prostate.test)

testEnd()
}

doTest("R Doc Runif", test.rdocrunif.golden)

