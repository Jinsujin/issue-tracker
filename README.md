# 💁 프로젝트 소개

IssueTracker 프로젝트는 GitHub API를 활용한 학습용 연습 프로젝트입니다.

2022 코드스쿼드 마스터즈 iOS과정의 팀 프로젝트로 [Rosa](https://github.com/Jinsujin)와 함께 시작했으며, 

수료 이후 Open API와의 네트워크 통신과 Coordinator, DIContainer 패턴 연습을 위해 이어서 혼자 개발하게 되었습니다.

# 📱 주요 화면 및 기능

## GitHub OAuth 로그인
|첫 화면|OAuth 로그인 페이지|리다이렉트|
|:---|:---|:---|
|<img src="https://user-images.githubusercontent.com/67407678/204271315-265a5ba3-3f83-484c-b230-0cca69486f73.png" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/67407678/204271323-ca7f6e51-c5b7-41f7-88c0-3abfe3816d3f.png" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/67407678/204271331-8d339dbe-c0c0-445d-a6a1-4ff84a3b374a.png" width="200" height="400"/>|

## GitHub Repository 목록 조회
|로그인 후 자신의 Repository 목록을 보여줍니다.|
|---|
|<img src="https://user-images.githubusercontent.com/67407678/204271336-7ca40419-07a6-4c97-8aaa-a912b87d81ee.png" width="200" height="400"/>|

## GitHub Repository의 Issue 목록 조회
|선택한 Repository의 Issue 목록을 보여줍니다.|
|---|
|<img src="https://user-images.githubusercontent.com/67407678/204271345-128a9cd1-b23c-4ecf-87e9-cd33d1db8e80.png" width="200" height="400"/>|


## Repository의 새 Issue 생성
|Repository에 새 Issue를 생성합니다.|'저장' 버튼을 누르면 서버에 요청을 보내고 indicator를 띄웁니다.|생성된 Issue와 함께 Issue 목록을 보여줍니다.|
|---|---|---|
|<img src="https://user-images.githubusercontent.com/67407678/204271364-bb518fcc-85b6-4cbf-9002-b34c8bf072bc.png" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/67407678/204271382-3e184a1b-75e1-446d-9171-45c3730de828.png" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/67407678/204271396-bd3578f7-04f8-4cc4-a732-fd40e96f68d4.png" width="200" height="400"/>|


# 🅰️ Architecture

![https://user-images.githubusercontent.com/67407678/204296762-06f74e3e-b428-4e7a-8477-043a4dc05112.png](https://user-images.githubusercontent.com/67407678/204296762-06f74e3e-b428-4e7a-8477-043a4dc05112.png)

- `Coordinator` : `Child Coordinator`들을 관리하고 화면을 전환합니다. (부모 코디네이터)
    - `DIContainer` : 생성된 주요 객체들을 관리합니다.
    - `child coordinators` : 현재 사용 중인 자식 코디네이터들을 관리합니다.
- `Child Coordinator` : `ViewController`의 생성과 흐름을 관리합니다.
- `ViewController` (View) : 화면을 그립니다.
    - `Model` (ViewModel) : 화면을 그리는 데 필요한 데이터와 로직을 관리합니다.
        - `Environment`: 모델이 필요로 하는 Service의 특정 메서드를 클로저로 주입합니다.
- `Service` : 네트워크 요청을 담당합니다.
- `Entity` : 로직이 없는 가장 작은 모델의 단위입니다.

# 🔲 Class Diagram

![https://user-images.githubusercontent.com/67407678/204296895-b89c359d-185f-4beb-a623-94d0a5cb7d9b.png](https://user-images.githubusercontent.com/67407678/204296895-b89c359d-185f-4beb-a623-94d0a5cb7d9b.png)

# ➡️ Sequence Diagram

아래 링크를 클릭하면 wiki 문서로 이동합니다.

[🐭[bibi refactor] Sequence Diagram · Jinsujin/issue-tracker Wiki](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-Sequence-Diagram)

# 📝 학습 노트

- [(wiki) Coordinator 이해하고 적용하기](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-Coordinator-%ED%8C%A8%ED%84%B4-%EC%9D%B4%ED%95%B4-%EB%B0%8F-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0)
- [(wiki) DIContainer : 의존성 주입을 위한 객체 관리하기](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-DIContainer-:-%EC%9D%98%EC%A1%B4%EC%84%B1-%EC%A3%BC%EC%9E%85%EC%9D%84-%EC%9C%84%ED%95%9C-%EA%B0%9D%EC%B2%B4-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)
- [(wiki) Environment 적용하기](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-Environment-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0)
- [(wiki) 지연시간 두고 코드 실행하기 - Timer, asyncAfter](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-%EC%A7%80%EC%97%B0%EC%8B%9C%EA%B0%84-%EB%91%90%EA%B3%A0-%EC%BD%94%EB%93%9C-(%EB%B0%98%EB%B3%B5)-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0---Timer,-DispatchQueue.main.asyncAfter)

# 🐛 디버깅 노트

[이곳의 노션 문서](https://www.notion.so/IssueTracker-c2f2380c3e864717ba151d4d68038cd1)에 정리되어 있습니다.



# 🗓 Timeline

- 220613 ~ 220701 : 코드스쿼드 마스터즈 2022 iOS 팀 프로젝트 - IssueTracker by 로사 & 비비
    - GitHub API 분석
    - GitHub OAuth 로그인
    - Repostiory 목록 가져오기
    - Issue 목록 가져오기
    - Issue 생성하기
    - Container 역할의 클래스 만들기
- 22.07 ~ 22.09 : 기존 프로젝트 개선 및 리팩토링 by 비비
    - 디자인 패턴 적용
        - Environment
        - DIContainer
        - Coordinator
    - 디버깅 작업 (디버깅 노트)
    - 리팩토링 작업
- 22.10 ~ 22.11 : 프로젝트 마무리, 학습 내용 정리 및 문서화 작업
    - 마지막 PR 보내기
    - 학습내용 정리
    - [README.md](http://README.md) 작성
    - Wiki 작성
