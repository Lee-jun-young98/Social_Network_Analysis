setwd("C://R_data")
library(igraph)


L=matrix(c(0,0,0,1,0,0,0,0,0,
           0,0,0,1,0,0,0,0,0,
           0,0,0,1,0,0,0,0,0,
           1,1,1,0,1,0,0,0,0,
           0,0,0,1,0,1,0,0,0,
           0, 0,0,0,1,0,1,0,0,
           0,0,0,0,0,1,0,1,0,
           0,0,0,0,0,0,1,0,1,
           0,0,0,0,0,0,0,1,0
), byrow=T,nrow=9)


g <- graph_from_adjacency_matrix(L, mode="directed")
plot(g, edge.arrow.size=0.5)

reciprocity(g)
dyad_census(g)

2*dyad_census(g)$mut/ecount(g)




l <- matrix(c(0,1,1,1,
              1,0,1,0,
              1,1,0,1,
              1,0,1,0), nrow=4)
g1 <- graph_from_adjacency_matrix(l, mode="directed")
transitivity(g1)




result <- read.csv("stock.csv")
## 주식네트워크 생성하기
g <- graph.data.frame(result, directed=FALSE)

## 상관계수에 절대값을 기준으로 0.6이하인건 지우기
g2 <- delete.edges(g,E(g)[abs(weight) < 0.6])

## 연결선이 하나도 없는 노드를 선택 degree가 연결된 정도
Isolated <-  which(degree(g2)==0)
Isolated
g2 <- delete.vertices(g2, Isolated)

length(V(g2))
length(E(g2))

edge_density(g2)

## 클러스터가 얼마나 연결되어있는지 
transitivity(g2)

## 상호(여러단계를 통해)도달 가능한 노드들의 집합
components(g2)

## 직접연결가능한 노드들의 집합
cliques(g2)


sort(sapply(cliques(g2), length), decreasing = TRUE)
largest_cliques(g2)



A<-matrix(c(1,0,0,1,1,0,1,0,0,0,1,0,0,1,1,0,0,1),byrow=T,ncol=3)
n <- nrow(A)
m <- ncol(A)
rownames(A) <- 1:n
colnames(A) <- c("A","B","C")

## igraph형태로 읽어오기 앞에꺼와 노드가 달라 사건행렬로 읽어옴 -> 전방행렬이 아니라 column과 row가 의미하는 것이 다르다
B2 <- graph_from_incidence_matrix(A, directed=FALSE)

## 노드수만큼 색과 크기를 생성
V(B2)$color <- c(rep("red", n), rep("blue", m))
V(B2)$size <- c(rep(10,n), rep(20,m))

plot(B2)

## R에서 행렬끼리의 계산을 할려면 %*%
A%*%t(A)


## 학생의 중심성 구하기
R.degree <- degree(B2)[1:n]
R.degree

## 인접중심성
R.closensess <- closeness(B2)[1:n]
R.closensess

