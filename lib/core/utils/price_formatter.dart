class PriceFormatter {
  PriceFormatter._();

  static String display({
    required double price,
    required String currency,
    String? unit,
  }) {
    final number = price.round().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
    );
    return '${_symbol(currency)} $number${_unitSuffix(unit)}';
  }

  static String _symbol(String currency) => switch (currency.toUpperCase()) {
    'ILS' => '₪',
    'USD' => r'$',
    'JOD' => 'JD',
    _ => currency,
  };

  static String _unitSuffix(String? unit) => switch (unit) {
    'per_hour' => ' / hr',
    'per_day' => ' / day',
    'per_week' => ' / week',
    'per_month' => ' / month',
    'per_year' => ' / year',
    _ => '',
  };
}