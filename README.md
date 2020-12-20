# My_Bookshelf_Punreach

This is a flutter application that consists of 2 main screens - Search & Detail. All books information are being fetched from Bookstore API.
- API Link: https://api.itbook.store

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
- git clone `https://github.com/punreachrany/My-Bookshelf-Punreach.git`
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
- `models`: consists of Book model, which will be used to map with the data fetched from Bookstore API.
- `screens`: consists of 2 main screens: Search and Detail.
    - In `Search` Screen, user will first see a list of the new books provided by the API. We have a search engine which allows users to search for a list of books with their keyword. If user taps on any book in listview, the application will get the user to the Detail Screen.
    - In `Detail` Screen, users will see the details/description of the book they selected, and user can also write a note in this screen. In addition, there is a ‘See in Website’ button at bottom of the screen. This button will get our users to the webview inside our application. Users can also launch the webpage inside their mobile phone browser by tapping on the floating button.
    - Notice that all data fetched from the API and all images rendered from the internet will be cached into the phone local memory by using `shared_preferences`. This means that the next time our users renders the same data, our application will load those data from the local memory instead of going to the internet.

- `service`: handles different methods of `Bookstore API`. Normally, I’d like to put everything related to the server side including authentication, database and so on. But this time, I decided to put the Bookstore API method inside this folder. In this `book_api.dart` file, we have
    - `getAllNewBook()` method will render the new book from the rest API.
    - `searchBooks()` method will handle the functionality of our search engine.
    - `getBookByISBN13()` method will render the book’s detail by using the book’s isbn13.
    - `Isolate Implementation`: `decodeJsonInBackground()` and `backgroundTask()` handle `multithreading` behind the screen or in the background.
 
- `shares`: handles any reusable objects, widget and methods.
    - `Loading()` Widget
    - `Utilities` class consists of multiple reusable widget and methods. We can call a `messageDialog()`, `loading()`, and implement `data/image cache` with `getBookImageCache()`, `saveDataCache()` and  `getDataCache()`


## Alternative Implementation
The description below are the alternative implementations for some of the functionality our application. However, due to assessment restriction from using any third-party package, I didn't implement it in those ways.
- `image cache implementation`: Flutter actually recommends us to use a third-party package called `cached_network_image`. 
Link: https://flutter.dev/docs/cookbook/images/cached-images
Furthermore, there is even a video provided by flutter team that. The `image.network` widget will automatically cache the image. However, it doesn't work that.
Link: https://www.youtube.com/watch?v=7oIAs-0G4mw&feature=emb_title
- `data cache implementation`: For large amount of data, it is recommended to use a third-party library called `sqflite`

## App UI
- Search Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 47 15 PM" src="https://user-images.githubusercontent.com/54469196/102687563-557db880-4233-11eb-9398-6443caa0998f.png">

- Detail Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 48 05 PM" src="https://user-images.githubusercontent.com/54469196/102687572-5ca4c680-4233-11eb-8f4f-00e7e2da8313.png">

- Webview, Browser View & Search Screen
<img width="1792" alt="Screen Shot 2020-12-19 at 7 48 22 PM" src="https://user-images.githubusercontent.com/54469196/102687574-5dd5f380-4233-11eb-914c-6bc39ce8499f.png">


