class Branch {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String openingHours;
  final String? phone;

  const Branch({
    required this.id,
    required this.name,
    this.latitude = 0,
    this.longitude = 0,
    this.address = '',
    this.openingHours = '',
    this.phone,
  });
}
