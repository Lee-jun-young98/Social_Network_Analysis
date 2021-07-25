#################바라바시 네트워크####################
library(igraph)
# barabasi albert 네트워크 모의 생성 
n <- 50
G <- barabasi.game(n, directed = F)
plot(G, layout = layout.fruchterman.reingold, vertex.size=4)

n <- 500
G <- barabasi.game(n, directed = F)
plot(G, layout = layout.fruchterman.reingold, vertex.size=4)
plot(G, layout = layout.fruchterman.reingold, vertex.size=4, vertex.size = 4, vertex.label = "")
table(degree(G))

# 멱함수 분포 Long-tail
plot(table(degree(G)))

################################### 웹크롤링1##############################
library(httr)


## httr은 HTTP 요청 및 응답에 관한 작업에 사용되는 패키지 
# HTTP 요청에 관함 함수 : GET(), POST(), user_agent(), add_headers(), set_cookies()
# HTTP 응답에 관한 함수 : status_code(), content(), cookies(), headers()
# HTTP 응답에 성공하지 못했을 때 사용하는 함수들 : warn_for_status(), stop_for_status()

# GET 방식의 HHTTP 통신이 사용된 경우, GET() 함수를 사용한다.
# url 인자에 웹 페이지의 URL 부분을 할당하고, query 인자에 query string을 list형태로 할당한다.
res <- GET(url = 'https://section.blog.naver.com/BlogHome.nhn?directoryNo=0&currentPage=1&groupld=0')

res <- GET(url = 'https://section.blog.naver.com/BlogHome.nhn',
           query = list(directoryNo = 0,
                        currentPage = 1,
                        groupld = 0))

# http 응답결과 한번에 출력
print(x=res)

## http 응답상태코드만 출력
status_code(x=res)

# HTTP 응답 바디(HTML)를 텍스트 형태로 출력하여 육안으로 확인
# type과 encoding 인자는 추가하지 않아도 자동으로 설정된다.
# 하지만 encoding 인자는 상황에 따라 반드시 추가해야 하는 경우가 있습니다.
content(x=res, as='text', type='text/html', encoding = 'EUC-KR')


# URL을 GET() 함수의 url 인자에 할당하여 HTTP요청을 실행하고, 그 결과를 res 객체에 할당 
res <- GET(url='https://www.naver.com')

# HTTP 응답 결과확인을 위해 res 객체를 출력한다.
print(x=res)

# HTTP 응답상태 코드를 확인
status_code(x=res)

# res객체에 포함된 바디(HTML)을 텍스트로 출력한다.
content(x=res, as='text', encoding = "UTF-8")


############################### 크롤링 rvest ##################################################
# 데이터를 수집할 때 사용하는 패키지 rvest
library(rvest)
library(dplyr)
library(httr)

# 응답 객체를 HTML로 변환하는 함수 : read_html()
# HTML 요소를 추출하는 함수 : html_node(), html_nodes()
# HTML 속성에 관련된 함수 : html_attr(), html_attrs(), html_name()
# 데이터를 추출하는 함수 : html_text(), html_table()


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

############################################인코딩, 크롤링(post)#######################################################
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

# EUC-KR UTF-8로 변경
iconv(x = text, from = 'EUC-KR', to = 'UTF-8')

# UTF-8을 CP949로 변경
iconv(x = text, from = 'UTF-8', to = 'CP949')

# CP949를 ASCII로 변경
iconv(x = text, from = 'CP949', to = 'ASCII')


# Sys.getlocale() 현재 설정된 로케일을 확인

library(urltools)
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
guNm <- '중구'

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


############################################크롤링 post2################################################
library(httr)
library(rvest)
library(urltools)
# 페이지를 달리해도 URL이 바뀌지 않는 경우에 사용
# 크롬개발자 도구에서 관련 URL과 Parameters를 찾아 지정해주어야 함
# 웹 브라우저의 주소창에서 보이는 URI로는 원하는 결과를 얻을 수 없음
# POST() 함수의 body 인자에 할당할 검색어 지정
upjong <- '일식'
cityNm <- '서울'
guNm <- '강남구'

source(file = 'C:/R_data/pctEncodingFuns.R')

res <- GET(url='http://www.isuperpage.co.kr',
           query=list(searchWord = upjong,
                      city=cityNm,
                      gu=guNm,
                      page='2'))

print(res)

res %>% content(as='text', encoding='EUC-KR') %>% cat()



library(jsonlite)

json <- res %>% content(as='text', encoding='EUC-KR') %>% fromJSON()
str(json)


pages <- (json$totalCount %>% as.numeric()) / json$pageSize %>% as.numeric() %>% ceiling()
# 반복문 실행
result <- data.frame()

for (i in 1:pages) {
  res <- GET(url='http://www.isuperpage.co.kr/search/s_pagedata_page.asp',
             query=list(searchWord = upjong %>% pcntEncoding2Euckr(),
                        city=cityNm %>% pcntEncoding2Euckr(),
                        gu=guNm %>% pcntEncoding2Euckr(),
                        page=i))
  # 현재 진행상황 출력
  cat('현재',i,'번째 실행 중입니다. 응답 상태코드는 ', status_code(x= res), '입니다. \n')
  
  # 응답 메시지 바디에 있는 JSON 데이터를 변환하여 json 객체에 저장합니다.
  json <- res %>% content(as = 'text', encoding = 'EUC-KR' %>% fromJSON())
  
  # 4번째 원소인 데이터프레임만 추출합니다.
  df <- json$poiList
  
  # 결과 객체에 rbind로 추가합니다.
  result <- rbind(result, df)
  
  # 서버에 부하가 되지 않도록 1초간 멈춥니다.
  Sys.sleep(time = 1)
}

# 결과 객체의 구조를 파악합니다.
str(object = result)




######################### RSelenium ###########################################
library(RSelenium)
library(wdman)
library(dplyr)

# wdman 패키지의 chrome() 함수를 이용해 크롬 드라이브 설정
chrome <- wdman::chrome(port = 4567L)
# Rselenium 패키지의 remoteDriver() 함수를 이용해 리모트 드라이버 설정
remote <- remoteDriver(port = 4567L, browserName = 'chrome')

# 새로운 리모트 브라우저 열기
remote$open()

# 리모트 웹브라우저 닫기
remote$close()

# 여러개의 창이 열려 있는 경우, 현재 창 닫기
remote$closeWindow()

# 리모트 웹브라우저가 열리면 원하는 웹 사이트 접속
remote$navigate(url = "https://www.naver.com")

# JavaScript 같은 동적인 기능도 가져올 수 있다.
html <- remote$getPageSource() %>% '[['(1)


# 요소 찾기, xpath로 지정
query <- remote$findElement(using = 'xpath', value = '//*[@id="query"]')

# 요소 찾기, CSS selector로 지정
query <- remote$findElement(using = 'css selector', value = '#query')


# 네이버 검색창에 검색어를 입력
query$sendKeysToElement(sendKeys = list('hi'))

# 돋보기 버튼 클릭
queryBtn <- remote$findElement(using = 'xpath', value = '//*[@id="search_btn"]')
queryBtn$clickElement()

# 페이지 뒤로 이동
remote$goBack()

# 페이지 앞으로 이동
remote$goForward()

# 페이지 새로고침
remote$refresh()


# 창이동 및 팝업 제거
windowlds <- remote$getWindowHandles()
pipup <- remote$switchToWindow(windowld = windowld[[2]])
closeBtn <- remote$findElement(using = 'xpath', value = '해당 버튼')
closeBtn$clickElement()

# 경고 확인 및 제거 
# 경고 문구 출력
remote$getAlertText()

# 경고를 수용한다.
remote$acceptAlert()

# 경고를 무시한다.
remote$dismissAlert()



#######################user-agent 설정##############################33
res <- GET(url = "https://datalab.naver.com")
ua <- 'User-agent 문자열'
res <- GET(url = "https://datalab.naver.com",
           user_agent(agent=ua))
print(x=res$request$options$useragent)


# 쿠키 얻기
cookies(x=res)

myCookies <- cookies(x=res) %>% unlist()


res <- POST(ulr = 'https://www.jobplanet.co.kr/users/sign_in',
            body = list('user[email]' ='본인 아이디',
                        'user[password]' = '패스워드'))

# 로그인 쿠키 설정
myCookies <- set_cookies(.cookies = unlist(x = cookies(x=res)))

# 수집할 기업명 저장
compNm <- '삼성화재해상보험'

# 쿠키를 이용하여 로그인 상태를 유지한 채로 HTTP 요청 실행
res <- GET(url = URL, config = list(cookies = myCookies))



## 아이디 입력 채우기
id <- remDr$findElement(using = 'css', value = 'input#id.int')

# 아이디 입력
id$sendKeysToElement(sendKeys = list("본인아이디"))

# refer를 추가하여 해당 URL을 크롤링 하려고한다 틀린 부분을 찾아 고치시오
# res <- GET(url = '해당URL', add_referer(referer = '해당referer'))
# add_referer -> add_headers

# AJAX는 웹 서버와 통신할 때 웹 페이지 전체를 새로고침하는 대신, 특정 부분의 데이터만 웹 서버로부터 내려받아 웹 브라우저에 보여주므로 경제적이다. -> 참

# 아래 그림에서 태그와 태그 사이에 있는 텍스트 부분(예를 들면 어쩌다 가족)을 전부 추출하려고 한다.
html <- read_html(x=res)
span <- html_nodes(x=html, css = 'span.item_title')

# CSS에서 속성명이 class인 태그를 선택할 때 사용하는 표현식은? .


# 한글 인코딩 방식 중 윈도우 운영체제는 UTF-8 방식을 사용한다. 거짓 (CP-949 사용)

reslist <- list()
for (i in 1:10) {
  res <- GET(url='https://www.sch.ac.kr/bigdatanews.nhn&page=', query = list(page=i))
  reslist <- res
}

# myCookies에 쿠키를 저장하였다면 다른 웹페이지에 HTTP 요청할 때 쿠키를 추가하여 로그인 상태의 HTML을 얻을 수 있고자 한다. 빈칸을 채우시오
res <- GET(url = '관심있는 웹페이지의 URL',
           set_cookies(.cookies = myCookies))

# 웹사이트에 방문했을 때 웹 서버가 클라이언트 컴퓨터에 저장해놓은 작은 파일을 쿠키라고 한다.

# 다음의 html에서 삼성전자의 링크를 가져올려고 한다.
temp2 <- res %>% 
  read_html(encoding = 'EUC-KR') %>% 
  html_node(css = 'td.ctg a') %>% 
  html_attr("href")


# R소프트웨어를 이용하여 웹브라우저를 제어하기 위한 패키지명
library(RSelenium)
library(wdman)


# ","가 붙이있는 데이터를 수치형 변수로 변경 
numeric_fn <- function(x) {
  x <- as.numeric(gsub(",","",x))
}

# 우리가 웹브라우저를 통해 네이버에 홈페이지를 접속하여 내용을 볼 수 있는 것은 네이버 서버에서 html 컨텐츠를 우리 피씨로 전송했기 때문이다. 참
# URL에 문자를 표현하는 인코딩방식을 퍼센트인코딩이라고 한다.
# res <- GET(url = 'https://section.blog.naver.com/BlogHome.nhn', query = list)
# 하이퍼링크를 통해 어떤 한사이트에서 다른 사이트로 이동한다고 했을 때, 새로 열린 사이트에 이전 사이트의 URI를 전송하는데 이것을 referer라고 한다.


############## 블로그 크롤링############################3
library(httr)
library(rvest)
library(tidyverse)


res <- GET(url = 'https://section.blog.naver.com/BlogHome.nhn',
           query = list(directoryNo = '0',
                        currentPage = '1',
                        groupld = '0'))

# 블로그 제목을 포함하는 HTML 요소 추출
res %>% read_html() %>% 
  html_nodes(css = 'strong.title_post') %>% 
  html_text()

#############################json referer##################################
library(jsonlite)
library(stringr)
ref <- 'https://section.blog.naver.com/BlogHome.nhn'
res <- GET(url = 'https://section.blog.naver.com/ajax/DirectoryPostList.nhn',
           query = list(directorySeq = '0',
                        pageNo = '1'),
           add_headers(referer = ref))
print(x = res)

# JSON 데이터 추출
res %>% as.character() %>% fromJSON()
res %>% content(as = 'text') %>% str_sub(start = 1, end = 100) %>% cat()
json <- res %>% as.character() %>% str_remove(pattern = "\\)\\]\\}\\',") %>% fromJSON()
str(object = json)

# 데이터프레임을 blog에 지정한 다음 출력
blog <- json$result$postList
print(x = blog)
str(blog)


###################################네이버 카페 크롤링########################
# 포트 지정
port <- 4567L

# 웹드라이버 시작
chrome <- wdman::chrome(port = port)

# 리모트 드라이버 설정
remote <- remoteDriver(port = port, browserName = 'chrome')

# 리모트 웹 브라우저 열기
remote$open()

# 네이버 모바일로 이동
remote$navigate(url = 'https://www.naver.com')

# 로그인 버튼 저장
login <- remote$findElement(using = 'xpath', 
                            value = '//*[@id="account"]/a')

login$clickElement()

# 아이디 입력창 지정
id <- remote$findElement(using ='xpath', value = '//*[@id="id"]')
id$sendKeysToElement(sendKeys = list('tfg0074'))

# 비밀번호 입력창 지정
pw <- remote$findElement(using = 'xpath', value = '//*[@id="pw"]')
pw$sendKeysToElement(sendKeys = list("cas72533"))

# 로그인 버튼
login <- remote$findElement(using = 'xpath', value = '//*[@id="log.login"]')
login$clickElement()



# 중고나라
remote$navigate(url = 'https://cafe.naver.com/joonggonara')

login <- remote$findElement(using = 'xpath', value = '//*[@id="menuLink57"]')
login$clickElement()

remote$switchToWindow(remote$getWindowHandles)
remote$switchToFrame("cafe_main")

login <- remote$findElement(using = 'xpath', value = '//*[@id="upperArticleList"]/table/tbody/tr[1]/td[1]/div[2]/div/a')
login$clickElement()

# iframe 다가지고 오기
res <- remote$getPageSource() %>% '[['(1)
str(res)
cat(res)

body <- res %>% 
  read_html() %>% 
  html_nodes(css = 'a.article') %>% 
  html_text(trim = TRUE)

body
