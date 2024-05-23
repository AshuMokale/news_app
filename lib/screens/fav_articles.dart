import 'package:flutter/material.dart';

class FavoriteArticlesScreen extends StatelessWidget {
  const FavoriteArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Articles'),
      ),
      body: const Center(
        child: Text('Favorite Articles Screen'),
      ),
    );
  }
}
