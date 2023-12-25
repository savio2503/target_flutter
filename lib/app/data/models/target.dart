class TargetModel {
  int id;
  String descricao;
  num valor;
  int posicao;
  bool ativo;
  num valorAtual;
  num porcetagem;
  String? imagem;
  num coin;

  TargetModel({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.posicao,
    required this.ativo,
    this.valorAtual = 0,
    this.porcetagem = 0,
    this.imagem,
    required this.coin,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) => TargetModel(
        id: json['id'],
        descricao: json['descricao'],
        valor: double.parse(json['valor']!),
        posicao: json['posicao'],
        ativo: json['ativo'] == 1,
        imagem: json['imagem'],
        coin: json['coin_id'],
        valorAtual: double.parse(json['total_deposit'] ?? "0.00"),
      );

  @override
  String toString() {
    return 'Target={id:$id, descricao:$descricao, valor:$valor, posicao:$posicao, ativo:$ativo, valorAtual:$valorAtual, porcetagem:$porcetagem, imagem:$imagem, coin:$coin}';
  }
}
