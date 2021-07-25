library(httr)
library(rvest)
library(urltools)

# POST() 함수의 body 인자에 할당할 검색어 지정
upjong <- '일식'
cityNm <- '서울'
guNm <- '강남구'

source(file = 'C:/R_data/pctEncodingFuns.R')

res <- GET(url='http://www.isuperpage.co.kr/search/s_pagedata_page.asp',
           query=list(searchWord = upjong %>% pcntEncoding2Euckr(),
                      city=cityNm %>% pcntEncoding2Euckr(),
                      gu=guNm %>% pcntEncoding2Euckr(),
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

