class PriceFormatter {
  PriceFormatter._();

  static String displayWithCode({
    required double price,
    required String currency,
    String? unit,
  }) =>
      '${_group(price)} ${currency.toUpperCase()}${_unitSuffix(unit)}';

  static String display({
    required double price,
    required String currency,
    String? unit,
  }) =>
      '${_symbol(currency)} ${_group(price)}${_unitSuffix(unit)}';

  static String _group(double price) => price.round().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
  );

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