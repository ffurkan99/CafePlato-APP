import 'product_size_option.dart';
import 'milk_option.dart';
import 'extra_option.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final bool isPopular;
  final String placeholderIcon;
  final List<ProductSizeOption>? availableSizes;
  final List<MilkOption>? availableMilkOptions;
  final List<ExtraOption>? availableExtras;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.isPopular = false,
    required this.placeholderIcon,
    this.availableSizes,
    this.availableMilkOptions,
    this.availableExtras,
  });
}
