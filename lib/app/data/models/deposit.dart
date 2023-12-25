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
        targetId: json['target_id'],
        valor: double.parse(json['valor']!),
        createAt: json['created_at'].toString().substring(0, 19).replaceAll('T', ' '),
      );

      @override
  String toString() {
    
    return "{id: $id, targetId: $targetId, valor: $valor, create: $createAt}"; 
  }
}
