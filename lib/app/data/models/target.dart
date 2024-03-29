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
  num removebackground;

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
    required this.removebackground,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) => TargetModel(
        id: json['id'],
        descricao: json['descricao'],
        valor: json['valor']!,
        posicao: json['posicao'],
        ativo: json['ativo'] == 1,
        imagem: json['imagem'],
        coin: json['coin'],
        valorAtual: json['total'] ?? 0.00,
        porcetagem: json['porcetagem'],
        removebackground: json['removebackground'],
      );

  @override
  String toString() {
    return 'Target={id:$id, descricao:$descricao, valor:$valor, posicao:$posicao, ativo:$ativo, valorAtual:$valorAtual, porcetagem:$porcetagem, imagem:$imagem, coin:$coin, removebackground:$removebackground}';
  }
}
