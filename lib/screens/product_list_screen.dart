import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final AuthService authService = Get.find<AuthService>();
  List<String> favoriteProducts = [];
  List<Product> products = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadProducts();
  }

  Future<void> _loadFavorites() async {
    favoriteProducts = await authService.getFavorites();
    setState(() {});
  }

  Future<void> _loadProducts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Product> newProducts = await ApiService().fetchProducts();
      setState(() {
        products.addAll(newProducts);
        currentPage++;
      });
    } catch (e) {
      // Handle error
      print('Error loading products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.toNamed('/favorites');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(child: Text('Menu')),
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                Get.toNamed('/profile');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await authService.logout();
              },
            ),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadProducts();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: products.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProductItem(
              product: products[index],
              isFavorite: favoriteProducts.contains(products[index].id),
              onFavoriteToggle: () async {
                await authService.toggleFavorite(products[index].id);
                _loadFavorites();
              },
            );
          },
        ),
      ),
    );
  }
}
