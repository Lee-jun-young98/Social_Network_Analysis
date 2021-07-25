library(rvest)
library(dplyr)
library(httr)

res <- GET(url="https://datalab.naver.com/")
print(x=res)

status_code(x=res)

## 계층구조로 출력하기 위해 cat() 사용
content(x=res, as='text', encoding="UTF-8") %>% cat()

## http 응답객체에서 html 읽기
html <- read_html(x=res)

## HTML에서 css로 필요한 요소만 선택
span <- html_nodes(x=html, css='a.list_area')

# 실시간 검색어만 추출
searchWords <- html_text(x=span)

# 최종결과 출력
print(x=searchWords)


## html에서 css로 필요한 요소만 선택
span <- html_nodes(x=html, css='a.list_area>span.title')

# 실시간 검색어만 추출 
searchWords <- html_text(x=span)
searchWords

# 파이프연산자를 이용해 간단하게 보여주기
searchWords <- res %>% read_html() %>% html_nodes(css='a.list_area>span.title') %>% html_text()

# span.title이 적용된 부분이 검색어 밖에 없으므로 동일
searchWords <- res %>% read_html() %>% html_nodes(css='span.title') %>% html_text()
