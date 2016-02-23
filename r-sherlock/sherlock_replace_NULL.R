rm(list=ls())

setwd("/home/david/Data/Sherlock/r-sherlock")

data <- read.table(file = "threat_data.csv", header = FALSE, sep = ",", na.strings =  "", comment.char = "#", stringsAsFactors = FALSE)
class(data)
View(data)

test <- data
test[is.na(test)] <- 0
class(test)
View(test)

write.table(test, file = "threat_data_without_null.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")
