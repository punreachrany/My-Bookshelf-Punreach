# My_Bookshelf_Punreach

This is a flutter application that consists of 2 main screens - Search & Detail. All books information are being fetched from Bookstore API.
- API Link: https://api.itbook.store

- Code Explanation Link: 
- Demo Link: https://youtu.be/8CVjhotsAsQ

## Main Features
- Search Engine
- List of Book Information
- Book Details
- User Note
- Webview & Browser Launching
- Data Cache
- Connectivity Monitoring

## Setup
- `git clone https://github.com/punreachrany/My-Bookshelf-Punreach.git`
- run `flutter pub get`
- run `flutter run`

## Packages
- `http: ^0.12.2`   => https://pub.dev/packages/http
- `webview_flutter: ^1.0.7`   => https://pub.dev/packages/webview_flutter
- `url_launcher: ^5.7.10`   => https://pub.dev/packages/url_launcher
- `shared_preferences: ^0.5.12+4`   => https://pub.dev/packages/shared_preferences
- `path_provider: ^1.6.24` => https://pub.dev/packages/path_provider
- `connectivity: ^2.0.2` => https://pub.dev/packages/connectivity

## Project Structure
The project is divided into 4 main folders inside `lib` folder:
- `models`: consists of Book model
- `screens`: consists of 2 screens: Search and Detail
- `service`: handles different methods of Bookstore API 
- `shares`: handles any reusable objects, widget and methods

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## App UI
- Search Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 47 15 PM" src="https://user-images.githubusercontent.com/54469196/102687563-557db880-4233-11eb-9398-6443caa0998f.png">

- Detail Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 48 05 PM" src="https://user-images.githubusercontent.com/54469196/102687572-5ca4c680-4233-11eb-8f4f-00e7e2da8313.png">

- Webview, Browser View & Search Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 48 22 PM" src="https://user-images.githubusercontent.com/54469196/102687574-5dd5f380-4233-11eb-914c-6bc39ce8499f.png">


