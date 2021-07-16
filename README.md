<img src = "https://user-images.githubusercontent.com/46644241/124638184-9edae000-dec5-11eb-9e9b-fae86bbc6764.png" width="750">  <br>

#  차로 Charo 
> **차에서의 오늘이 최고가 될 수 있게, 당신의 드라이브 메이트 차로** <br>
> 경험 기반 드라이브 코스 공유 플랫폼
>
> SOPT 28th APP JAM <br>
> 프로젝트 기간 : 2021.06.27 ~ 2021.07.17

<br>

<br>

##  Charo iOS Contributors
 <img src="https://user-images.githubusercontent.com/46644241/124632757-967fa680-debf-11eb-990e-bbb6c72a8935.png" width="500"> | <img src="https://user-images.githubusercontent.com/46644241/124632766-97b0d380-debf-11eb-9ec7-734b282cbc5d.png" width="500"> | <img src="https://user-images.githubusercontent.com/46644241/124632739-92ec1f80-debf-11eb-8701-f0cc74920397.png" width="500"> | <img src="https://user-images.githubusercontent.com/46644241/124632768-98496a00-debf-11eb-9144-4c3654f7b6e7.png" width="500">
 :---------:|:----------:|:---------:|:---------:
 🍎 장혜령 | 🍎 박익범 | 🍎 이지원 | 🍎 최인정
[hryeong66](https://github.com/hryeong66) | [swikkft](https://github.com/parkikbum) | [comeheredart](https://github.com/comeheredart) | [inddoni](https://github.com/inddoni)

<br>
<br>

## Development Environment and Using Library
- Development Environment
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.0-ff69b4">
<img src ="https://img.shields.io/badge/Xcode-12.5-yellow">
<img src ="https://img.shields.io/badge/iOS-14.1-blue">
<a href="https://www.instagram.com/charo_2021_official/">
      <img alt="Instagram: Charo_Official" src="https://img.shields.io/badge/charo-instagram-9986ee" target="_blank" />
  </a>
  </p>

- Library

라이브러리 | 사용 목적 | Version
:---------:|:----------:|:---------:
 Alamofire | 서버 통신 | 5.4
 SnapKit | UI Layout | 5.0.0
 Kingfisher | 이미지 처리 | 6.0
 lottie-ios | 스플래시, 로딩 인디케이터 | -

- framework

프레임워크 | 사용 목적 
:---------:|:----------:
 UIKit | &nbsp;
 TmapSDK | 드라이브 경로 구현 

<br>
<br>

## Our Convention
<details>
 <summary> ⚡ Git Branch Convention </summary>
 <div markdown="1">       

 ---
 
 - **Branch Naming Rule**
    - Issue 작성 후 생성되는 번호와 Issue의 간략한 설명 등을 조합하여 Branch 이름 결정
    - `<Prefix>/<Issue_Number>-<Description>`
- **Commit Message Rule**
    - `Gitmoji [Prefix] : - <Description>`
- **Code Review Rule**
    - 코드 리뷰는 최대한 빨리 해주기 (24시간 내로)
   
 <br>

 </div>
 </details>

 <details>
 <summary> ⚡ Git Flow </summary>
 <div markdown="1">       

 ---
 
 ```
1. Issue 생성 : 담당자, 라벨(우선순위,담당자라벨), 프로젝트 연결 

2. 로컬에서 develop 최신화 : git pull (origin develop) 

3. feature Branch 생성⭐️ : git switch -c Prefix/IssueNumber-description 

4. Add - Commit - Push - Pull Request 의 과정을 거친다.
   ⚠️ commit template 사용하여 이슈번호쓰기 ex. ✅ [CHORE] : #12 - UIstyle 적용
   
5. Pull Request 작성 
 closed: #IssueNumber로 이슈 연결, 프로젝트 연결, 리뷰어 지정

5. Code Review 완료 → Pull Request 작성자가 develop Branch로 merge💜

6. 종료된 Issue와 Pull Request의 Label과 Project를 관리
```
   
 <br>

 </div>
 </details>

<details>
 <summary> ⚡ Naming Convention </summary>
 <div markdown="1">       

 ---
 
- 함수 : **lowerCamelCase** 사용하고 동사로 시작
- 변수, 상수 : **lowerCamelCase** 사용
- 클래스 : **UpperCamelCase** 사용
- 파일명 (약어사용)
    - ViewController → `VC`
    - TableViewCell → `TVC`
    - CollectionViewCell → `CVC`
   
 <br>

 </div>
 </details>

<details>
 <summary> ⚡ Foldering Convention </summary>
 <div markdown="1">       

 ---
 ```
ChaRo-iOS
  │
  |── Source
  │   |── Extensions
  │   |── ViewModels
  │   |── Models
  │   |── Services
  │   |── Views
  │	  │   |── VCs
  │	  |	  |── Cells
  │	  |	  └── Components
  │	  │	  └── Shared
  │   └── Supports
  │			    |── AppDelegate.swift
  │				└── SceneDelegate.swift
  └── Resource
  	 |── Storyboards
  	 |── Xibs
     |── Assets.xcassets
     |── LaunchScreen.storyboard
     └── Info.plist
```
   
 <br>

 </div>
 </details>

### 

<br>
<br>

## Service workflow
<img width=50% src=https://user-images.githubusercontent.com/63224278/123808257-8b5ed080-d92b-11eb-8ac7-e2ef5286909a.png>

<br>

## Task

대분류 | 기능 | 구현 여부 | 담당자
:---------:|---------|:----------:|:---------:
 온보딩 | 스플래시 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | -
 &nbsp; | 온보딩 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 장혜령
  &nbsp; | 로그인 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 이지원
  메인뷰 | 메인배너 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 박익범
  &nbsp; | 메인뷰 컨텐츠 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 이지원
  구경하기 | 게시물 더보기 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 박익범
   &nbsp; | 게시물 더보기 필터링 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 박익범, 이지원
   &nbsp; | 테마별 더보기 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 이지원
  &nbsp; | 게시물 상세보기 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 최인정, 장혜령
 작성하기 | 게시물 작성하기 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 최인정
  &nbsp; | 드라이브 경로 작성하기 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 장혜령
  &nbsp; | 경로 최근 검색 목록 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 장혜령
  검색하기 | 맞춤 검색 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 장혜령
   &nbsp; | 검색 결과 리스트 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 박익범
   &nbsp; | 검색 결과 리스트 필터링 | <img width=25px src=https://user-images.githubusercontent.com/63224278/125839213-0fd9923a-af62-4a04-9578-c797e3ed5c31.png> | 박익범

<br>
<br>

## App Description
앱 주요 기능 설명 Comming Soon!

<br>

---

<img src = "https://user-images.githubusercontent.com/46644241/124637007-29badb00-dec4-11eb-8335-d5a5abb2cbd6.png" width="80"> 
