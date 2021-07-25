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
jColors <- brewer.pal(nlevels(color), name="Spectral")
names(jColors) <- unique(stock_code$group)
jcolors <- jColors[V(g2)$type]

## 범례추가
plot.igraph(g2, layout=layout.auto, vertex.size=10, edge.arrow=NA, edge.width=1, edge.curved=TRUE, vertex.label.size=4, vertex.label.cex=1,vertex.color=jcolors)
legend(x=-1.4,y=1.8,names(jColors),pch=21, pt.bg=jColors, pt.cex=2, cex=.8, bty='n', ncol=1)


## 거리중심성
sort(degree(g2), decreasing = TRUE)
sort(closeness(g2, mode="all"), decreasing = TRUE)
sort(betweenness(g2), decreasing = TRUE)
