class DeposityModel {
  int id;
  num valor;
  String createAt;

  DeposityModel({
    required this.id,
    required this.valor,
    required this.createAt,
  });

  factory DeposityModel.fromJson(Map<String, dynamic> json) => DeposityModel(
        id: 1,
        valor: json['valor'],
        createAt: json['mes'],
      );

      @override
  String toString() {
    
    return "{id: $id, valor: $valor, create: $createAt}"; 
  }
}
