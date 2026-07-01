class OrderDateFormatter {
  OrderDateFormatter._();

  static const _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static String short(DateTime date, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final today = DateTime(current.year, current.month, current.day);
    final dayDifference = today.difference(dateOnly).inDays;
    final time = _time(date);

    if (dayDifference == 0) return 'Bugün, $time';
    if (dayDifference == 1) return 'Dün, $time';
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}, $time';
  }

  static String long(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}, '
        '${_time(date)}';
  }

  static String _time(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
