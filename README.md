# MyPosts

This is a sample project of an app that lists all messages and their details from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/).

## UI
In order to provide examples of different ways to address the UI in iOS, two different approaches were used. XIB files for the UI related to the ViewControllers (PostsViewController and PostDetailViewController), and a programmatic UI approach for the UI related to the cells (PostCell, PostDetailCell, PostCommentCell).

## Architecture
The architectural design pattern used in this sample project is MVVM.

## API
This project uses the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) for all HTTP requests and the networking logic is handled by [NSURLSession and Combine](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine).

## Dependencies

- [Lottie](https://github.com/airbnb/lottie-ios)

## Demo
![countdown](https://github.com/rlaverdeveloper/MyPosts/blob/develop/App%20Demo.gif)


License
 ----
 
MIT License

Copyright (c) 2022 Rubbermaid Laverde

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
