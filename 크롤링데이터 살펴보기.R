library(igraph)
setwd("C://R_data")

England <- read.csv("England.csv")
Spain <- read.csv("Spain.csv")
Germany <- read.csv("Germany.csv")
total <- rbind(England, Spain, Germany)

England_gf <- graph.data.frame(England)
Spain_gf <- graph.data.frame(Spain)
Germany_gf <- graph.data.frame(Germany)
total_gf <- graph.data.frame(total)

# 잉글랜드
sort(degree(England_gf), decreasing = TRUE)
sort(closeness(England_gf), decreasing = TRUE)
sort(betweenness(England_gf), decreasing = TRUE)
sort(eigen_centrality(England_gf)$vector, decreasing = TRUE)

# 스페인
sort(degree(Spain_gf), decreasing = TRUE)
sort(closeness(Spain_gf), decreasing = TRUE)
sort(betweenness(Spain_gf), decreasing = TRUE)
sort(eigen_centrality(Spain_gf)$vector, decreasing = TRUE)

# 독일
sort(degree(Germany_gf), decreasing = TRUE)
sort(closeness(Germany_gf), decreasing = TRUE)
sort(betweenness(Germany_gf), decreasing = TRUE)
sort(eigen_centrality(Germany_gf)$vector, decreasing = TRUE)

# total
sort(degree(total_gf), decreasing = TRUE)
sort(closeness(total_gf), decreasing = TRUE)
sort(betweenness(total_gf), decreasing = TRUE)
sort(eigen_centrality(total_gf)$vector, decreasing = TRUE)
