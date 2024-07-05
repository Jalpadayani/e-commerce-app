import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductItem({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.imageUrl,
          width: 50, height: 50, fit: BoxFit.cover),
      title: Text(
        product.name,
      ),
      subtitle: Text('\$${product.price}'),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: onFavoriteToggle,
        color: isFavorite ? Colors.red : null,
      ),
      onTap: () {
        Get.to(ProductDetailScreen(product: product));
      },
    );
  }
}
