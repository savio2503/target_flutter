class TargetRequestModel {
  int? id;
  String descricao;
  double valor;
  int posicao;
  String imagem;
  int coin;
  int removebackground;

  TargetRequestModel({
    this.id,
    required this.descricao,
    required this.valor,
    required this.posicao,
    required this.imagem,
    required this.coin,
    required this.removebackground,
  });

  Map<String, dynamic> toJson() => {
        'descricao': descricao,
        'valor': valor,
        'posicao': posicao,
        'imagem': imagem,
        'coin': coin,
        'removebackground': removebackground
      };
}
