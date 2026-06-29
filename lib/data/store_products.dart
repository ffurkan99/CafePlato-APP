import 'package:flutter/material.dart';

import '../models/store_product.dart';

class StoreProducts {
  StoreProducts._();

  static const categories = ['Tümü', 'Ekipman', 'Kahve', 'Merch', 'Hediye'];

  static const items = <StoreProduct>[
    StoreProduct(
      id: 'termos',
      name: 'CafePlato Termos',
      description: 'Kahveni saatlerce sıcak tutan çelik yol arkadaşı.',
      category: 'Ekipman',
      price: 899,
      placeholderIcon: Icons.coffee_rounded,
      isPopular: true,
    ),
    StoreProduct(
      id: 'kupa',
      name: 'Seramik Kupa',
      description: 'Evdeki kahve ritüeli için yumuşak hatlı kupa.',
      category: 'Ekipman',
      price: 429,
      placeholderIcon: Icons.local_cafe_outlined,
      isNew: true,
    ),
    StoreProduct(
      id: 'filtre',
      name: 'Filtre Kahve Çekirdeği',
      description: 'Dengeli, meyvemsi notalara sahip 250 g çekirdek.',
      category: 'Kahve',
      price: 349,
      placeholderIcon: Icons.grain_rounded,
      isPopular: true,
    ),
    StoreProduct(
      id: 'espresso',
      name: 'Espresso Çekirdeği',
      description: 'Yoğun gövdeli CafePlato espresso harmanı, 250 g.',
      category: 'Kahve',
      price: 369,
      placeholderIcon: Icons.grain_rounded,
    ),
    StoreProduct(
      id: 'drip',
      name: 'Drip Bag Seti',
      description: 'Her yerde pratik demleme için altılı seçki.',
      category: 'Kahve',
      price: 289,
      placeholderIcon: Icons.filter_alt_outlined,
      isNew: true,
    ),
    StoreProduct(
      id: 'press',
      name: 'French Press',
      description: 'Isıya dayanıklı cam ve sade CafePlato detayı.',
      category: 'Ekipman',
      price: 649,
      placeholderIcon: Icons.coffee_maker_outlined,
    ),
    StoreProduct(
      id: 'tshirt',
      name: 'CafePlato T-shirt',
      description: 'Yumuşak pamuklu, zamansız bordo marka detayı.',
      category: 'Merch',
      price: 749,
      placeholderIcon: Icons.checkroom_rounded,
    ),
    StoreProduct(
      id: 'gift',
      name: 'Hediye Kartı',
      description: 'Kahve sevenlere seçme özgürlüğü sunan hediye.',
      category: 'Hediye',
      price: 500,
      placeholderIcon: Icons.card_giftcard_rounded,
    ),
  ];
}
