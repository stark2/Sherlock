# install.packages("rjson")
# install.packages("dplyr")

# clean R environment
rm(list=ls())

# load JSON and DPLYR libraries
library(jsonlite)
library(dplyr)

library(Rcpp)
library(inline)

setwd("/home/david/Data/Sherlock/r-sherlock")

sourceCpp("resolver.cpp")

resolved_ip <- gethostbyname("dds.ec")

source("geoip.R")
#geoobj <- freegeoip('184.26.100.110')
#geoobj$ip
#class(geoobj)

# load JSON file into a data.frame
json_file <- stream_in(file("events-mssi.txt"))   # JSON (RFC 4627)
json_data <- flatten(json_file)
# remove entries without DNS 
json_data <- json_data[!is.na(json_data$source.fqdn),]
dim(json_data)
head(json_data$source.fqdn)

# take 100 to minimize the number of DNS entries to resolve
json_data <- head(json_data, 200)
json_data$source.ip <- lapply(json_data$source.fqdn, gethostbyname)
# remove entries without resolved IP addresses 
json_data <- json_data[!json_data$source.ip=='character(0)',]
dim(json_data)
json_data <- head(json_data, 100)
class(json_data$source.ip)
class(json_data)
dim(json_data)
write.table(json_data, file = "json_data.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")
View(json_data)

#class(json_file)
#summary(json_file)
#View(json_file)

# load client data into a data.frame
client_data <- read.csv(file="client_data.txt", header=FALSE, sep=",", stringsAsFactors=FALSE)
colnames(client_data) <- c("MAC", "TIMESTAMP", "PROTOCOL", "IP_SOURCE", "PORT_SOURCE", "host.ip", "PORT_TARGET", "STATUS", "SERVICE")
class(client_data)
#View(client_data)

# load JSON file with HOST.IP field into a data.frame
threat_feed <- stream_in(file("threat_feed.txt"))   # JSON (RFC 4627)
colnames(threat_feed)
class(threat_feed)
summary(threat_feed)
#View(threat_feed)

class(threat_feed["host"])

# flatten JSON structure for join operation
f_data <- flatten(threat_feed)

# do left join on client_data and f_data
t_join <- inner_join(client_data, f_data, by = "host.ip")
class(t_join)
# view report
View(t_join)

geo_data <- lapply(t_join$host.ip, freegeoip)
View(geo_data)
