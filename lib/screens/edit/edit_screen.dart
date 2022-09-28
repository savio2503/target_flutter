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
  final scrollController = ScrollController();
  bool edit = true;

  @override
  Widget build(BuildContext context) {
    target = mainStore.targetList[index];
    editStore.setTarget(target);
    EdgeInsets espacoDeCima = const EdgeInsets.only(top: 20);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar objetivo"),
        centerTitle: true,
        leading:  IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: () {
              Navigator.pop(context, edit);
            },
          ),
      ),
      body: SizedBox(
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
                      fontSize: 20,
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
                      style: const TextStyle(
                        fontSize: 15,
                      ),
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
                      fontSize: 20,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return Padding(
                    padding: espacoDeCima,
                    child: TextFormField(
                      enabled: !editStore.loading,
                      initialValue: editStore.valorFinal!.formatted(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
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
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: espacoDeCima,
                  child: SizedBox(
                    height: height - 440,
                    child: Observer(builder: (_) {
                      if (editStore.debitList.isEmpty) {
                        return const Center(
                          child: Text('Não há depositos para esse objetivo'),
                        );
                      } else {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: editStore.debitList.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        editStore.debitList[index].create!
                                            .formattedDate(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        editStore.debitList[index].valor!
                                            .formattedMoney(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
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
            DialogDebit(editStore, target),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class DialogDebit extends StatelessWidget {
  DialogDebit(this.editStore, this.target);

  final EditStore editStore;
  final Target target;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Depositar',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Depositar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Observer(builder: (_) {
                return TextField(
                  enabled: !editStore.loading,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                      prefixText: 'R\$ ',
                      border: OutlineInputBorder(),
                      isDense: true,
                      errorText: editStore.valorDepositarError),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (valor) {
                    double? valorDouble = double.tryParse(
                        valor.replaceAll('.', '').replaceAll(',', '.'));
                    editStore.setValorDepositar(valorDouble ?? 0.0);
                  },
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Voltar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Observer(builder: (_) {
              if (editStore.valorDepositarValid) {
                return TextButton(
                  onPressed: () async {
                    await DebitStore()
                        .saveDebit(editStore.valorADepositar!, target);
                    editStore.setValorDepositar(null);
                    await editStore.reloadDebit(target);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Color(0xFF00008B)),
                  ),
                );
              } else {
                return TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
