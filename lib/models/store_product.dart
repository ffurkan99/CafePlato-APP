import 'package:flutter/material.dart';

class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.placeholderIcon,
    this.isPopular = false,
    this.isNew = false,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final IconData placeholderIcon;
  final bool isPopular;
  final bool isNew;
}
