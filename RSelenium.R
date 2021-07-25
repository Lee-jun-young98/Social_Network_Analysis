## 크롤링 패키지
library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)


## 4445번 포트와 크롬을 연결 시켜준다.
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port=4445L,
  browserName="chrome"
)

## open을 통해 크롬 웹창을 연다.
remDr$open()

## 크롤링하고자하는 사이트 주소르 입력해 해당 주소로 이동한다.
remDr$navigate('https://m.naver.com')

#검색창 위치를 찾아 search라는 변수에 할당
search <- remDr$findElement(using = 'css selector', value='#MM_SEARCH_FAKE')

# search변수에 코로나를 치도록 조종
search$sendKeysToElement(list("코로나"))

# 검색 버튼의 위치를 찾아 button이라는 변수에 할당
button <- remDr$findElement(using='css selector', value='.sch_submit.MM_SEARCH_SUBMIT')

# 검색버튼에 대고 enter를 입력
button$sendKeysToElement(list(key="enter"))




## close를 통해 닫는다.
remDr$close()
