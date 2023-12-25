class CoinModel {
  int id;
  String name;
  String symbol;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) => CoinModel(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
      );

  @override
  String toString() {
    return "coin={id=$id, name=$name, symbol:$symbol}";
  }
}
