# JSP 프로젝트: 블로그
Lang : JSP <br/>
IDE : Eclipse(Enterprise Java 22.12 ver) <br/>
Sturcture : MVC 모델2 구조<br/>
Database : MySQL<br/>
Server : Tomcat 9.0<br/><br/>

**실행방법** : 해당 설정들을 다 완료한 후 실행
1. 붙여넣기 : Eclipse(Enterprise java 22.12 ver. 기준)에 blog로 Dynamic Web Project를 만들고, java에 com폴더 넣고, web-app에 META-INF제외 다 붙여넣기. META-INF 안의 context.xml 복사하고 붙여넣기 
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


### 구조 : MVC 모델2
![20230110_182758](https://user-images.githubusercontent.com/117807082/211515832-4d498662-a6e3-4067-92ba-54ea8cf0afc5.png)
<br/><br/>
해당 파일은 Model(M)/VIEW(V)/CONTROLLER(C)가 각각 분리된 MVC 모델2 구조를 이루고 있으며, 위 그림과 같은 방식으로 요청에 대한 응답을 처리한다. VIEW에서 특정 패턴의 링크를 통해 요청하면 그 패턴을 인식한 CONTROLLER가 해당 패턴에 특이적인 클래스 생성을 하고, MODEL을 통해 요청한 데이터 작업을 수행후 결과 VIEW를 던져줌으로서 응답한다.
1. VIEW 요청<br/>
뷰에서 특정 액션에 의해 href주소로 이동 요청을 한다. 이 때, href주소의 패턴이 "/blog/(......)? cmd = (cmd값) ...."과 같을 때, 아래의 과정이 이루어진다.

2. CONTROLLER 특이적 클래스 생성<br/>
com.cos.controller 패키지에 있는 '(......)Controller.java' 컨트롤러 파일들은 '@WebServlet("/(.......)") anotation을 통해 해당 "/(.......)"패턴을 포함한 주소에 대한 처리를 담당한다. 예를들어, 요청한 주소가 "/blog/board? cmd= ...." 형태일 경우, boardController에서 그 처리를 담당하는 것이다. 해당 컨트롤러 파일들은 각자 doGet/Post 메서드를 실행하고, 그 메서드는 com.cos.action.(.......) 패키지에 있는 '(.......)Factory.java' 객체를 생성하고, 그 객체에선 cmd값에따라 '(.......)(cmd값)Action.java' 객체를 생성하며 결론적으로 그 객체에 대해 execute메서드를 실행한다. 
3. MODEL을 통한 요청 데이터 작업<br/>
결국 요청한 주소의 (.....)값과 (cmd값)에 따라서 특이적인 컨트롤러로 이동해서 특이적인 '(.......)(cmd값)Action.java' 객체의 execute메서드를 실행하였고, 그 메서드는 특이적인 요청 데이터작업을 수행하게된다. 이때, 요청데이터 작업은 크게 'DB에서 데이터를 가져오는 작업'과 'DB에 입력한 데이터를 담는 작업' 2가지로 나눠진다. 'DB에서 데이터를 가져오는 작업'은 유일 객체인 DAO의 메서드를 통해 요청에 맞는 데이터를 선별해서 가져오고, 그것을 임시객체인 DTO에 담아서 Request에 set한다. 반대로 'DB에서 데이터를 가져오는 작업'에서는 Request의 데이터를 get해서 임시 객체인 DTO에 담고, 그 DTO를 유일 객체인 DAO의 메서드를 통해 요청에 맞는 데이터 업데이트를 수행한다.<br/>
이 때, DAO가 DB와의 연결통로이며, 이것은 DBConn클래스를 통해 연결객체를 생성하고, DBConn은 커넥션풀으로서 META-INF에 있는 content.xml의 DB연결정보로 연결한다.

4. 결과 VIEW 던져줌<br/>
doGet/Post 메소드는 위의 작업을 다 마친 후 결과 VIEW를 던져줌으로서 그 메소드 작업을 마친다. 이 때, 'DB에서 데이터를 가져오는 작업'은 dis.foward로 가져온 데이터를 넣은 응답 뷰를 던져주고, 'DB에 입력한 데이터를 담는 작업'은 sendRedirect를 통해 데이터를 넣은 후 이동할 응답 뷰를 던져준다.

### 주요 기능적 특징<br/>
1. 사진 : application(server에저장 업로드 위치에 안 올라감)
2. 인기순위
3. js
4. 댓글/대댓글
5. json형태/Ajax
6. 쿠키/세션

<br/><br/><br/>

## 이슈 및 해결책
1. 빨간줄 문제(getset/import/지움)
2. DB 안열리는 문제(505) : xml찾음
3. 프로필 문제
4. gmail 아이디생성 문제
5. 네이버 로그인 문제


## 추가 구현한 기능
없습니다.

## 아쉬운점 및 추가하고 싶은 기능
: 분석 더 못한것 아쉽 (Ajax나 json에 대한 분석이 더 필요했다.)
늦게 시작하고 꼼꼼한 코드 분석에 치중하는 바람에 기능 구현을 거의 하지 못하고, 그러한 기능 구현을 통한 학습의 계기가 되지 못한점이 아쉬움.

### 추가하고 싶은 기능
+ ㅇ 다른 공유 내용들?
+ ㅇ
+ ㅇ
+ ㅇ

## 작업후기
모델 2 좋은 학습 계기. 앞으로 Spring배우는데도 좋을듯(새로운 개념 많이 배웠다.)
