import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fancy_button_flutter/fancy_button_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/modules/deposit/controller.dart';

class DepositPage extends GetView<DepositController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depositar ou Remover'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Quanto você irá\ndepositar ou remover?",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              inputFormatters: [
                CurrencyTextInputFormatter(
                  locale: 'pt-BR',
                  decimalDigits: 2,
                  symbol: 'R\$',
                ),
              ],
              keyboardType: TextInputType.number,
              controller: controller.valorController,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                FancyButton(
                  onClick: () => controller.send(true),
                  button_text: "Depositar",
                  button_height: 40,
                  button_width: 120,
                  button_radius: 50,
                  button_color: Colors.blue,
                  button_outline_color: Colors.blue,
                  button_outline_width: 1,
                  button_text_color: Colors.white,
                  button_icon_color: Colors.white,
                  icon_size: 22,
                  button_text_size: 15,
                ),
                const Spacer(),
                FancyButton(
                  onClick: () => controller.send(false),
                  button_text: "Remover",
                  button_height: 40,
                  button_width: 120,
                  button_radius: 50,
                  button_color: Colors.red,
                  button_outline_color: Colors.red,
                  button_outline_width: 1,
                  button_text_color: Colors.white,
                  button_icon_color: Colors.white,
                  icon_size: 22,
                  button_text_size: 15,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
