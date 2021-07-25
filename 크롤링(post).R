library(httr)
library(dplyr)
library(rvest)
res <- GET(url = "https://datalab.naver.com")

print(x=res)

status_code(x=res)

content(x=res, as="text",encoding = "UTF-8") %>% cat()

html <- read_html(x=res)

span <- html_nodes(x=html, css="a.list_area")

searchWords <- html_text(x=span)

span <- html_nodes(x=html, css="a.list_area>span.title")

# 현재 컴퓨터에 설정된 로케일에 따른 한글 인코딩 방식 확인
localeToCharset()

text <- "안녕하세요?"
print(x=text)

## 문자열 인코딩확인
Encoding(x=text)

# 한글 인코딩 방식을 UTF-8로 설정
Encoding(x=text) <- 'UTF-8'
Encoding(x= text)

# text객체 출력
print(x=text)

# Windows에서는 CP949 / EUC-KR로 설정
Encoding(x=text) <- 'CP949'
Encoding(x=text)

print(x=text)

# 문자열의 인코딩 방식을 변경할려면 iconv() 함수 사용

# CP949를 EUC-KR로 변경
iconv(x = text, from = 'CP949', to = 'EUC-KR')

# CP949를 UTF-8로 변경
iconv(x = text, from = 'EUC-KR', to = 'UTF-8')

# UTF-8을 CP949로 변경
iconv(x = text, from = 'UTF-8', to = 'CP949')

# CP949를 ASCII로 변경
iconv(x = text, from = 'CP949', to = 'ASCII')


## 퍼센트인코딩
strEx2 <- '%EC%9B%B9%ED%81%AC%EB%A1%A4%EB%A7%81'

## UTF8 인코딩이라 windows에서는 깨짐
strEx2 %>% url_encode()
strEx2 %>% url_encode() %>% iconv(from = 'UTF-8', to = 'EUC-KR')


## 크롬브라우저에서 URL복사
URL <- 'http://www.isuperpage.co.kr/search.asp'

string <- '%C0%CF%BD%C4'
string %>% url_encode()

# 도시명을 '서울'로 지정하고 퍼센트 인코딩
cityNm <- '서울'

cityNm %>% url_encode()

library(urltools)
# 퍼센트 인코딩 POST() 함수의 body인자에 할당할 검색어 지정
upjong <- '중식'
cityNm <- '서울'
guNm <- '강남구'

res <- POST(url=URL,
          body = list(searchWord = upjong %>% 
                        url_encode() %>% 
                        I(),
                      city = cityNm %>% 
                        url_encode() %>% 
                        I(),
                      gu = guNm %>% 
                        url_encode() %>% 
                        I()),
                      encode = 'form')
print(x=res)

res %>% as.character() %>% cat()

## 업체명 추출하기 
store <- res %>% 
  read_html() %>% 
  html_nodes(css='div.tit_list a.l_tit') %>% ## 상위태그와 하위태그는 띄어쓰기 넣고 붙여씀
  html_text()
print(x=store)

store <- res %>% 
  read_html() %>% 
  html_nodes(css = 'a.l_tit') %>% 
  html_text()

print(x=store)

number <- res %>% 
  read_html() %>%
  html_nodes(css = "div.l_cont span.phone") %>% 
  html_text

print(x=number)

address <- res %>% 
  read_html() %>% 
  html_nodes(css = "div.l_cont2 span.loadv") %>% 
  html_text

print(x=address)

df <- data.frame(store, number, address)
view(df)
View(df)
