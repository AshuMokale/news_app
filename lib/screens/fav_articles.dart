import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/api/article_screen.dart';
import '../api/articles.dart';

class FavouriteArticlesScreen extends StatefulWidget {
  const FavouriteArticlesScreen({super.key});

  @override
  _FavouriteArticlesScreenState createState() =>
      _FavouriteArticlesScreenState();
}

class _FavouriteArticlesScreenState extends State<FavouriteArticlesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<Article>> _favoriteArticlesFuture;

  @override
  void initState() {
    super.initState();
    _favoriteArticlesFuture = _getFavoriteArticles();
  }

  Future<List<Article>> _getFavoriteArticles() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('favourite_articles')
          .where('uid', isEqualTo: user.uid)
          .get();
      List<Article> articles =
          querySnapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
      return articles;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _favoriteArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No favourite articles yet'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(context, snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(article.urlToImage, height: 200, fit: BoxFit.cover),
              SizedBox(height: 8),
              Text(
                article.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(article.description),
            ],
          ),
        ),
      ),
    );
  }
}
