# Co.Chat (iOS & Android)
|SDK|Database|IDE|Languages|
|:---:|:---:|:---:|:---:|
|![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)|![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)|![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)|![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)|

## 개요
- [Flutter](https://flutter.dev/), [Firebase](https://firebase.google.com/)를 이용한 채팅, QR Code 출퇴근 관리 App.
- 이용자 간의 1대1, 그룹채팅 기능, QR Code 생성 후 QR Scan을 통해 Database에 시간을 기록하여 출퇴근 시간 기록.
## Platform

![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white) ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
## Environment
- Flutter 2.8.1
- Dart 2.15.1
- macOS 12.2
- VS Code 1.63.2

## Pages
|Login|Register|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/55680319/151937895-f08a302b-fa97-48d9-bbdf-3b14be64a9ac.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151937880-0515386a-b337-4b4d-ba42-c817357b04a7.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151937860-c67c1864-c3f9-4f68-8ffd-1a008da402c7.png" width="270" height="570">|

|Users|Profile Edit|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/55680319/151937860-c67c1864-c3f9-4f68-8ffd-1a008da402c7.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151939575-ced8542e-8c70-410e-b0ca-ad4af773ab88.png" width="270" height="570">|

|Chat List|Chat|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/55680319/151939565-069828d3-20be-479f-82c3-e92401b6f311.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151937882-7f0ee709-1f98-4a17-bbca-bc8b1805c5a5.png" width="270" height="570">|

|QR Code|QR Scanner|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/55680319/151937886-b2283977-32e4-45ab-bd8b-58320d339ee4.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151937889-e0c296af-bdb8-4cf4-90a2-2ab0b4cf4ce4.png" width="270" height="570">|

## Adaptive UI (iOS & Android)
|![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)|![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/55680319/151937892-ff1ac19e-9dab-43c8-bf15-0c88970e1ef7.png" width="270" height="570">|<img src="https://user-images.githubusercontent.com/55680319/151937890-0bdd6191-ab50-4274-96a8-233eaf68b6ae.png" width="270" height="570">|

## Usage
- git clone
- Firebase에서 iOS, Android 앱 등록 
- android/app 폴더에 google-services.json 붙여넣기
- ios/Runner 폴더에 GoogleService-Info.plist 붙여넣기
- 프로젝트에 google-services.json과 GoogleService-Info.plist가 없다면 실행되지 않습니다.
- Firebase console에서 Authentication, Firestore Database, Storage 사용 설정.
- terminal에서 flutter run 실행 

## Reference
[Chatify Flutter Application](https://github.com/preneure/chatify_flutter_firebase_chat_application)
