#Creates a matrix
mat=matrix(c(rnorm(6,0.70,0.10),rnorm(4,0.30,0.10),rnorm(6,0.70,0.10),
             rnorm(4,0.30,0.10),rnorm(6,0.70,0.10),rnorm(4,0.30,0.10),
             rnorm(40,0.70,0.10),rnorm(5,0.30,0.10),rnorm(5,0.60,0.10),
             rnorm(5,0.30,0.10),rnorm(5,0.60,0.10),rnorm(5,0.30,0.10),
             rnorm(5,0.60,0.10)),nrow=10)

#Creates a matrix of colum groups
cgroup1 = c(rep("red",3),rep("blue",4),rep("green",3))
column_annotation = as.matrix(cgroup1)
#sets names
colnames(column_annotation) = c("Variable X")

#Clusters rows into groups then creates a matrix of those groups
rowGroup = cutree(hclust(dist((mat))),k=2)
row_annotation = rbind(c("red","blue")[rowGroup])
rownames(row_annotation) = c("Variable Y")

#Produces heatamp
heatmap.3(mat, RowSideColors=row_annotation,
          distfun=function(x) dist(x,method = "euclidean"),
          ColSideColors=column_annotation,
          margins = c(5,15),
          main =  "Heatmap")

#Adds legends
legend("topright", legend=c("Red", "Green", "Blue"),
       fill=c("Red", "Green", "Blue"), bty="n", lty=0,
       box.lty=0,title="Variable X1")
legend("right", legend=c("Red", "Blue"), fill=c("Red", "Blue"),
       bty="n", lty=0, box.lty=0,title=" Variable Y   ")


# multiple columns

#Creates a second matrix of colum groups
cgroup2 = c(rep("green",7),rep("red",3))
#Combines the two colum groups into a single matrix (note: Use rbind if producing row annotation)
column_annotation = cbind(cgroup1,cgroup2)
#Sets names
colnames(column_annotation) = c("Variable X1", "Variable X2")

#Clusters rows into groups then creates a matrix of those groups
rowGroup = cutree(hclust(dist((mat))),k=2)
row_annotation = rbind(c("red","blue")[rowGroup])
rownames(row_annotation) = c("Variable Y")

#Produces heatmap
heatmap.3(mat, RowSideColors=row_annotation,
          distfun=function(x) dist(x,method = "euclidean"),
          ColSideColors=column_annotation,
          margins = c(5,15),
          main = "Heatmap")

#Adds Legends
legend("topright", legend=c("Red", "Green", "Blue"),
       fill=c("Red", "Green", "Blue"), bty="n",
       lty=0, box.lty=0,title="Variable X1")
legend("right", legend=c("Red", "Green"),
       fill=c("Red", "Green"), bty="n",
       lty=0, box.lty=0,title="Variable X2")
legend("bottomright", legend=c("Red", "Blue"),
       fill=c("Red", "Blue"), bty="n", lty=0,
       box.lty=0,title=" Variable Y   ")

