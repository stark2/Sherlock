# install.packages("rjson")
# install.packages("dplyr")

# clean R environment
rm(list=ls())

# load JSON and DPLYR libraries
library(jsonlite)
library(dplyr)

# load JSON file into a data.frame
json_file <- stream_in(file("/home/david/Data/r-workspace/sherlock/events-mssi.txt"))   # JSON (RFC 4627)
class(json_file)
summary(json_file)
View(json_file)

# load client data into a data.frame
client_data <- read.csv(file="/home/david/Data/r-workspace/sherlock/client_data.txt", header=FALSE, sep=",", stringsAsFactors=FALSE)
colnames(client_data) <- c("MAC", "TIMESTAMP", "PROTOCOL", "IP_SOURCE", "PORT_SOURCE", "host.ip", "PORT_TARGET", "STATUS", "SERVICE")
class(client_data)
#View(client_data)

# load JSON file with HOST.IP field into a data.frame
threat_feed <- stream_in(file("/home/david/Data/r-workspace/sherlock/threat_feed.txt"))   # JSON (RFC 4627)
colnames(threat_feed)
class(threat_feed)
summary(threat_feed)
#View(threat_feed)

class(threat_feed["host"])

# flatten JSON structure for join operation
f_data <- flatten(threat_feed)

# do left join on client_data and f_data
t_join <- inner_join(client_data, f_data, by = "host.ip")

# view report
View(t_join)
