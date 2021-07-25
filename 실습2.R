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
