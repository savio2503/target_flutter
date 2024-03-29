import 'dart:convert';
import 'dart:io' as io;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:target/app/data/models/coin.dart';
import 'package:target/app/data/services/coin/service.dart';
import 'package:target/app/modules/add/controller.dart';
import 'package:target/app/tools/functions.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class AddPage extends GetView<AddController> {
  AddPage({super.key}) {
    List<CoinModel> coins = Get.find<CoinService>().coins;
    opcoesCoins = <String>[];

    for (CoinModel coin in coins) {
      opcoesCoins.add(coin.symbol);
    }

    controller.setCoin(opcoesCoins[0]);
  }

  late List<String> opcoesCoins;

  final appBar = AppBar(
    title: const Text('Adicionar um novo objetivo', style: TextStyle(color: Colors.white,),),
    centerTitle: true,
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    const distance = 20.0;

    var pageSize = MediaQuery.of(context).size.height;
    var notifySize = MediaQuery.of(context).padding.top;
    var appBarSize = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Obx(
          () => Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            height: pageSize - (appBarSize + notifySize + 35),
            child: Column(
              children: [
                getImagem(controller, context),
                TextFormField(
                  controller: controller.descricaoController,
                  onChanged: controller.check,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Informe a descrição do objetivo';
                    }
                    return null;
                  },
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
                              decimalDigits: 2, symbol: '')
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: controller.check,
                        controller: controller.valorController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: distance),
                const Text('Selecione o peso do objetivo'),
                const SizedBox(height: distance),
                WheelChooser.integer(
                  onValueChanged: controller.setPeso,
                  maxValue: 10,
                  minValue: 1,
                  step: 1,
                  initValue: 1,
                  horizontal: true,
                  listHeight: 200,
                  listWidth: 50,
                ),
                //const Spacer(),
                Expanded(child: Container()),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed:
                      controller.enable.value ? () => controller.send() : null,
                  child: const Text('Inserir'),
                ),
                //const SizedBox(height: (distancia * 3)),
              ],
            ),
          ),
        ),
      ),
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
            border: Border.all(color: Colors.lightBlueAccent,),
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

  Widget getImagem(
    AddController controller,
    BuildContext context,
  ) {
    //printd("getImagem: ${controller.image}");

    if (controller.image.value.isEmpty ||
        controller.image.value.compareTo(" ") == 0) {
      return addImage(controller, context);
    }

    final double width = (MediaQuery.of(context).size.width - 40) * 0.75;

    Widget? image = returnImageFromString(
      controller.image.value,
      width,
      addImage(controller, context),
      controller
    );

    //printd("size: $width, widget: ${image?.runtimeType}");

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: GestureDetector(
        onLongPress: () async {
          await dialogGetImage(controller, context);
        },
        child: image,
      ),
    );
  }

  Widget addImage(AddController controller, BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () async {
        await dialogGetImage(controller, context);
      },
      child: const Text('Adicionar uma imagem'),
    );
  }

  Future<void> dialogGetImage(
      AddController controller, BuildContext context) async {
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
        controller.setImage(base64Encode(bytes));
      }
    }
  }
}
