import 'package:flutter/material.dart';
import 'package:news_app/api/articles.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
// import 'package:html/dom.dart' as htmlDom;
 

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({required this.article, super.key});
  final Article article;

  // String fetchArticle() {
  //   final response = http.Client().get(Uri.parse(article.url));
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception();
  //   }
  // }

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
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites!'),
              ),
            );
          },
          child: const Icon(Icons.favorite),
        ),
    );
  }
}
