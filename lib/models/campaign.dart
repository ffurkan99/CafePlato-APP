class Campaign {
  final String id;
  final String title;
  final String description;
  final String? placeholderIcon;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    this.placeholderIcon,
  });
}
