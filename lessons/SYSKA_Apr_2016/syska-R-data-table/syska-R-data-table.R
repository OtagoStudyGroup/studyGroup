install.packages("data.table") #v.1.9.6
# Install development version of data.table
install.packages("data.table", repos = "https://Rdatatable.github.io/data.table", type = "source") #v1.9.7
library("data.table")

#data table has it's own read function - to rapidly read data into R
#can be used for data.frames
gapminderFiveYearData <- fread("gapminder-FiveYearData.csv", data.table=F)
class(gapminderFiveYearData)
dim(gapminderFiveYearData)
head(gapminderFiveYearData)
tail(gapminderFiveYearData)
str(gapminderFiveYearData)

library("ggplot2")
ggplot(data = gapminderFiveYearData, aes(x = lifeExp, y = gdpPercap, color=continent)) +
  geom_point()

#defaults to a data.table
gapminderFiveYearData <- fread("gapminder-FiveYearData.csv")
class(gapminderFiveYearData)
dim(gapminderFiveYearData)
head(gapminderFiveYearData)
tail(gapminderFiveYearData)
str(gapminderFiveYearData)
#data tables also auto-trim when printing to console
gapminderFiveYearData

#data tables are backwards compatible with a lot of operations which use data.frames
#plots
dev.off()
ggplot(data = gapminderFiveYearData, aes(x = lifeExp, y = gdpPercap, color=continent)) +
  geom_point()
#linear models
linear_model <- lm(gdpPercap ~ pop + year, gapminderFiveYearData)
summary(linear_model)
linear_model <- lm(lifeExp ~ gdpPercap + pop + year, gapminderFiveYearData)
summary(linear_model)
linear_model <- glm(lifeExp ~ gdpPercap + continent + pop + year, family  ="gaussian", gapminderFiveYearData)
summary(linear_model)
#dplyr things
library("plyr")
calcGDP <- function(dat, year=NULL, country=NULL) {
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  gdp <- dat$pop * dat$gdpPercap
  
  new <- cbind(dat, gdp=gdp)
  return(new)
}
plyr::ddply(
  .data = calcGDP(gapminderFiveYearData),
  .variables = "continent",
  .fun = function(x) mean(x$gdp)
)

#fread is fast
gapminderlarge <- fread("gapminder-large.csv", header=T)
rm(gapminderlarge)
#fread is smart
gapminderFiveYearData <- fread("gapminder-FiveYearData.tsv") #tab delimited
gapminderFiveYearData <- fread("gapminder-FiveYearData.txt") #space delimited
#auto detects column classes, separators, headers, nrows - for a regularly separated file
#same comand for a whole bunch of file formats
#all the usual reading options can be specified manually 
gapminderFiveYearDataCrop <- fread("gapminder-FiveYearData.tsv", header=T, col.names=c("place", "time", "people", "big place", "life", "money"), nrows=1000, stringsAsFactors=F)
#cool progress bars for large files :)
gapminderlarger <- fread("gapminder-larger.csv") #so fast it tells you (9-10s)
#system.time(gapminderlarger <- read.csv("gapminder-larger.csv", header=T)) #the same operation took 57.203s with base R 

#generate gapminder-large data
source("gapminderlarger.R")

#FYI - there's also a "fast write"
fwrite(gapminderlarger, file="test.csv") #defaults to csv
fwrite(gapminderlarger, file="test.tsv", sep="\t")
#which is also fast to write data
system.time(write.csv(gapminderlarger, file="test.csv")) #46.216s user, 71.382s elapsed
#rm(gapminderlarger)

#another R reading package: readr (Hadley Wickham and RStudio)
library("readr")
system.time(read_table("gapminder-FiveYearData.txt")) #faster for space delimited files
system.time(read.table("gapminder-FiveYearData.txt"))
system.time(read_csv("gapminder-larger.csv")) #faster for csv (on large data file)
system.time(read.csv("gapminder-larger.csv"))

#readr fixed-width file
read_table #readr equivalent of read.table
read_fwf #readr equivalent of read.fwf
read_csv #readr equivalent of read.csv
read_tsv #readr equivalent of read.tss
read_lines #readr equivalent of readLines

#readxl packge
library("readxl")
read_excel #reads xls or xlsx file (specifies which sheet to extract)
#new alternative to read.xlsx (xlsx) package (java and perl dependent)

#bigmemory
library("bigmemory")
#uses the "big.matrix' format to access large data files in a C++ framework - rather than stored in RAM/memory as usual in R.
gapminderFiveYearData.big <- as.big.matrix(gapminderFiveYearData) #convert R data matrix into a "big.matrix"
gapminderFiveYearData.big
class(gapminderFiveYearData.big)
dim(gapminderFiveYearData.big)
head(gapminderFiveYearData.big)
tail(gapminderFiveYearData.big)
str(gapminderFiveYearData.big)
#also has read/write functions direct to big.matrix format
write.big.matrix(gapminderFiveYearData.big, "gapminder-FiveYearData.csv")
gapminderFiveYearData.big <- read.big.matrix("gapminder-FiveYearData.csv")
#efficient for memory - how fast is it?
system.time(gapminderlarger.big <- read.big.matrix("gapminder-larger.csv")) #28.272s user, 28.647s elapsed
system.time(write.big.matrix(gapminderFiveYearData.big, "test.csv")) #0.012s, 0.068s elapsed
  
#FEATHER (it's own fast file format) - from Hadley Wickham ggplot/dplyr/etc... and Wes Mckinney (pandas in Python)
#in development (unstable) - future versions may not read past versions - use to transfer files quickly (e.g., between R and Python)
library("devtools")
devtools::install_github("wesm/feather/R")
library(feather)
path <- "gapminder-FiveYearData.feather"
write_feather(gapminderFiveYearData, path) #write data frame to file
gapminderFiveYearData <- read_feather(path) #read to data frame
gapminderFiveYearData
#did I mention it's crazy fast?
path <- "gapminderlarger.feather"
system.time(write_feather(gapminderlarger, path)) #1.160s user, 5.008s elapsed
system.time(gapminderlarger <- read_feather(path)) #2.344 user, 2.414s elapsed

##FILE I/O Summary
##READ
#base R: read.csv: 57.203s
#data.table: fread: 8.154s
#readr: read_csv: 11.120s
#bigmemory: 28.647s
#feather: 2.414s

#convert dataframe to format:
#data.table: 0.002s (0.001s back to dataframe)
#big.memory: 66.07s

##WRITE
#base R: write.csv: 71.382s
#data.table: fwrite: 35.453s
#bigmemory: 0.068s
#feather: 5.008s

#Manipulating Data Tables
gapminderFiveYearData <- fread("gapminder-FiveYearData.csv", data.table=T)
class(gapminderFiveYearData)
#pretend it's a data frame
gapminderFiveYearData[1,]
colnames(gapminderFiveYearData)
gapminderFiveYearData$country
#Data Table "Natural" Syntax
#...although suspiciously similar to SQL?
#DT[where, select|update|do, by]
#Chaining Queries
#DT[][]
#Formally: DT[i, j, by]

#I: row selection
gapminderFiveYearData[c(1:5, 100:105),] #by number
gapminderFiveYearData[gapminderFiveYearData$country=="New Zealand",] #by condition
gapminderFiveYearData[gapminderFiveYearData$country %in% c("New Zealand", "Australia", "Japan"),] #by condition
gapminderFiveYearData[year=="1952"]
#J: column selection
gapminderFiveYearData[,"country"] #by names
gapminderFiveYearData[,gapminderFiveYearData$country %in% c("New Zealand", "Australia", "Japan")] #by condition
#operation on columns
gapminderFiveYearData[,sum(gdpPercap)] #by colnames
gapminderFiveYearData[,sum(gdpPercap*pop)] #by colnames
gapminderFiveYearData[,mean(pop)] #by colnames
gapminderFiveYearData[,mean(lifeExp)] #by colnames
#BY: group operation
gapminderFiveYearData[j=sum(gdpPercap), by=year]
gapminderFiveYearData[,sum(gdpPercap), year]
gapminderFiveYearData[,mean(lifeExp), year]
gapminderFiveYearData[,sum(pop), by=list(continent, year)]
library("gplots")
plot(gapminderFiveYearData[,sum(pop), by=list(continent, year)]$year,
     gapminderFiveYearData[,sum(pop), by=list(continent, year)]$V1,
     col=rainbow(5)[as.numeric(as.factor(gapminderFiveYearData[,sum(pop), by=list(continent, year)]$continent))])
legend("topleft", fill=rainbow(5), legend=levels(as.factor(gapminderFiveYearData[,sum(pop), by=list(continent, year)]$continent)))
#New and Shiny: by=.EACHI
gapminderFiveYearData[year=="1952" | year=="2002", j=sum(pop), by=year]
gapminderFiveYearData[c("New Zealand","Australia"),sum(gdpPercap*pop)]
gapminderFiveYearData[c("New Zealand","Australia"),sum(gdpPercap*pop), by=year]
gapminderFiveYearData[c("New Zealand","Australia"),sum(gdpPercap*pop), by=.EACHI]
gapminderFiveYearData[c("New Zealand","Australia"),sum(gdpPercap*pop), by=list(year, country)]
#total rows (new behaviour)
gapminderFiveYearData[c("New Zealand","Australia"), .N] #count number of rows
#total rows (once default behaviour): implicit by
gapminderFiveYearData[c("New Zealand","Australia"), .N, by=.EACHI] #count number of rows (for each I)

#tables() shows all tables and their SQL-like "keys"
tables()
rowID <- paste(gapminderFiveYearData$country, gapminderFiveYearData$year)
rowID
gapminderFiveYearData$rowID <- rowID
gapminderFiveYearData
setkey(gapminderFiveYearData, rowID)
tables()
gapminderFiveYearData["New Zealand 1952",] #search row by key
setkey(gapminderFiveYearData, country) # duplicate keys permitted (compare to dataframe: rownames)
gapminderFiveYearData["New Zealand",] #alls rows returned by default (rather than only first for dataframe)
#mult="first" or "last" or each group
gapminderFiveYearData["New Zealand", mult="first"] 
gapminderFiveYearData["New Zealand", mult="last"] 

#queries in data.tables aren't just *easier* they're **faster**
gapminderFiveYearData["New Zealand", mult="first"] 
system.time(gapminderFiveYearData["New Zealand", mult="first"]) #time 0.001s
gapminderFiveYearData.dataframe <- as.data.frame(gapminderFiveYearData)
gapminderFiveYearData.dataframe[gapminderFiveYearData.dataframe$country=="New Zealand",][1,]
system.time(gapminderFiveYearData.dataframe[gapminderFiveYearData.dataframe$country=="New Zealand",][1,]) #0.001s

setkey(gapminderlarger, country)
gapminderlarger["New Zealand", mult="first"] 
system.time(gapminderlarger["New Zealand", mult="first"]) #time 0.001s
gapminderlarger.dataframe <- as.data.frame(gapminderlarger)
gapminderlarger.dataframe[gapminderlarger.dataframe$country=="New Zealand",][1,]
system.time(gapminderlarger.dataframe[gapminderlarger.dataframe$country=="New Zealand",][1,]) #0.436s

setkey(gapminderlarger, country, year)
gapminderlarger[list("New Zealand", 2007)]
system.time(gapminderlarger[list("New Zealand", 2007)]) #0.002s
gapminderlarger.dataframe[gapminderlarger.dataframe$country=="New Zealand" & gapminderlarger.dataframe$year=="2007",]
system.time(gapminderlarger.dataframe[gapminderlarger.dataframe$country=="New Zealand" & gapminderlarger.dataframe$year=="2007",]) #1.818s

#by is faster too
gapminderlarger[,sum(gdpPercap), year]
system.time(gapminderlarger[,sum(gdpPercap), year]) #0.074s
tapply(gapminderlarger.dataframe$gdpPercap,gapminderlarger.dataframe$year,sum)
system.time(tapply(gapminderlarger.dataframe$gdpPercap,gapminderlarger.dataframe$year,sum)) #0.445s

           