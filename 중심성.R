L=matrix(c(0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0), byrow=T, nrow=9)
library(igraph)
g <- graph_from_adjacency_matrix(L)
plot(g)
plot(g, edge.arrow.size=0.5)

## centr_degree를 이용해 각 노드의 중심성을 산출
#centr_degree(graph, mode = c("all","out", "in"), loops = TRUE, normalized = TRUE)

# res는 각 노드의 in/out degree를 구한 것, cen그려져 있는 것의 비율, theoretical 네크워크 수준의 값을 계산한 것 
centr_degree(g, mode="all")

## 근접중심성 함수
closeness(g, mode="all")
closeness(g, mode="total")
closeness(g, mode="out")

##중개중심성,  cutoff(사이중앙성을 계산할 때 고려하는 최대 path길이)
estimate_betweenness(g, vids = V(g), directed = TRUE, cutoff=10, weights = NULL)

#다른 함수
betweenness(g)



## Eigenvector Centrality
eigen_centrality(g)
which.max(eigen_centrality(g)$vector)
