//import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Post {
  int userId = 0;
  int id = 0;
  String title = "";
  String body = "";

  Post(this.userId, this.id, this.title, this.body);

  // Named constructor
  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }
}

const STUB_MODE = true;

const stubPostsResponse = '''
[
 {
   "userId": 1,
   "id": 1,
   "title": "title1",
   "body": "Test body1."
 },
 {
   "userId": 1,
   "id": 2,
   "title": "title2",
   "body": "Test body2. Test body2."
 },
 {
   "userId": 1,
   "id": 3,
   "title": "title3",
   "body": "Test body3. Test body3. Test body3."
 }
]
''';

class SampleService extends http.BaseClient {
  static SampleService? _instance;

  final _inner = http.Client();

  factory SampleService() => _instance ??= SampleService._internal();

  SampleService._internal();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['User-Agent'] = 'Sample Flutter App.';
    print('----- API REQUEST ------');
    print(request.toString());
    if (request is http.Request && request.body.length > 0) {
      print(request.body);
    }

    return _inner.send(request);
  }

  /// APIコール
  Future<http.Response> getPosts() async {
    if (STUB_MODE) {
      // スタブ
      final res = http.Response(stubPostsResponse, 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
      });
      return Future.delayed(const Duration(seconds: 5), () => res);
    } else {
      // APIサーバアクセス
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      return get(url);
    }
  }
}
