import 'dart:convert';
import 'dart:io' as io;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:target/app/data/models/coin.dart';
import 'package:target/app/data/models/deposit.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/data/services/coin/service.dart';
import 'package:target/app/modules/item/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class ItemPage extends GetView<ItemController> {
  late List<String> opcoesCoins;
  late String valorDepositado;
  late String coinstr;
  late int id;
  late bool concluido;
//int id = args.containsKey('id') ? args['id'] ?? -1 : -1;
  ItemPage({super.key}) {
    //printd("arg: ${Get.arguments}");
    Map<String, dynamic> args = Get.arguments ?? {};

    TargetModel target = args['target']!;

    controller.setDescricao(target.descricao);
    controller.setValor(target.valor.toDouble());
    controller.setPeso(target.posicao);
    controller.setImage(target.imagem ?? " ");

    //print("imagem parametro: ${target.imagem?.substring(0, 50)}");

    id = target.id;

    List<CoinModel> coins = Get.find<CoinService>().coins;
    opcoesCoins = <String>[];

    for (CoinModel coin in coins) {
      opcoesCoins.add(coin.symbol);
    }

    var coinId = (target.coin - 1).toInt();

    printd("-> setcoin ${opcoesCoins[coinId]}");

    controller.setCoin(opcoesCoins[coinId]);
    controller.setCoinId(coinId);

    valorDepositado = NumberFormat.simpleCurrency(
            name: coins[(target.coin - 1).toInt()].symbol, decimalDigits: 2)
        .format(((target.valor * target.porcetagem) / 100));
    coinstr = coins[(target.coin - 1).toInt()].name;

    concluido = !target.ativo;
  }

  Future<void> processImage(int id) async {
    if (controller.image.value.isEmpty ||
        controller.image.value.compareTo(" ") == 0) {
      await controller.getImage(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    const distancia = 20.0;

    processImage(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar objetivo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                getImagem(context),
                TextFormField(
                  controller: controller.descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Informe a descrição do objetivo';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.setDescricao(value),
                  readOnly: concluido,
                ),
                const SizedBox(height: distancia),
                Row(
                  children: [
                    SizedBox(
                      width: 75,
                      child: dropDown(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            decimalDigits: 2,
                            symbol: '',
                          ),
                        ],
                        keyboardType: TextInputType.number,
                        controller: controller.valorController,
                        readOnly: concluido,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: distancia),
                if (!concluido) editPesoAndButton(controller),
                getHistoric(controller, distancia, id),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editPesoAndButton(ItemController controller) {
    const double distancia = 20;
    return Column(
      children: [
        const Text('Selecione o peso do objetivo'),
        const SizedBox(height: distancia),
        WheelChooser.integer(
          onValueChanged: controller.setPeso,
          maxValue: 10,
          minValue: 1,
          step: 1,
          initValue: controller.peso.value,
          horizontal: true,
          listHeight: 200,
          listWidth: 50,
        ),
        const SizedBox(height: distancia * 2),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                if (controller.descricaoController.text.isEmpty ||
                    (controller.valorController.text.isEmpty ||
                        controller.valorController.text.contains(" 0,00"))) {
                  printd("campos de descricao ou de valor incorretos!");
                  return;
                }

                await controller.send(id);
              },
              child: const Text('Salvar'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () async {
                await controller.delete(id);
              },
              child: const Text('Excluir'),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget dropDown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.yellow,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: opcoesCoins
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: controller.selectCoin.value,
        onChanged: (String? value) {
          printd("selecionou $value, ${opcoesCoins.indexOf(value!)}");
          controller.setCoin(value);
          controller.setCoinId(opcoesCoins.indexOf(value));
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 50,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.lightBlueAccent,
            ),
            color: Colors.white,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_downward_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.lightBlueAccent,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.lightBlueAccent,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

  Future<void> dialogGetImage(BuildContext context) async {
    final result = await showConfirmationDialog<int>(
      context: context,
      title: 'Selecione a fonte da imagem',
      actions: [
        ...List.generate(
          2,
          (index) => AlertDialogAction(
            key: index,
            label: index == 0 ? 'From Device' : 'From Web',
          ),
        ),
      ],
    );

    //printd("result: $result");

    if (result == 1) {
      final url = await showTextInputDialog(
          context: context,
          textFields: const [
            DialogTextField(),
          ],
          title: 'Digite ou cole o endereço web');

      if (url != null && url.isNotEmpty) {
        controller.setImage(url.first);
      }

      //printd("url: $url");
    } else if (result == 0) {
      final ImagePicker picker = ImagePicker();
      final mediaFile = await picker.pickImage(source: ImageSource.gallery);

      printd("media: ${mediaFile?.path}");

      if (mediaFile != null) {
        final bytes = io.File(mediaFile.path).readAsBytesSync();
        final base64 = base64Encode(bytes);
        print("imagem set: ${base64.substring(0, 50)}");
        this.controller.setImage(base64);
      }
    }
  }

  Widget addImage(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () async {
        await dialogGetImage(context);
      },
      child: const Text('Adicionar uma imagem'),
    );
  }

  Widget getImagem(
    BuildContext context,
  ) {
    //printd("getImagem: ${controller.image}");

    if (controller.image.value.isEmpty ||
        controller.image.value.compareTo(" ") == 0) {
      return addImage(context);
    }

    final double width = (MediaQuery.of(context).size.width - 40) * 0.75;

    Widget? image = returnImageFromString(
      controller.image.value,
      width,
      addImage(context),
      controller
    );

    //printd("size: $width, widget: ${image?.runtimeType}");

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: GestureDetector(
        onLongPress: () async {
          await dialogGetImage(context);
        },
        child: Column(
          children: [
            image,
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () async {
                    print("apertou");
                  },
                  child: const Text('Remover background'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getHistoric(ItemController controller, double distancia, int id) {
    return Column(
      children: [
        SizedBox(height: distancia),
        const Divider(
          height: 10,
        ),
        //SizedBox(height: distancia),
        Text('Total depositado em $coinstr foi: $valorDepositado'),
        const Divider(
          height: 10,
        ),
        const Text(
          "Historico",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: distancia),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DeposityModel> depositys = snapshot.data!;

              //printd("lista: ${depositys.toString()}, tamanho: ${depositys.length}");

              if (depositys.isNotEmpty) {
                return Column(
                  children: [
                    for (DeposityModel deposity in depositys)
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                color: deposity.valor > 0
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                              const Spacer(),
                              Text(NumberFormat.simpleCurrency()
                                  .format(deposity.valor)),
                              const Spacer(),
                              Text(deposity.createAt),
                            ],
                          ),
                          const Divider(height: 10),
                        ],
                      ),
                  ],
                );
              } else {
                return const Text('Nao historico para o target');
              }
            }
            return Container();
          },
          future: controller.getHistorico(id),
        ),
      ],
    );
  }
}
