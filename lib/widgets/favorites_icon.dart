import 'package:flutter/material.dart';

class FavoritesIcon extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  FavoritesIcon({required this.isFavorite, required this.onToggleFavorite});

  @override
  _FavoritesIconState createState() => _FavoritesIconState();
}

class _FavoritesIconState extends State<FavoritesIcon> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.onToggleFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: _toggleFavorite,
    );
  }
}
