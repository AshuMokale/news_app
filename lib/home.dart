import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/Login.dart' show AuthenticationPopup;
import 'package:news_app/api/articles.dart' show Article;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      AuthenticationPopup.show(context, 'User Signed Out.');
      // Navigate to login screen or perform any other action after sign out
    } catch (e) {
      print('Failed to sign out: $e');
      // Handle sign-out failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log Out Successful')));
              _signOut(context);
              Navigator.pushNamed(context, 'Login');
            },
          ),
        ],
      ),
        body: Center(
          child: FutureBuilder<List<Article>>(
            future: Article.fetchArticles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].description),
                      onTap: () {
                        // Handle article tap
                        print('Article tapped: ${snapshot.data![index].url}');
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}
