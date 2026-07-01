import '../models/branch.dart';
import '../models/campaign.dart';
import '../models/coupon.dart';
import '../models/loyalty_transaction.dart';
import '../models/product.dart';
import '../models/product_size_option.dart';
import '../models/milk_option.dart';
import '../models/extra_option.dart';

class MockData {
  MockData._();

  static final List<Branch> branches = [
    const Branch(
      id: '1',
      name: 'CafePlato Cadde',
      latitude: 40.9633,
      longitude: 29.0631,
      address: 'Bağdat Caddesi No: 312, Kadıköy / İstanbul',
      openingHours: 'Her gün 08.00 – 23.00',
      phone: '+90 216 555 01 01',
    ),
    const Branch(
      id: '2',
      name: 'CafePlato Sahil',
      latitude: 40.9813,
      longitude: 29.0274,
      address: 'Moda Caddesi No: 88, Kadıköy / İstanbul',
      openingHours: 'Her gün 08.30 – 00.00',
      phone: '+90 216 555 01 02',
    ),
    const Branch(
      id: '3',
      name: 'CafePlato Merkez',
      latitude: 41.0325,
      longitude: 29.0311,
      address: 'Hakimiyet-i Milliye Caddesi No: 24, Üsküdar / İstanbul',
      openingHours: 'Pzt–Cum 07.30 – 22.30 · Hafta sonu 08.30 – 23.00',
      phone: '+90 216 555 01 03',
    ),
  ];

  static final List<Campaign> campaigns = [
    Campaign(
      id: '1',
      title: 'İkinci soğuk kahven yarı fiyatına.',
      description: 'Tüm soğuk kahvelerde geçerli.',
      accentValue: '%50',
      label: 'SOĞUK KAHVE GÜNLERİ',
      surfaceVariant: 0, // açık bordo
    ),
    Campaign(
      id: '2',
      title: 'Puan biriktir, kahveni ücretsiz al.',
      description: 'Biriktirdiğin puanlarla dilediğin kahve bedava.',
      accentValue: '2×',
      label: 'CAFÉPUAN KAMPANYASI',
      surfaceVariant: 1, // sıcak bej
    ),
    Campaign(
      id: '3',
      title: 'Tatlı + kahve kombosunda avantajlı fiyat.',
      description: 'Seçili tatlılarda kahve alımına özel fiyatlar.',
      accentValue: '+200',
      label: 'TATLIM SANA',
      surfaceVariant: 2, // kırık beyaz
    ),
  ];

  static final List<String> categories = [
    'Tümü',
    'Kahveler',
    'Soğuk İçecekler',
    'Tatlılar',
    'Atıştırmalıklar',
  ];

  static const List<ProductSizeOption> _defaultSizes = [
    ProductSizeOption(name: 'Küçük', priceDelta: 0.0),
    ProductSizeOption(name: 'Orta', priceDelta: 15.0),
    ProductSizeOption(name: 'Büyük', priceDelta: 30.0),
  ];

  static const List<MilkOption> _defaultMilks = [
    MilkOption(name: 'Normal Süt', priceDelta: 0.0),
    MilkOption(name: 'Laktozsuz Süt', priceDelta: 10.0),
    MilkOption(name: 'Badem Sütü', priceDelta: 20.0),
    MilkOption(name: 'Yulaf Sütü', priceDelta: 20.0),
  ];

  static const List<ExtraOption> _defaultExtras = [
    ExtraOption(id: '1', name: 'Ekstra shot', priceDelta: 20.0),
    ExtraOption(id: '2', name: 'Vanilya şurubu', priceDelta: 15.0),
    ExtraOption(id: '3', name: 'Karamel şurubu', priceDelta: 15.0),
  ];

  static final List<Product> products = [
    Product(
      id: '1',
      name: 'Iced Latte',
      description: 'Taze espresso ve soğuk sütün buzla buluşması.',
      category: 'Soğuk İçecekler',
      price: 145.0,
      isPopular: true,
      placeholderIcon: '🧊',
      availableSizes: _defaultSizes,
      availableMilkOptions: _defaultMilks,
      availableExtras: _defaultExtras,
    ),
    Product(
      id: '2',
      name: 'Caramel Macchiato',
      description: 'Karamel şurubu, sıcak süt ve espresso.',
      category: 'Kahveler',
      price: 165.0,
      isPopular: true,
      placeholderIcon: '☕',
      availableSizes: _defaultSizes,
      availableMilkOptions: _defaultMilks,
      availableExtras: _defaultExtras,
    ),
    Product(
      id: '3',
      name: 'Flat White',
      description: 'İnce köpüklü süt ile hazırlanan sert espresso.',
      category: 'Kahveler',
      price: 135.0,
      isPopular: true,
      placeholderIcon: '☕',
      availableSizes: _defaultSizes,
      availableMilkOptions: _defaultMilks,
      availableExtras: _defaultExtras,
    ),
    Product(
      id: '4',
      name: 'Americano',
      description: 'Sıcak su ile seyreltilmiş klasik espresso.',
      category: 'Kahveler',
      price: 120.0,
      isPopular: true,
      placeholderIcon: '☕',
      availableSizes: _defaultSizes,
      availableExtras: _defaultExtras,
    ),
    Product(
      id: '5',
      name: 'Mocha',
      description: 'Çikolata, espresso ve sıcak sütün uyumu.',
      category: 'Kahveler',
      price: 155.0,
      placeholderIcon: '🍫',
      availableSizes: _defaultSizes,
      availableMilkOptions: _defaultMilks,
      availableExtras: _defaultExtras,
    ),
    Product(
      id: '6',
      name: 'San Sebastian',
      description: 'İçi akışkan dışı yanık meşhur İspanyol cheesecake.',
      category: 'Tatlılar',
      price: 190.0,
      isPopular: true,
      placeholderIcon: '🍰',
    ),
    Product(
      id: '7',
      name: 'Brownie',
      description: 'Yoğun çikolatalı ve cevizli taze brownie.',
      category: 'Tatlılar',
      price: 145.0,
      placeholderIcon: '🍫',
    ),
    Product(
      id: '8',
      name: 'Kruvasan',
      description: 'Taze pişmiş tereyağlı Fransız kruvasanı.',
      category: 'Atıştırmalıklar',
      price: 125.0,
      placeholderIcon: '🥐',
    ),
  ];

  static final Product lastOrder = products.first;

  static final List<Coupon> coupons = [
    Coupon(id: '1', title: 'Soğuk Kahvelerde %20 İndirim'),
    Coupon(id: '2', title: 'Doğum Gününe Özel Ücretsiz Tatlı'),
    Coupon(id: '3', title: '200 CafePuan Hediye'),
  ];

  static final List<LoyaltyTransaction> recentTransactions = [
    LoyaltyTransaction(
      id: '1',
      description: 'Iced Latte satın alımı',
      pointDelta: 45,
    ),
    LoyaltyTransaction(
      id: '2',
      description: 'Caramel Macchiato satın alımı',
      pointDelta: 50,
    ),
    LoyaltyTransaction(
      id: '3',
      description: 'Kupon kullanımı',
      pointDelta: -200,
    ),
  ];
}
