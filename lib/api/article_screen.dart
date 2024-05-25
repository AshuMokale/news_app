import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/articles.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class ArticleDetailScreen extends StatefulWidget {
  ArticleDetailScreen({required this.article, Key? key}) : super(key: key);
  final Article article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _addToFavorites(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Use doc() to get a reference to the document with the article URL
        final documentReference =
            _firestore.collection('favourite_articles').doc(widget.article.url);

        // Check if the document exists before deleting it
        final snapshot = await documentReference.get();
        if (snapshot.exists) {
          // Document exists, do not delete it, instead, show feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Article already in Favorites')),
          );
        } else {
          // Document doesn't exist, add it to favorites
          await documentReference.set({
            'uid': user.uid,
            'author': widget.article.author,
            'title': widget.article.title,
            'description': widget.article.description,
            'url': widget.article.url,
            'urlToImage': widget.article.urlToImage,
            'publishedAt': widget.article.publishedAt,
            'content': widget.article.content,
          });
          setState(() {
            isFavorite = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to Favorites')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to manage favorites: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to manage favorites')),
      );
    }
  }

  void _toggleFavorites(BuildContext context) {
    if (isFavorite) {
      _addToFavorites(context);
    } else {
      _addToFavoritesFromApi();
    }
  }

  Future<void> _checkIfFavorite() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('favourite_articles')
          .where('uid', isEqualTo: user.uid)
          .where('url', isEqualTo: widget.article.url)
          .get();
      setState(() {
        isFavorite = snapshot.docs.isNotEmpty;
      });
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
        title: Text(widget.article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'By ${widget.article.author}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: FutureBuilder<String>(
                future: parseHtmlFromUrl(widget.article.url),
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
      floatingActionButton: isFavorite
          ? null
          : FloatingActionButton(
              onPressed: () => _toggleFavorites(context),
              child: Icon(Icons.favorite_border),
            ),
    );
  }

// void _toggleFavorites(BuildContext context) {
//   if (isFavorite) {
//     _addToFavorites(context);
//   } else {
//     _addToFavoritesFromApi();
//   }
// }

  Future<void> _addToFavoritesFromApi() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Use doc() to generate a unique document ID
        final documentReference =
            _firestore.collection('favourite_articles').doc();
        await documentReference.set({
          'uid': user.uid,
          'author': widget.article.author,
          'title': widget.article.title,
          'description': widget.article.description,
          'url': widget.article.url,
          'urlToImage': widget.article.urlToImage,
          'publishedAt': widget.article.publishedAt,
          'content': widget.article.content,
        });
        setState(() {
          isFavorite = true;
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
}
