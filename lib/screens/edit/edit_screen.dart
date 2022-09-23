import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/stores/debit_store.dart';
import 'package:target_flutter/stores/main_store.dart';

class EditTarget extends StatelessWidget {
  EditTarget(this.index);

  final int index;
  final mainStore = GetIt.I<MainStore>();
  final debitStore = DebitStore();

  @override
  Widget build(BuildContext context) {
    print('entrou com o index: $index');
    final target = mainStore.targetList[index];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar objetivo"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('descrição: '),
                Text(target.descricao!),
              ],
            ),
            Row(
              children: [
                Text('valor final: '),
                Text(target.valorFinal!.formattedMoney()),
              ],
            ),
            Text('Lista de debitos'),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          ElevatedButton(
            child: Text('Depositar'),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            child: Text('Deletar Objetivo'),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
