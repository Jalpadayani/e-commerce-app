import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/product_item.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthService authService = Get.find<AuthService>();
  List<String> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoriteProducts = await authService.getFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: ApiService().fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error : ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> favoritesList = snapshot.data!
                .where((product) =>
                    favoriteProducts.contains(product.id.toString()))
                .toList();
            return ListView.builder(
              itemCount: favoritesList.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  product: favoritesList[index],
                  isFavorite: true,
                  onFavoriteToggle: () async {
                    await authService
                        .toggleFavorite(favoritesList[index].id.toString());
                    _loadFavorites();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
