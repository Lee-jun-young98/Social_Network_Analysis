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

table(edge.betweenness.community(g2)$membership)

cColors <- brewer.pal(nlevel(), name = "Spectral")
cColors <- brewer.pal(11, name = "Spectral")

length(cColors)
cColors

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
