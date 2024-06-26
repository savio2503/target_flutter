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
  late List<String> optionsCoins;
  late String amountDeposited;
  late String coinstr;
  late int id;
  late bool concluded;

  ItemPage({super.key}) {
    Map<String, dynamic> args = Get.arguments ?? {};

    TargetModel target = args['target']!;

    controller.setDescricao(target.descricao);
    controller.setValor(target.valor.toDouble());
    controller.setPeso(target.posicao);
    controller.setImage(target.imagem ?? " ");

    id = target.id;

    List<CoinModel> coins = Get.find<CoinService>().coins;
    optionsCoins = <String>[];

    for (CoinModel coin in coins) {
      optionsCoins.add(coin.symbol);
    }

    var coinId = (target.coin - 1).toInt();

    controller.setCoin(optionsCoins[coinId]);
    controller.setCoinId(coinId);
    controller.visibleRemove.value = target.removebackground == 0;

    amountDeposited = NumberFormat.simpleCurrency(
            name: coins[(target.coin - 1).toInt()].symbol, decimalDigits: 2)
        .format(((target.valor * target.porcetagem) / 100));
    coinstr = coins[(target.coin - 1).toInt()].name;

    concluded = !target.ativo;
  }

  Future<void> processImage(int id) async {
    if (controller.image.value.isEmpty ||
        controller.image.value.compareTo(" ") == 0) {
      await controller.getImage(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    const distance = 20.0;

    processImage(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit objective',
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
                getImage(context),
                TextFormField(
                  controller: controller.descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Provide a description of the objective';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.setDescricao(value),
                  readOnly: concluded,
                ),
                const SizedBox(height: distance),
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
                        readOnly: concluded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: distance),
                if (!concluded) editPesoAndButton(controller),
                getHistoric(controller, distance, id),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editPesoAndButton(ItemController controller) {
    const double distance = 20;
    return Column(
      children: [
        const Text('Select goal weight'),
        const SizedBox(height: distance),
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
        const SizedBox(height: distance * 2),
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
                  printd("Incorrect description or value fields!");
                  return;
                }

                await controller.send(id);
              },
              child: const Text('Save'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () async {
                await controller.delete(id);
              },
              child: const Text('Delete'),
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
        items: optionsCoins
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
          controller.setCoin(value!);
          controller.setCoinId(optionsCoins.indexOf(value));
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
      title: 'Select image source',
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

    if (result == 1) {
      final url = await showTextInputDialog(
          context: context,
          textFields: const [
            DialogTextField(),
          ],
          title: 'Type or paste the web address');

      if (url != null && url.isNotEmpty) {
        controller.setImage(url.first);
      }

    } else if (result == 0) {
      final ImagePicker picker = ImagePicker();
      final mediaFile = await picker.pickImage(source: ImageSource.gallery);

      if (mediaFile != null) {
        final bytes = io.File(mediaFile.path).readAsBytesSync();
        final base64 = base64Encode(bytes);
        controller.setImage(base64);
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
      child: const Text('Add an image'),
    );
  }

  Widget getImage(
    BuildContext context,
  ) {

    if (controller.image.value.isEmpty ||
        controller.image.value.compareTo(" ") == 0) {
      return addImage(context);
    }

    final double width = (MediaQuery.of(context).size.width - 40) * 0.75;

    Widget? image = returnImageFromString(
        controller.image.value, width, addImage(context), controller);

    if (controller.visibleRemove.value) {
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

                      controller.txtRemove.value = "Loading...";

                      String source = controller.imageBase64.isEmpty
                          ? controller.image.value
                          : controller.imageBase64;

                      String result =
                          await returnImageWithoutBackground(source);

                      if (source.compareTo(result) != 0) {
                        controller.visibleRemove.value = false;
                      }
                      controller.image.value = result;
                      controller.imageBase64 = result;
                      controller.txtRemove.value = "Remove background";
                    },
                    child: Text(controller.txtRemove.value),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 15, top: 15),
        child: GestureDetector(
          onLongPress: () async {
            await dialogGetImage(context);
          },
          child: image,
        ),
      );
    }
  }

  Widget getHistoric(ItemController controller, double distance, int id) {
    return Column(
      children: [
        SizedBox(height: distance),
        const Divider(
          height: 10,
        ),
        Text('Total deposited in $coinstr was: $amountDeposited'),
        const Divider(
          height: 10,
        ),
        const Text(
          "Historic",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: distance),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DepositModel> deposits = snapshot.data!;

              if (deposits.isNotEmpty) {
                return Column(
                  children: [
                    for (DepositModel deposit in deposits)
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                color: deposit.valor > 0
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                              const Spacer(),
                              Text(NumberFormat.simpleCurrency()
                                  .format(deposit.valor)),
                              const Spacer(),
                              Text(deposit.createAt),
                            ],
                          ),
                          const Divider(height: 10),
                        ],
                      ),
                  ],
                );
              } else {
                return const Text('Not historical for the target');
              }
            }
            return Container();
          },
          future: controller.getHistoric(id),
        ),
      ],
    );
  }
}
