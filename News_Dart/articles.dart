import 'package:http/http.dart' as http;
import 'dart:convert';

class MyNewsService {
  Future<List<Article>> fetchArticles(
      {String country = 'kr',
      String category = '',
      String apiKey = /*your api =>*/ ''}) async {
    //Future & async 비동기적 메소드 짝궁
    String url = 'https://newsapi.org/v2/top-headlines?';
    url += 'country=$country';

    if (category.isNotEmpty && category != 'Headlines') {
      url += '&category=$category';
    }
    url += '&apiKey=$apiKey';

    print(url);

    final response = await http.get(Uri.parse(url)); //response 반드시 체크
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      List<Article> articles = [];
      for (var item in body) {
        if (await _isUrlValid(item['urlToImage'])) {
          body.map((dynamic item) => Article.fromJson(item)).toList();
        }
      }
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  //인터넷을 다녀오는 함수는 Futrure로 선언하면 좋음
  Future<bool> _isUrlValid(String urlToImage) async {
    try {
      final responce = await http.head(Uri.parse(urlToImage));
      return responce.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  Article(
      {required this.title,
      required this.description,
      required this.urlToImage,
      required this.url});

  factory Article.fromJson(Map<String, dynamic> json) {
    //생성자. 생성자 내부에선 future 함수를 사용할 수 없음
    return Article(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        urlToImage: json['urlToImage'] ?? '',
        url: json['url'] ?? '');
  }
}
