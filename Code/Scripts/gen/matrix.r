#!/usr/bin/Rscript
#
#    Copyright (C) 2002 Alexandros Karatzoglou <alexis@ci.tuwien.ac.at>
#    Modified by:
#       Copyright (C) 2015 by Hector D. Menendez <hector.david.1987@gmail.com>
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


#   Environment. Please, Modify GENERAL_FOLDER with your current folder in order to run the script

#   Example: sh scriptGeneration.sh

library("kernlab")
library("MASS")

args <- commandArgs(TRUE)
x <- read.table(args[1],sep=";",head=FALSE)
iterations <- 200
nc <-  as.numeric(args[2])
centers <- as.numeric(args[2])
x <- as.matrix(x)
m <- nrow(x)
mod.sample <-  0.75
nystrom.sample <-  as.numeric(args[3])

.ginv <- function (X, tol = sqrt(.Machine$double.eps))
{
  if (length(dim(X)) > 2 || !(is.numeric(X) || is.complex(X)))
    stop("'X' must be a numeric or complex matrix")
  if (!is.matrix(X))
    X <- as.matrix(X)
  Xsvd <- svd(X)
  if (is.complex(X))
    Xsvd$u <- Conj(Xsvd$u)
  Positive <- Xsvd$d > max(tol * Xsvd$d[1], 0)
  if (all(Positive))
    Xsvd$v %*% (1/Xsvd$d * t(Xsvd$u))
  else if (!any(Positive))
    array(0, dim(X)[2:1])
  else Xsvd$v[, Positive, drop = FALSE] %*% ((1/Xsvd$d[Positive]) * t(Xsvd$u[, Positive, drop = FALSE]))
}

.sqrtm <- function(x)
  {
    tmpres <- eigen(x)
    V <- t(tmpres$vectors)
    D <- tmpres$values
    if(is.complex(D))
      D <- Re(D)
    D <- pmax(D,0)
    return(crossprod(V*sqrt(D),V))
  }

#DEBUG###
#x<- read.table("iris.csv",sep=";",head=FALSE)
#iterations <- 200
#nc <-  as.numeric("3")
#centers <- as.numeric("3")
#x <- as.matrix(x)
#m <- nrow(x)
#mod.sample <-  0.75
#nystrom.sample <-  as.numeric("50")
################

rown <- rownames(x)

sam <- sample(1:m, floor(mod.sample*nystrom.sample))
sx <- unique(x[sam,])
ns <- dim(sx)[1]
dota <- rowSums(sx*sx)/2
ktmp <- crossprod(t(sx))
for (i in 1:ns)
  ktmp[i,]<- 2*(-ktmp[i,] + dota + rep(dota[i], ns))


## fix numerical prob.
ktmp[ktmp<0] <- 0
ktmp <- sqrt(ktmp)

kmax <- max(ktmp)
kmin <- min(ktmp + diag(rep(Inf,dim(ktmp)[1])))
kmea <- mean(ktmp)
lsmin <- log2(kmin)
lsmax <- log2(kmax)
midmax <- min(c(2*kmea, kmax))
midmin <- max(c(kmea/2,kmin))
rtmp <- c(seq(midmin,0.9*kmea,0.05*kmea), seq(kmea,midmax,0.08*kmea))
if ((lsmax - (Re(log2(midmax))+0.5)) < 0.5){ step <- (lsmax - (Re(log2(midmax))+0.5))}else step <- 0.5
if (((Re(log2(midmin))-0.5)-lsmin) < 0.5 ){ stepm <-  ((Re(log2(midmin))-0.5) - lsmin)}else stepm <- 0.5

tmpsig <- c(2^(seq(lsmin,(Re(log2(midmin))-0.5), stepm)), rtmp, 2^(seq(Re(log2(midmax))+0.5, lsmax,step)))
diss <- matrix(rep(Inf,length(tmpsig)*nc),ncol=nc)
for (i in 1:length(tmpsig)){
  ka <- exp((-(ktmp^2))/(2*(tmpsig[i]^2)))
  diag(ka) <- 0
  
  d <- 1/sqrt(rowSums(ka))

  if(!any(d==Inf) && !any(is.na(d))&& (max(d)[1]-min(d)[1] < 10^4))
    {
      l <- d * ka %*% diag(d)
      xi <- eigen(l,symmetric=TRUE)$vectors[,1:nc]
      yi <- xi/sqrt(rowSums(xi^2))
##
      d <- dist(yi, method = "euclidean")
      fit <- hclust(d, method="ave") 
      groups <- cutree(fit, k=centers)
      rp <- rep(groups,ncol(yi))
      initialk <- tapply(yi,list(rp,col(yi)),mean)
    res <- kmeans(yi, initialk)
##
#      res <- kmeans(yi, centers, iterations)
      diss[i,] <- res$withinss
    }
}

ms <- which.min(rowSums(diss))
kernel <- rbfdot((tmpsig[ms]^(-2))/2)

n <- floor(nystrom.sample)
ind <- sample(1:m, m)
x <- x[ind,]

tmps <- sort(ind, index.return = TRUE)
reind <- tmps$ix
A <- kernelMatrix(kernel, x[1:n,])
B <- kernelMatrix(kernel, x[-(1:n),], x[1:n,])
d1 <- colSums(rbind(A,B))
d2 <- rowSums(B) + drop(matrix(colSums(B),1) %*% .ginv(A)%*%t(B))
dhat <- sqrt(1/c(d1,d2))

A <- A * (dhat[1:n] %*% t(dhat[1:n]))
B <- B * (dhat[(n+1):m] %*% t(dhat[1:n]))

Asi <- .sqrtm(.ginv(A))
Q <- A + Asi %*% crossprod(B) %*% Asi
tmpres <- svd(Q)
U <- tmpres$u
L <- tmpres$d
V <- rbind(A,B) %*% Asi %*% U %*% .ginv(sqrt(diag(L)))
yi <- matrix(0,m,nc)

## for(i in 2:(nc +1))
##   yi[,i-1] <- V[,i]/V[,1]

for(i in 1:nc) ## specc
  yi[,i] <- V[,i]/sqrt(sum(V[,i]^2))
write.matrix(Re(yi[reind,]),file="test1",sep=";")
