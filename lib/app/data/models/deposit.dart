class DepositModel {
  int id;
  num valor;
  String createAt;

  DepositModel({
    required this.id,
    required this.valor,
    required this.createAt,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
        id: 1,
        valor: json['valor'],
        createAt: json['mes'],
      );

      @override
  String toString() {
    
    return "{id: $id, valor: $valor, create: $createAt}"; 
  }
}
