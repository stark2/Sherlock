# install.packages("rjson")
# install.packages("dplyr")
# clean R environment
rm(list=ls())

# load JSON and DPLYR libraries
library(jsonlite)
library(dplyr)

library(Rcpp)
library(inline)

library(data.table)

setwd("/home/david/Data/Sherlock/r-sherlock")

sourceCpp("resolver.cpp")

resolved_ip <- gethostbyname("dds.ec")

source("geoip.R")
#geoobj <- freegeoip('184.26.100.110')
#geoobj$ip
#class(geoobj)

# load JSON file into a data.frame
json_file <- stream_in(file("events-mssi.txt"))   # JSON (RFC 4627), Imported 108491 records. Simplifying into dataframe...
json_data <- flatten(json_file)
# remove entries without DNS 
json_data <- json_data[!is.na(json_data$source.fqdn),]
dim(json_data) # [1] 98359    15
View(json_data)
# take 100 to minimize the number of DNS entries to resolve
#json_data <- head(json_data, 200)
json_data$source.ip <- lapply(json_data$source.fqdn, gethostbyname)
#remove entries without resolved IP addresses 
json_data <- json_data[!json_data$source.ip=='character(0)',]
#json_data$source.ip <- lapply(json_data$source.ip, as.character)
new_data <- flatten(new_data)
new_data <- new_data[!new_data$source.ip=='0.0.0.0',]   # [1] 62824    15
new_data$source.ip <- lapply(new_data$source.ip, paste, collapse="")
new_data$source.ip <- vapply(new_data$source.ip, paste, collapse = "", character(1L))
#saveRDS(new_data, "threat_data.rds")
#new_data <- readRDS("threat_data.rds")

dt <- data.table(new_data)
class(dt$source.ip)
write.table(dt, file = "threat_data.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")


max.len <- lapply(new_data$source.ip, length)
as.character(new_data$source.ip)
dim(new_data)
class(new_data$source.ip)
write.table(new_data, file = "threat_data.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")

dim(json_data) # [1] 63081    15
#json_data <- head(json_data, 100)
class(json_data$source.ip)
class(json_data)
dim(json_data)
write.table(json_data, file = "json_data.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")
View(json_data)

# save(list = ls(all = TRUE), file= "all.RData")
# local({ load("all.RData") ls() })

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


library(maps)       # Provides functions that let us plot the maps
library(mapdata)    # Contains the hi-resolution points that mark out the countries.
library(sp)

setwd("/home/david/Data/Sherlock/r-sherlock")

source("geoip.R")

my_coordinates = freegeoip('72.167.232.197')

map('worldHires',c('Switzerland'))

points(my_coordinates$longitude, my_coordinates$latitude, col=2, pch=19)

#map('worldHires')
map('world2Hires')

#threat_data <- read.csv(file="threat_data_15666.csv", header=FALSE, sep=",", stringsAsFactors=FALSE)
#colnames(threat_data) <- c("raw", "classification_type", "malware_name", "feed_name", "feed_url", "feed_accuracy", "source_fqdn", "source_ip", "source_network", "source_url", "source_asn", "source_reverse_dns", "time_observation", "time_source", "event_description_text")

threat_data <- read.csv(file="threat_data_15652_ipinfo.csv", header=FALSE, sep=",", stringsAsFactors=TRUE)
colnames(threat_data) <- c("source_ip", "locale", "country", "code", "state", "city", "zip", "county", "latitude", "longitude", "status")

View(threat_data)

#threat_data <- tail(threat_data, 20)

#threat_data_coordinates <- lapply(threat_data$source_ip, freegeoip)
#threat_data_frame <- data.frame(matrix(unlist(threat_data_coordinates), nrow=20, byrow=T), stringsAsFactors=FALSE)

View(threat_data_frame)

map('worldHires')
points(threat_data$longitude, threat_data$latitude, col=threat_data$country, pch=19)




rm(list=ls())

library(maps)
library(ggplot2)

threat_data <- read.csv(file="threat_data_15652_ipinfo.csv", header=FALSE, sep=",", stringsAsFactors=TRUE)
colnames(threat_data) <- c("source_ip", "locale", "country", "code", "state", "city", "zip", "county", "latitude", "longitude", "status")

world_map <- map_data("world")
#Switzerland <- subset(world_map, world_map$region=="Switzerland")

p <- ggplot() + coord_fixed() + xlab("") + ylab("")
base_world_messy <- p + geom_polygon(data=world_map, aes(x=long, y=lat, group=group), colour="black", fill="light green")
cleanup <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = 'white', colour = 'white'), 
        axis.line = element_line(colour = "white"), legend.position="none",
        axis.ticks=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank())

base_world <- base_world_messy + cleanup

map_data <-base_world + geom_point(data=threat_data, aes(x=longitude, y=latitude), colour="white", fill="red", pch=21, size=2, alpha=I(0.7))
map_data


library(rworldmap)

library(mapproj)
library(rworldxtra)

newmap <- getMap(resolution = "high")
points(threat_data$longitude, threat_data$latitude, col = "red", cex = .6)



library(rgbif)
install.packages("rgbif")
Dan_chr=occurrencelist(sciname = 'Danaus chrysippus',
                       coordinatestatus = TRUE,
                       maxresults = 1000,
                       latlongdf = TRUE, removeZeros = TRUE)
library(ggmap)
library(ggplot2)
wmap1 = qmap('India',zoom=2)
wmap1 +
  geom_jitter(data = Dan_chr,
              aes(decimalLongitude, decimalLatitude),
              alpha=0.6, size = 4, color = "red") +
  opts(title = "Danaus chrysippus")


### GGMAP #######################################################################

rm(list=ls())

library(ggmap)
library(png)
setwd("/home/david/Data/Sherlock/r-sherlock")

threat_data <- read.csv(file="threat_data_15652_ipinfo.csv", header=FALSE, sep=",", stringsAsFactors=FALSE)
colnames(threat_data) <- c("source_ip", "locale", "country", "code", "state", "city", "zip", "county", "latitude", "longitude", "status")
#View(threat_data)
#stat <- as.data.frame(table(threat_data$country))
#write.table(stat, file = "country_stat.csv", row.names=FALSE, na="", col.names=FALSE, sep=",")

map <- get_map(location = 'North America', zoom = 4)
map <- get_map(location = 'South America', zoom = 4)
map <- get_map(location = 'Europe', zoom = 4)
map <- get_map(location = 'Asia', zoom = 4)
map <- get_map(location = 'Africa', zoom = 4)
map <- get_map(location = 'Australia', zoom = 4)

map <- get_map(location = 'United States', zoom = 4)
map <- get_map(location = 'China', zoom = 4)
map <- get_map(location = 'Germany', zoom = 6)
map <- get_map(location = 'Russia', zoom = 4)
map <- get_map(location = 'Moscow', zoom = 6)
map <- get_map(location = 'France', zoom = 6)
map <- get_map(location = 'Switzerland', zoom = 10)
map <- get_map(location = 'Hong Kong', zoom = 11)
map <- get_map(location = 'Netherlands', zoom = 8)
map <- get_map(location = 'United Kingdom', zoom = 6)
map <- get_map(location = 'South Korea', zoom = 7)

ggmap(map)

TC <- ggmap(map) + geom_point(data=threat_data, alpha = .4, size = 8, aes(x = longitude, y = latitude), color='red') # + ggtitle("Threat")
TC
