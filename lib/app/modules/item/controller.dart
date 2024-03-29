import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:target/app/core/image_callback.dart';
import 'package:target/app/data/models/deposit.dart';
import 'package:target/app/data/models/target_request.dart';
import 'package:target/app/modules/item/repository.dart';
import 'package:target/app/tools/functions.dart';

class ItemController extends GetxController implements ImageCallback {
  final ItemRepository _repository;

  var descricaoController = TextEditingController();
  var valorController = TextEditingController(text: ' 0,00');
  var peso = 1.obs;
  var image = " ".obs;
  var processado = false.obs;
  var selectCoin = "".obs;
  var coinId = 1.obs;
  var imageBase64 = "";
  var txtRemove = "Remover background".obs;
  var visibleRemove = true.obs;

  ItemController(this._repository);

  void setCoin(String value) => selectCoin.value = value;

  void setCoinId(int value) => coinId.value = (value + 1);

  void setImage(String value) {
    image.value = value;
    visibleRemove.value = true;
  }

  void setDescricao(String value) => descricaoController.text = value;

  void setValor(double value) =>
      valorController.text = NumberFormat.simpleCurrency(
        name: '',
        decimalDigits: 2,
      ).format(value);

  void setPeso(dynamic value) => peso.value = value.toInt();

  send(int id) async {
    try {
      var valor = currencyToDouble(valorController.text);

      var target = TargetRequestModel(
        descricao: descricaoController.text,
        valor: valor,
        posicao: peso.value,
        imagem: imageBase64.isEmpty ? image.value : imageBase64,
        coin: coinId.value,
        removebackground: visibleRemove.value ? 0 : 1,
      );

      target.id = id;
      await _repository.editarTarget(target);

      Get.back(result: true);
    } catch (error) {
      printd("erro ao inserir/editar um novo objetivo: $error");
    }
  }

  delete(int id) async {
    try {
      await _repository.deleteTarget(id);

      Get.back(result: true);
    } catch (error) {
      printd("erro ao excluir target: $error");
    }
  }

  Future<List<DeposityModel>> getHistorico(int targetId) async {
    List<DeposityModel> result = [];

    try {
      result = await _repository.getAllDeposity(targetId);
    } catch (e) {
      printd("erro ao buscar o historico: $e");
    }

    return result;
  }

  Future<void> getImage(int id) async {
    if (processado.value) return;

    try {
      image.value = await _repository.getImagem(id);
      print("imagem get: ${image.value.substring(0, 50)}");
      processado.value = true;
    } catch (e) {
      printd("erro ao buscar a imagem: $e");
    }
  }

  @override
  void onImageReceived(String base64Image) {
    imageBase64 = base64Image;
  }
}
