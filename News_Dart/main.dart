import 'package:flutter/material.dart';
import 'package:flutter_application_2/article_card.dart';
import 'articles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyNewsPage(),
    );
  }
}

class MyNewsPage extends StatefulWidget {
  const MyNewsPage();

  @override
  State<StatefulWidget> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
  late Future<List<Article>> futureArticles;

  final List<Map<String, String>> categories = [
    {'title': 'Headlines'},
    {'title': 'Buniness'},
    {'title': 'Technology'},
    {'title': 'Entertainment'},
    {'title': 'Sports'},
    {'title': 'Science'},
  ];

  @override
  void initState() {
    //데이터 로딩 처리 . .
    super.initState();
    futureArticles = MyNewsService().fetchArticles();
  }

  void _onCategoryTap({String category = ''}) {
    setState(() {
      futureArticles = MyNewsService().fetchArticles(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage('assets/images/news.png'),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 100)),
                  Text('Category',
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.white)),
                ],
              ),
            ),
            ...categories.map((category) => ListTile(
                  title: Text(category['title']!),
                  onTap: () {
                    _onCategoryTap(category: category['title']!);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
      body: FutureBuilder<List<Article>>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //snapshot 상태 체크
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data'));
            } else {
              return ListView.builder(
                  //View in the Tile
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final article = snapshot.data![index];
                    return ArticleCard(
                        article: article, key: ValueKey(article.title));
                  });
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings')
        ],
      ),
    );
  }
}
