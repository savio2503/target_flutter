import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/stores/debit_store.dart';
import 'package:target_flutter/stores/edit_store.dart';
import 'package:target_flutter/stores/main_store.dart';

import '../../model/target.dart';

class EditTarget extends StatelessWidget {
  EditTarget(this.index);

  final int index;
  final mainStore = GetIt.I<MainStore>();
  final debitStore = DebitStore();
  final EditStore editStore = EditStore();
  late Target target;

  @override
  Widget build(BuildContext context) {
    print('entrou com o index: $index');
    target = mainStore.targetList[index];
    editStore.setTarget(target);
    EdgeInsets espacoDeCima = const EdgeInsets.only(top: 20);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar objetivo"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: espacoDeCima,
                  child: const Text(
                    'Descrição: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Padding(
                    padding: espacoDeCima,
                    child: TextFormField(
                      initialValue: editStore.descricao,
                      enabled: !editStore.loading,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '',
                        isDense: true,
                        errorText: editStore.descricaoError,
                      ),
                      onChanged: editStore.setDescricao,
                    ),
                  );
                }),
                Padding(
                  padding: espacoDeCima,
                  child: const Text(
                    'Valor Final:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Padding(
                    padding: espacoDeCima,
                    child: TextFormField(
                      enabled: !editStore.loading,
                      initialValue: editStore.valorFinal!.formatted(),
                      decoration: const InputDecoration(
                        prefixText: 'R\$ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (valor) {
                        double? valorDouble = double.tryParse(
                            valor.replaceAll('.', '').replaceAll(',', '.'));
                        editStore.setFinal(valorDouble ?? 0.0);
                      },
                    ),
                  );
                }),
                Padding(
                  padding: espacoDeCima,
                  child: const Center(
                    child: Text(
                      'Lista de debitos',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: espacoDeCima,
                  child: Container(
                    height: height - 440,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            ElevatedButton(
              child: Text('Depositar'),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
