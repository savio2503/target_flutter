class DeposityModel {
  int id;
  int targetId;
  num valor;
  String createAt;

  DeposityModel({
    required this.id,
    required this.targetId,
    required this.valor,
    required this.createAt,
  });

  factory DeposityModel.fromJson(Map<String, dynamic> json) => DeposityModel(
        id: json['id'],
        targetId: json['targetId'],
        valor: json['valor'],
        createAt: json['createdAt'].toString().substring(0, 19).replaceAll('T', ' '),
      );

      @override
  String toString() {
    
    return "{id: $id, targetId: $targetId, valor: $valor, create: $createAt}"; 
  }
}
