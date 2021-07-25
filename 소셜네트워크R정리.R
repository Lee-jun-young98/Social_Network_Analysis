library(igraph)
g1<- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
plot(g1)

setwd("C://R_data")

result <- read.csv("stock.csv")
## 주식네트워크 생성하기
g <- graph.data.frame(result, directed=FALSE)


str(g)

print(g)

plot(g)
plot.igraph(g)

## 상관계수가 0.6이하인 경우에는 edge를 제거 E(g)는 edge를 뜻하고 V(g)는 vertex를 뜻함 
g1 <- delete.edges(g, E(g)[ weight < 0.6])


plot.igraph(g1, layout=layout.auto, vertex.size=2, vertex.label=NA, edge.arrow=NA, edge.width=1)

## layout.fruchterman.reingold를 이용하여 더많은 연결점을 갖는 노드는 모이게 한다.
plot.igraph(g1, layout=layout.fruchterman.reingold, vertex.size=2, vertex.label=NA, edge.arrow=NA, edge.width=1)
## 노드사이즈 변경하기
plot.igraph(g1 ,layout=layout.auto, vertex.size=4, vertex.label=NA, edge.arrow=NA, edge.width=1)

# vertex.name=NA 옵션 제거
plot.igraph(g1, layout=layout.auto, vertex.size=4, edge.arrow=NA, edge.width=1)



## 상관계수에 절대값을 기준으로 0.6이하인건 지우기
g2 <- delete.edges(g,E(g)[abs(weight) < 0.6])

## 연결선이 하나도 없는 노드를 선택 degree가 연결된 정도
Isolated <-  which(degree(g2)==0)
Isolated
g2 <- delete.vertices(g2, Isolated)


## 노드와 라벨의 거리를 조정하여 그리기 vertex.label.dist
plot.igraph(g2, layout=layout.auto, vertex.size=4, edge.arrow=NA, edge.width=1, edge.curved=TRUE, vertex.label.dist=2)

## 사용자의 입력에 반응하는 그래프
tkplot(g2, vertex.size=0, edge.arrow=NA, edge.width=1, edge.curved=TRUE)



junior<-c('유관순 대표','일지매 부장','김유신 과장','이순신 부장','유관순 과장','신사임당 대리','강감찬 부장','광개토 과장','정몽주 대리')
senior<-c('유관순 대표','유지영 대표','일지매 부장','김유신 과장','김유신 과장','이순신 부장','유관순 과장','강감찬 부장','광개토 과장')
emp <- data.frame(이름=junior, 상사이름=senior)

g <- graph.data.frame(emp, directed = T)
print(g)

plot(g, layout=layout.auto, vertex.size=8, edge.arrow.size=0.5)

#방향성이 없는 네트워크로 생성
g <- graph.data.frame(emp,directed = F)
plot(g, layout=layout.fruchterman.reingold, vertex.size=8, edge.arrow.size=0.5)


library(igraph)
setwd("C://R_data")
stock_code <- read.csv("stock_code.csv")
stock_code

rownames(stock_code) <- stock_code$stock
stock_code
color <- factor(stock_code[V(g2)$name,]$group)
color


## 주식 그룹별로 색을 다르게하기
plot.igraph(g2, layout=layout.auto, vertex.size=6, edge.arrow=NA, edge.width=1, edge.curved=TRUE, vertex.color=color, vertex.label=NA)


## label까지 표시하기
plot.igraph(g2, layout=layout.auto, vertex.size=10, edge.arrow=NA, edge.width=1, edge.curved=TRUE, vertex.label.size=8,vertex.color=color)

V(g2)$type <- stock_code[V(g2)$name,]$group

library(RColorBrewer)

# 색을 추가하여 가독성 높이기
jColors <- brewer.pal(nlevels(color), name="Spectral")
# 컬러별로 그룹명을 매칭시키기 
names(jColors) <- unique(stock_code$group)
jcolors <- jColors[V(g2)$type]

## 범례추가
plot.igraph(g2, layout=layout.auto, vertex.size=10, edge.arrow=NA, edge.width=1, edge.curved=TRUE, vertex.label.size=4, vertex.label.cex=1,vertex.color=jcolors)
legend(x=-1.4,y=1.8,names(jColors),pch=21, pt.bg=jColors, pt.cex=2, cex=.8, bty='n', ncol=1)


## 거리중심성
sort(degree(g2), decreasing = TRUE)
sort(closeness(g2, mode="all"), decreasing = TRUE)
sort(betweenness(g2), decreasing = TRUE)


########################################실습2#########################################################
setwd("C://R_data")
g <- read.csv("군집분석.csv")
g <- graph.data.frame(g, directed=T)
plot(g)

plot(g, layout=layout.fruchterman.reingold, vertex.size=2, edge.arrow.size=0.5, vertex.color='green', vertex.label=NA)
plot(g, layout=layout.kamada.kawai, vertex.size=2, edge.arrow.size=0.5, vertex.label=NA)

## 선생님-학생관계 색상과 크기구분하여 출력하기
gubun1 <- V(g)$name
library(stringr)
gubun <- str_sub(gubun1, start=1, end=1)
gubun
colors <- ifelse(gubun=="S", "red","green")
colors
sizes <- ifelse(gubun=="S", 2,6)
sizes

plot(g, layout=layout.fruchterman.reingold, vertex.size=sizes, edge.arrow.size=0.5, vertex.color=colors)

##이름 없애기
plot(g, layout=layout.fruchterman.reingold, vertex.size=sizes, edge.arrow.size=0.5, vetex.color=colors, vertex.label=NA)


####################################중심성#######################################
L=matrix(c(0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0), byrow=T, nrow=9)
library(igraph)
g <- graph_from_adjacency_matrix(L)
plot(g)
plot(g, edge.arrow.size=0.5)

## 연결 중심성 함수 centr_degree를 이용해 각 노드의 중심성을 산출
#centr_degree(graph, mode = c("all","out", "in"), loops = TRUE, normalized = TRUE)

# res는 각 노드의 in/out degree를 구한 것, cen그려져 있는 것의 비율, theoretical 네크워크 수준의 값을 계산한 것 
centr_degree(g, mode="all")

## 근접중심성 함수
which.max(closeness(g, mode="all"))
closeness(g, mode="total")
closeness(g, mode="out")

##중개중심성,  cutoff(사이중앙성을 계산할 때 고려하는 최대 path길이)
estimate_betweenness(g, vids = V(g), directed = TRUE, cutoff=10, weights = NULL)
betweenness(g)
#다른 함수
betweenness(g)
which.max(degree(g))
which.min(degree(g))

## Eigenvector Centrality
eigen_centrality(g)$vector

## 아이젠벡터 가장큰값 보기
which.max(eigen_centrality(g)$vector)

######################################2부네트워크및커뮤니티탐지#######################################
library("igraph")
library(RColorBrewer)
setwd('C://R_data')
result <- read.csv("stock.csv")

## 주식네트워크 생성하기
g <- graph.data.frame(result, directed=FALSE)

## 상관계수에 절대값을 기준으로 0.6이하인건 지우기
g2 <- delete.edges(g,E(g)[abs(weight) < 0.6])

## 연결선이 하나도 없는 노드를 선택 degree가 연결된 정도
Isolated <-  which(degree(g2)==0)
Isolated
g2 <- delete.vertices(g2, Isolated)

## Community 탐지
edge.betweenness.community(g2)

## 각 주식별로 멤버십 추출, 어느 커뮤니티에 속하는지 표시
edge.betweenness.community(g2)$membership

## 커뮤니티별 소속 노드 수 구하기
table(edge.betweenness.community(g2)$membership)

cColors <- brewer.pal(nlevel(), name = "Spectral")
cColors <- brewer.pal(11, name = "Spectral")

length(cColors)
cColors

## 커뮤니티가 24개이므로 이중에서 멤버의 수 2개 초과만 추출 
major_cluster <- which(table(edge.betweenness.community(g2)$membership)>2)
major_cluster
table(edge.betweenness.community(g2)$membership)

## 2개 초과만 true값 
table(edge.betweenness.community(g2)$membership)>2

## 2개 초과값만 위치 표시
which(table(edge.betweenness.community(g2)$membership)>2)

## 커뮤니티가 24개이므로 이중에서 멤버의 수가 2 이상인 것들만
cColors <- brewer.pal(length(major_cluster), name = "Spectral")

cColors

## 색이 들어있는 벡터 요소의 이름을 커뮤니티 번호로 설정해서 멤버십에 일치하는 노드에만 색 설정
names(cColors) <- major_cluster

c_rslt <- edge.betweenness.community(g2)
cColors[c_rslt$membership]

plot.igraph(g2, layout=layout.auto, vertex.size=4, vertex.label=NA, edge.arrow=NA, edge.width=1)


## 커뮤니티 별 색을 다르게 시각화
plot.igraph(g2, layout=layout.auto, vertex.size=4, vertex.label=NA, edge.arrow=NA, vertex.color=cColors[c_rslt$membership])

## community 분석결과와 그래프를 동시에 넣으면 아래와 같이 커뮤니티 를 동시에 시각화함 
plot(c_rslt, g2)


#############################################네트워크 구조분석2#########################################
setwd("C://R_data")
library(igraph)


# 인접행렬을 네트워크로 만들기 
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


## 인접행렬 생성 undirected하면 방향 표시 x
g <- graph_from_adjacency_matrix(L, mode="directed")
plot(g, edge.arrow.size=0.5)

## 상호 호혜성
reciprocity(g)

##  Mutual, asymmetric, and null node pairs, dyad : 두 노드의 관계 
dyad_census(g)$mut # 상호주고받는 관계
dyad_census(g)$asym # 한쪽으로만 가는 관계
dyad_census(g)$null # edge가 없는 node 쌍

# 그래프의 edge 카운트 
ecount(g)

2*dyad_census(g)$mut/ecount(g)




l <- matrix(c(0,1,1,1,
              1,0,1,0,
              1,1,0,1,
              1,0,1,0), nrow=4)
library(igraph)
g1 <- graph_from_adjacency_matrix(l, mode="directed")
transitivity(g1)



result <- read.csv("stock.csv")
## 주식네트워크 생성하기
g <- graph.data.frame(result, directed=FALSE)
delete.edges(g, E(g)[weight < 0.8])
## 상관계수에 절대값을 기준으로 0.6이하인건 지우기
g2 <- delete.edges(g,E(g)[abs(weight) < 0.6])

## 연결선이 하나도 없는 노드를 선택 degree가 연결된 정도
Isolated <-  which(degree(g2)==0)
Isolated
g2 <- delete.vertices(g2, Isolated)

# 노드의 수
length(V(g2))

# 링크의 수수
length(E(g2))

## edge 밀도확인
edge_density(g2)

## 클러스터가 얼마나 연결되어있는지(Clustering Coefficient) 
transitivity(g2)

## 상호(여러단계를 통해)도달 가능한 노드들의 집합
components(g2)

## 직접연결가능한 노드들의 집합
cliques(g2)


## 클리크 길이가 큰순으로 정렬
sort(sapply(cliques(g2), length), decreasing = TRUE)

## 가장 많은 구성원을 가진 클리크 추출 
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


###########################################랜덤네트워크#########################

##랜덤네트워크 생성(n 노드수, p.or.m edge 연결확률) erdos.renyi.game(n, p.or.m = )
library(igraph)

g <- erdos.renyi.game(1000, 1/1000)
degree(g)

## 분포확인
degree_distribution(g)
plot(g)
plot(g, vertex.size=0.2, vaertex.label=NA)


## watts.strogatz.game(격자의 차원, 노드수, 이웃연결수)
n <- 50 # 노드 수
p <- 0.1 # 교체확률
nei <- 2 #연결 이웃 수

set.seed(1234)
G <- simplify(watts.strogatz.game(1,n,nei,p))

## 단순화 x
m <- watts.strogatz.game(1,n,nei,p)

plot(m, layout=layout.circle, vertex.size=4)
plot(G, layout=layout.circle, vertex.size=4)
