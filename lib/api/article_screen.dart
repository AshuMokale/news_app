import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/articles.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
// import 'package:html/dom.dart' as htmlDom;

class ArticleDetailScreen extends StatelessWidget {
  ArticleDetailScreen({required this.article, super.key});
  final Article article;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addToFavorites(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('favourite_articles').add({
          'uid': user.uid,
          'author': article.author,
          'title': article.title,
          'description': article.description,
          'url': article.url,
          'urlToImage': article.urlToImage,
          'publishedAt': article.publishedAt,
          'content': article.content,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to Favorites')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to favorites: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add favorites')),
      );
    }
  }

  Future<String> parseHtmlFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        // Example: Extract the text content of <p> tags
        final paragraphs = document.querySelectorAll('p');
        String parsedHtml = '';
        paragraphs.forEach((element) {
          parsedHtml += '${element.text} \n\n';
        });
        return parsedHtml;
      } else {
        throw Exception('Failed to load HTML');
      }
    } catch (e) {
      throw Exception('Error parsing HTML: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'By ${article.author}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16.0),
            // Text(
            //   article.content,
            //   style: const TextStyle(fontSize: 16.0),
            // ),
            Center(
              child: FutureBuilder<String>(
                future: parseHtmlFromUrl(article.url),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data ?? '');
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Added to favorites!'),
        //     ),
        //   );
        // },
        onPressed: () => _addToFavorites(context),
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
