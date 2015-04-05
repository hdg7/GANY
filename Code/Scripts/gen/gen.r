#!/usr/bin/Rscript
#
#    Copyright (C) 2015 by Hector D. Menendez <hector.david.1987@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

library("GA")
library("proxy")
library("MASS")
library("fields")
library("matrixStats")
#library("compiler")

args <- commandArgs(TRUE)
points <- read.table(args[1],sep=";",head=FALSE)
dimen <- length(points[1,]) #Problem dimension

fitness <- function(centroids)
{
    centFrame <- data.frame(Date=as.Date(character()),
                 File=character(), 
                 User=character(), 
                 stringsAsFactors=FALSE) 
    for(i in seq(1,length(centroids),dimen))
    {
        #print(length(centroids))
        #print(centroids[i:(i+dimen-1)])
        centFrame <- rbind(centFrame, as.numeric(centroids[i:(i+dimen-1)]))
    }
    z <-rdist(centFrame,points)
    distCent <- rdist(centFrame)
    if(min(distCent + diag(dimen))<0.0001)
        return(0)
    #print(distCent + diag(dimen))
    return(1/sum(colMins(z)))
}
#fitness2 <- cmpfun(fitness)
fitness2 <- fitness

min = apply(points, 2,min)
minv = rep(min,dimen)
max = apply(points, 2,max)
maxv = rep(max,dimen)
GA <- ga(type="real-valued",fitness=fitness2,min=minv,max=maxv)
centFrame <- data.frame(Date=as.Date(character()),
                 File=character(), 
                 User=character(), 
                 stringsAsFactors=FALSE) 
for(i in seq(1,length(minv),dimen))
{
    #print(i)
    #print(centroids[i:(i+dimen-1)])
    centFrame <- rbind(centFrame, as.numeric(GA@solution[i:(i+dimen-1)]))
}
z <-dist(centFrame,points,method="Euclidean")
output <- apply(z,2,which.min)

write.matrix(t(output),file=paste("gen.Sols/sol",args[2],sep=""),sep=" ")
