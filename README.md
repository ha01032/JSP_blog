# JSP 프로젝트: 블로그
Lang : JSP <br/>
IDE : Eclipse(Enterprise Java 22.12 ver) <br/>
Sturcture : MVC 모델2 구조<br/>
Database : MySQL<br/>
Server : Tomcat 9.0<br/><br/>

**실행방법** : 해당 설정들을 다 완료한 후 실행
1. 붙여넣기 : Eclipse(Enterprise java 22.12 ver. 기준)에 blog로 Dynamic Web Project를 만들고, java src에 com폴더 넣고, web-app에 META-INF제외 다 붙여넣기. META-INF 안의 context.xml 복사하고 붙여넣기 
2. Eclipse UTF-8 언어설정 : Window > Preferences에 들어가서 encoding을 검색한 후 각각 설정
3. 서버 설정 : Tomcat 9.0으로 설정(다른 버전을 해도 큰 문제는 없음)
4. 데이터베이스 설정 : context.xml에서 데이터베이스 유저 아이디 비번만 수정/ mysql에 해당 유저로 들어간후 **테이블세팅.txt** 내용을 복사해서 전부 실행
5. 라이브러리 설정 : Configure Build Path에 들어가서 Server-Runtime 삭제후 다시 추가/ J-Unit(5버전) 추가 <br/>
6. 브라우저 설정 : Window > Web Browser에 들어가서 Chrome으로 설정<br/>
7. 프로필 사진 업로드 오류 해결 : webapp에 media 폴더 추가한 후, UserProfileAction.java의 내용 전부를 잘라내기 한 후 다시 붙여넣어서 저장

## 기획의도
해당 소스가 JSP의 MVC 모델 2 구조로 된 소스여서 해당 구조를 학습하고자 클론코딩 하게됨.  

[클론코딩출처] : https://github.com/111coding/jsp-Model2-MySQL-blog
<br/><br/>
## 사이트 설명
![20230111_083029](https://user-images.githubusercontent.com/117807082/211684132-87d0c0b6-709a-4da8-a5fd-fec654e80605.png)
  
**블로그** : JOIN을 통해 회원가입/LOGIN을 통해 로그인 한 후, POSTING를 통해 글을 포스팅할 수 있으며, Read More을 통해 그 글에 들어가면 댓글 및 대댓글을 달 수 있어서 서로 편하게 소통할 수 있는 사이트
 <br/><br/>
 **블로그 개요:** 
 + 회원가입/로그인 
 + 회원정보/프로필 사진 변경
 + 글 포스팅 : cloudflare에서 제공하는 summernote를 통해 자유로운 사진/동영상/유튜브링크/표 삽입 및 폰트설정 가능
 + 게시글에 대한 댓글/대댓글
 + 인기 게시글 표시/글 검색 기능
 <br/><br/><br/> 
## 해당 파일의 동작원리


### 구조
![20230110_182758](https://user-images.githubusercontent.com/117807082/211515832-4d498662-a6e3-4067-92ba-54ea8cf0afc5.png)
<br/><br/>
위 그림과 같이 

### 동작 원리 

###  기능
<br/><br/><br/>

## 이슈 및 해결책
1. ㅇ 
2. ㅇ
3. ㅇ


## 추가 구현한 기능
1. ㅇ
2. ㅇ<br/><br/><br/>

## 아쉬운점 및 추가하고 싶은 기능
: 늦게 시작하고 꼼꼼한 코드 분석에 치중하는 바람에 기능 구현을 거의 하지 못하고, 그러한 기능 구현을 통한 학습의 계기가 되지 못한점이 아쉬움.

### 추가하고 싶은 기능
+ ㅇ
+ ㅇ
+ ㅇ
+ ㅇ

## 작업후기
ㅇ
