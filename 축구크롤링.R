library(rvest)
library(httr)
library(dplyr)
library(urltools)
library(stringr)
library(tidygraph)
library(ggraph)
library(igraph)
setwd("C://R_data")

res <- GET(url='https://www.transfermarkt.com/premier-league/transfers/wettbewerb/GB1/plus/?saison_id=2019&s_w=&leihe=1&intern=0&intern=1')

Sys.setlocale("LC_ALL", "English")
html <- read_html(res, encoding='UTF-8')

team1 <- c()
move1 <- c()
team2 <- c()
move2 <- c()
value1 <- c()
value2 <- c()

result1 <- c()
result2 <- c()

for (i in 4:23) {
  span1 <- html_nodes(x=html, xpath=paste0('//*[@id="main"]/div[11]/div[1]/div[',as.character(i),']/div[2]/table')) %>% html_table()
  span2 <- html_nodes(x=html, xpath=paste0('//*[@id="main"]/div[11]/div[1]/div[',as.character(i),']/div[4]/table')) %>% html_table()

  a <- c(span1[[1]][8])
  a <- a$Left
  b <- c(span2[[1]][8])
  b <- b$Joined
  d <- as.data.frame(c(span1[[1]][6]))
  d <- gsub("m", "00", d$Market.value)
  d <- gsub("Th.","0",d)
  d <- gsub("\\D","",d)
  e <- as.data.frame(c(span2[[1]][6]))
  e <- gsub("m", "00", e$Market.value)
  e <- gsub("Th.","0",e)
  e <- gsub("\\D","",e)
  
  move1 <- c(move1,a)
  team1 <- c(team1,rep(i,length(a)))
  value1 <- c(value1, unlist(d))
  move2 <- c(move2,b)
  team2 <- c(team2,rep(i,length(b)))
  value2 <- c(value2, unlist(e))
}


teamname <- c('Manchester City','Liverpool FC','Chelsea FC','Tottenham Hotspur','Arsenal FC','Manchester United','Wolverhampton Wanderers','Everton FC','Leicester City','West Ham United','Watford FC','Crystal Palace','Newcastle United','AFC Bournemouth','Burnley FC','Southampton FC','Brighton & Hove Albion','Norwich City','Sheffield United','Aston Villa')


result1 <- data.frame(FROM=move1,TO=team1, value = as.numeric(value1))
result2 <- data.frame(FROM=team2,TO=move2, value = as.numeric(value2))


for(i in 4:23) {
  result1$TO <- ifelse(result1$TO==i,teamname[i-3],result1$TO)
}

for(i in 4:23) {
  result2$FROM <- ifelse(result2$FROM==i,teamname[i-3],result2$FROM)
}

total <- rbind(result1, result2)
total <- total %>% subset(value != 0)

fg <- as_tbl_graph(total, directed=TRUE)
# class(fg)

write.csv(total, "England.csv", row.names=F, fileEncoding="EUC-KR")

plot(fg,vertex.size=2,vertex.label=NA, edge.width=2 + fg$value/10, edge.arrow.width = fg$value/100,layout=layout.fruchterman.reingold,edge.arrow.size=0.5)

