# issue-tracker
> `그룹 프로젝트#5`
>
> 기한: 2022.06.13 ~ 07.01 (3주)
>
> 프로젝트에 대한 자세한 내용은 [👉 Notion]() 에서 확인

![iOS 15.4+](https://img.shields.io/badge/iOS-13.0%2B-lightgrey) ![Xcode 13.3](https://img.shields.io/badge/Xcode-13.3-blue)

## 앱 소개

[Github API](https://docs.github.com/en/rest/issues/issues) 을 사용해 issue 를 관리할 수 있는 iOS Application을 만들어 보았습니다.
구현된 기능은 다음과 같습니다:
- Github OAuth 로그인
- 사용자의 Repository 목록 보여주기
- Repository 에 해당하는 issue 목록 보여주기
- issue 생성하기

|                                                                                                                             로그인                                                                                                                             |                                                                                               Repository 목록                                                                                               |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|                                                         ![login](https://user-images.githubusercontent.com/12508578/176852816-ffe59c4c-0beb-43ab-8bef-94ddfd6b23db.gif)                                                            |                                           ![Repository목록](https://user-images.githubusercontent.com/12508578/176852931-e5b5f3f5-fab4-4337-96d1-9ea90b11bf58.png)                                           |
| - Github OAuth 를 이용해 로그인 합니다. <br/>- 로그인을 하면 Github 으로 부터 인증을 하고 받아온 사용자 access token 를 local(UserDefaults) 에 저장해 API 호출에 사용합니다. <br/>- 한번 로그인을 하면 앱 종료 후 다시 실행해도 로그인 상태를 유지합니다. | - 로그인한 사용자의 Repository 목록을 조회하여 화면에 보여줍니다. <br/>- Repository 를 선택하면, 해당 Repository 에 속한 issue 리스트 화면을 보여줍니다. |

|                                                                                                                             issue 목록                                                                                                                             |                                                                                              issue 만들기                                                                                               |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|                                                         ![issue 목록](https://user-images.githubusercontent.com/12508578/176856686-1ae0ef62-aa92-4112-81d0-2914db6c0885.png)                                                            |                                           ![issue 만들기](https://user-images.githubusercontent.com/12508578/176856729-cf49bac0-811a-4be7-8399-a695b2a40929.gif)                                           |
| - Repository 목록에서 Repository 선택시, API 를 통해 목록을 불러와 화면에 보여줍니다. | - 선택한 Repository 에 issue 를 만들 수 있습니다.<br/>- 타이틀과 함께 레이블, 마일스톤, 담당자 정보를 입력해 issue를 생성할 수 있습니다. <br/>- issue 를 생성 완료하면 목록화면으로 돌아갑니다. |

### 사용한 기술

- [설계](https://github.com/Jinsujin/issue-tracker/wiki/2%EC%A3%BC%EC%B0%A8.-%EC%84%A4%EA%B3%84)
- [DIContainer](https://github.com/Jinsujin/issue-tracker/wiki/DIContainer-%EC%82%AC%EC%9A%A9%EA%B8%B0)
- [Coordinator 적용 계획](https://github.com/Jinsujin/issue-tracker/wiki/Coordinator-%EC%A0%81%EC%9A%A9-%EA%B3%84%ED%9A%8D)
- [(#bibi) Environment 적용하기](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-Environment-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0)
- [(#bibi) DIContainer : 의존성 주입을 위한 객체 관리하기](https://github.com/Jinsujin/issue-tracker/wiki/%F0%9F%90%AD%5Bbibi-refactor%5D-DIContainer-:-%EC%9D%98%EC%A1%B4%EC%84%B1-%EC%A3%BC%EC%9E%85%EC%9D%84-%EC%9C%84%ED%95%9C-%EA%B0%9D%EC%B2%B4-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)

### Library

|                        | Version |           |
| ---------------------- | ------- | --------- |
| Alamofire           | 5.6.1   | SPM |
| SnapKit           | 5.6.0   | SPM |


## 팀원
|`iOS` [@bibi](https://github.com/bibi6666667)| `iOS` [@Rosa](https://github.com/Jinsujin)| 
|--|--|
|<img src="https://github.com/bibi6666667.png" width="200" height="200"/>|<img src="https://github.com/Jinsujin.png" width="200" height="200"/>|
|[👉 회고](https://github.com/Jinsujin/issue-tracker/wiki/%ED%9A%8C%EA%B3%A0%23bibi)|[👉 회고](https://github.com/Jinsujin/issue-tracker/wiki/%ED%9A%8C%EA%B3%A0%23Rosa)|

