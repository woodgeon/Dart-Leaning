import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'articles.dart';

class ArticleCard extends StatelessWidget {
  late final Article article;
  ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => developer.log('URL : ${article.url}'), // onTap시 고민 사항.
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (article.urlToImage.isNotEmpty)
                  ? Image.network(
                      article.urlToImage,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/news,png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  article.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  article.description,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ));
  }
}
