setwd("D://kospi200")

## 크롤링 패키지
library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)
library(stringr)

## 4445번 포트와 크롬을 연결 시켜준다.
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port=4445L,
  browserName="chrome"
)
## open을 통해 크롬 웹창을 연다.
remDr$open()
########################################################상위 200개 이름 추출##############################################################################
company_name <- c()
## 상위 100개 이름 추출
for (i in 1:10) {
  
  ## 코스피200 사이트로이동
  remDr$navigate("https://finance.naver.com/sise/sise_index.nhn?code=KPI200")
  
  
  ## 편입종목상위라는 iframe를 찾음
  frames <- remDr$findElements(using = "xpath", value="//*[@id='contentarea_left']/iframe[3]")
  
  
  ## 편입종목상위라는 iframe에 들어감
  remDr$switchToFrame(frames[[1]])
  
  ## 각페이지에 들어감
  frame_table <- remDr$findElement(using = "xpath", value=("/html/body/div/table[1]"))
  frame_page_table <- remDr$findElement(using = "xpath", value=paste0("/html/body/div/table[2]/tbody/tr/td[",i,"]/a"))$clickElement()
  
  frame_parse <- remDr$getPageSource()[[1]]
  
  frame_html <- frame_parse %>% read_html()
  
  Sys.setlocale("LC_ALL", "English")
  frame_top <- frame_html %>% html_table(fill=TRUE)
  Sys.setlocale("LC_ALL", "Korean")
  frame_top <- frame_top[[1]]
  frame_top <- frame_top[c(-1,-12,-13),]
  company_name <- c(company_name,unlist(frame_top[1], use.names=F))
  
}


## 상위 100개 이름 추출
for (i in 3:12) {
  
  ## 코스피200 사이트로이동
  remDr$navigate("https://finance.naver.com/sise/sise_index.nhn?code=KPI200")
  
  
  ## 편입종목상위라는 iframe를 찾음
  frames <- remDr$findElements(using = "xpath", value="//*[@id='contentarea_left']/iframe[3]")
  
  
  ## 편입종목상위라는 iframe에 들어감
  remDr$switchToFrame(frames[[1]])
  
  ## 각페이지에 들어감
  remDr$findElement(using = "xpath", value=("/html/body/div/table[2]/tbody/tr/td[11]/a"))$clickElement()
  
  frame_page_table <- remDr$findElement(using = "xpath", value=paste0("/html/body/div/table[2]/tbody/tr/td[",i,"]/a"))$clickElement()
  
  frame_parse <- remDr$getPageSource()[[1]]
  
  frame_html <- frame_parse %>% read_html()
  
  Sys.setlocale("LC_ALL", "English")
  frame_top <- frame_html %>% html_table(fill=TRUE)
  Sys.setlocale("LC_ALL", "Korean")
  frame_top <- frame_top[[1]]
  frame_top <- frame_top[c(-1,-12,-13),]
  company_name <- c(company_name,unlist(frame_top[1], use.names=F))
  
}
company_name
#####################################################################일별시세##########################################################################
h <- 0

## 1페이지부터 10페이지까지
for (j in 1:10) {
  for (k in 3:12) {
    for(l in 1:10) {
      
      ## 코스피200 사이트로이동
      remDr$navigate("https://finance.naver.com/sise/sise_index.nhn?code=KPI200")
      
      
      ## 편입종목상위라는 iframe를 찾음
      frames <- remDr$findElements(using = "xpath", value="//*[@id='contentarea_left']/iframe[3]")
      
      ## 편입종목상위라는 iframe에 들어감
      remDr$switchToFrame(frames[[1]])
      
      ## 편입종목상위 1페이지에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/div/table[2]/tbody/tr/td[",j,"]/a"))$clickElement()
      
      ## 삼성전자 차트에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/div/table[1]/tbody/tr[",k,"]/td[",j,"]/a"))$clickElement()
      Sys.sleep(10)
      
      ## 삼성전자 차트에서 시세 차트에 들어감
      remDr$findElement(using = 'xpath', value = "//*[@id='content']/ul/li[2]/a")$clickElement()
      Sys.sleep(15)
      
      ## 일별시세라는 iframe을 찾음
      frames_day <- remDr$findElements(using = 'xpath', value= '//*[@id="content"]/div[2]/iframe[2]')
      Sys.sleep(10)
      
      ## 일별시세라는 iframe에 들어감
      remDr$switchToFrame(frames_day[[1]])
      Sys.sleep(10)
      
      ## 일별시세 1페이지에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/table[2]/tbody/tr/td[",l,"]/a"))$clickElement()
      Sys.sleep(10)
      remDr$findElement(using = 'xpath', value = "/html/body/table[1]")
      
      ## 일별시세 페이지 저장
      page_parse <- remDr$getPageSource()[[1]]
      
      ## html로 불러오기
      page_html <- page_parse %>% read_html()
      
      ## encoding 문제로인해 영어로 바꾸었다가 다시 korean으로 불러오기
      Sys.setlocale("LC_ALL", "English")
      table <- page_html %>% html_table(fill=TRUE)
      Sys.setlocale("LC_ALL", "Korean")
      
      df <- data.frame()
      df <- as.data.frame(table[[1]])
      df <- df[-c(1,7,8,9,15),]
      rownames(df) <- c(seq(1:10))
      df$날짜 <- as.Date(df$날짜, format='%Y.%m.%d')
      
      ## numeric으로 변환하기 위한 , 제거 
      for (n in 2:ncol(df)){
        df[,n] <- gsub(",","",df[,n])
      }
      
      ## numeric으로 변환
      for (m in 2:ncol(df)){
        df[,m] <- as.numeric(df[,m])
      }
      
      df_all <- rbind(df_all,df)
      
      
    }
    h <- h+1
    write.csv(df_all, paste0(company_name[h],".csv"))
    df_all <- data.frame()
    
  }
  
}


######################################################일별시세 11페이지부터########################################################
for (j in 3:12) {
  df_all <- data.frame()
  for (k in 3:12) {
    for(l in 1:10) {
      
      ## 코스피200 사이트로이동
      remDr$navigate("https://finance.naver.com/sise/sise_index.nhn?code=KPI200")
      
      
      ## 편입종목상위라는 iframe를 찾음
      frames <- remDr$findElements(using = "xpath", value="//*[@id='contentarea_left']/iframe[3]")
      
      ## 편입종목상위라는 iframe에 들어감
      remDr$switchToFrame(frames[[1]])
      
      ## 편입종목상위에서 다음을 클릭
      remDr$findElement(using = "xpath", value=("/html/body/div/table[1]"))
      
      
      remDr$findElement(using = "xpath", value=("/html/body/div/table[2]/tbody/tr/td[11]/a"))$clickElement()
      
      ## 편입종목상위 11페이지에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/div/table[2]/tbody/tr/td[",j,"]/a"))$clickElement()
      Sys.sleep(10)
      
      ## 삼성전자 차트에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/div/table[1]/tbody/tr[",k,"]/td[",j,"]/a"))$clickElement()
      Sys.sleep(15)
      
      ## 삼성전자 차트에서 시세 차트에 들어감
      remDr$findElement(using = 'xpath', value = "//*[@id='content']/ul/li[2]/a")$clickElement()
      Sys.sleep(15)
      
      ## 일별시세라는 iframe을 찾음
      frames_day <- remDr$findElements(using = 'xpath', value= '//*[@id="content"]/div[2]/iframe[2]')
      Sys.sleep(15)
      
      ## 일별시세라는 iframe에 들어감
      remDr$switchToFrame(frames_day[[1]])
      Sys.sleep(10)
      
      ## 일별시세 1페이지에 들어감
      remDr$findElement(using = 'xpath', value = paste0("/html/body/table[2]/tbody/tr/td[",l,"]/a"))$clickElement()
      
      
      remDr$findElement(using = 'xpath', value = "/html/body/table[1]")
      
      ## 일별시세 페이지 저장
      page_parse <- remDr$getPageSource()[[1]]
      
      ## html로 불러오기
      page_html <- page_parse %>% read_html()
      
      ## encoding 문제로인해 영어로 바꾸었다가 다시 korean으로 불러오기
      Sys.setlocale("LC_ALL", "English")
      table <- page_html %>% html_table(fill=TRUE)
      Sys.setlocale("LC_ALL", "Korean")
      
      
      
      df <- as.data.frame(table[[1]])
      df <- df[-c(1,7,8,9,15),]
      rownames(df) <- c(seq(1:10))
      df$날짜 <- as.Date(df$날짜, format='%Y.%m.%d')
      
      ## numeric으로 변환하기 위한 , 제거 
      for (n in 2:ncol(df)){
        df[,n] <- gsub(",","",df[,n])
      }
      
      ## numeric으로 변환
      for (m in 2:ncol(df)){
        df[,m] <- as.numeric(df[,m])
      }
      
      df_all <- rbind(df_all,df)
      df_all
      
      
    }
    h <- h+1
    write.csv(df_all, paste0(company_name[h],".csv"))
    df_all <- data.frame()
  }
  
  
}


## 크롭웹창끄기
remDr$close()
