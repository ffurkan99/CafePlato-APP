class Campaign {
  final String id;
  final String title;
  final String description;
  // Editorial büyük vurgu metni (ör. "%50", "2x", "+200")
  final String? accentValue;
  // Üst küçük label (ör. "SOĞUK KAHVE GÜNLERİ")
  final String? label;
  // Kart yüzey rengi (hex string değil, index ile belirlenir)
  final int surfaceVariant;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    this.accentValue,
    this.label,
    this.surfaceVariant = 0,
  });
}
