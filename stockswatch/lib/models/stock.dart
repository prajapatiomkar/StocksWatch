class Stock {
  final String symbol;
  final String name;
  final String expiry;
  final double buyPrice;
  final double sellPrice;
  final double change;
  final double changePercent;
  final double high;
  final double low;

  Stock({
    required this.symbol,
    required this.name,
    required this.expiry,
    required this.buyPrice,
    required this.sellPrice,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      name: json['name'],
      expiry: json['expiry'],
      buyPrice: (json['buyPrice'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
    );
  }
}