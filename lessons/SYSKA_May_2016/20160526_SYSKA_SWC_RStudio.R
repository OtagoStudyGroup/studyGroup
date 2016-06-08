#Data for Today
setwd("~/Downloads")
system("git clone https://github.com/swcarpentry/r-novice-inflammation.git")

#Lesson Notes for Today: http://swcarpentry.github.io/r-novice-inflammation/

#go to this folder
setwd("~/Downloads/r-novice-inflammation/")

#where am i?
getwd()

?read.csv

#relative directory
read.csv("./data/inflammation-01.csv")

#absolute directory
read.csv("~/Downloads/r-novice-inflammation/data/inflammation-01.csv")

#setting variable
x <- 5
x
y <- x +1

data <- read.csv("./data/inflammation-01.csv")
head(data)
dim(data)
colnames(data)

#slices
data[1:5,5]
data[row_numbers, col_numbers]

#column by name
data$X0
data[,"X0"]

cor(data$X0, data$X3.3)
t.test(data$X0, data$X3.3)
boxplot(data$X0, data$X3.3)

plot(1:100, rnorm(100))
plot(1:100, rnorm(100), col="red")

boxplot(rep(1:2, 50), rnorm(100))

#sequences
1:5
c(1,2,3,4,5)
seq(1,5)
seq(1,500)
seq(1,500,2)
rep(1, 20)

#vectorization
x <- c(1,2,3,4,5)
2 * x

for(i in 1:length(x)){
  print(x[i]*2)
}

sum(x)
sum(data[,1])
sum(data[,2])
sum(data[,3])
sum(data[,5])

dim(data)
apply(data, 2, sum)
apply(data, 1, sum)

apply(X=data, MARGIN=1, FUN=sum)
apply(data, sum, 1) #doesn't work
apply(X=data, FUN=sum, MARGIN=1)

?apply

for(i in 1:ncol(data)){
  x <- data[,i]
  print(sum(x))
}

ma <- matrix(c(1:4, 1, 6:8), nrow = 2)
ma
apply(ma, 1, table)

sum(1:2)
sum
?sum

min(1:2)
min
?min

max(1:2)
max
?max

mean(1:100)
#help
?average
#search
??average

#write own functions

square_number <- function(x){
  x <- y
  if(y<0){
    y <- -y # make positive
  }
  z <- y^2 #square number
  return(z)
}

square_number <- function(x) x^2


square_number
?square_number
#test
square_number(1)
square_number(2)
square_number(-1)
square_number(0)

square_number("a")
square_number(data)

#save memory
head(square_number(data))

#save cpu / time (re-run)
a <- square_number(data)
head(a)

square_number(1)

#apply R function
apply(data, 1, sqrt)
#apply my function
apply(data, 1, square_number)
#apply new function
apply(data, 2, function(x) x^2)
apply(data, 1, function(x){
  y <- x
  if(y<0){
    y <- -y # make positive
  }
  z <- y^2 #square number
  return(z)
})


#opt1: write own function
#opt2: use package with help
#installed.packages("ggplot2")
library("ggplot2")
?gplot
??ggplot
#opt3: use someone's code / answer off the interwebs
#e.g.,  StackOverflow, StackExchange
?dput
#code to make your data (reproduce issue)
dput(data)
sessionInfo()