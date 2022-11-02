import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:target_flutter/components/select_items.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/repository/target_repository.dart';
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
  bool editDescricao = false;
  bool editValor = false;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            edit = editStore.edit;
            if (edit)
              Navigator.pop(context, edit);
            else
              Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              String? aux_des = null;
              num? aux_valor = null;

              if (editDescricao) aux_des = editStore.descricao;

              if (editValor) aux_valor = editStore.valorFinal;

              print("aux_des $aux_des, aux_val = $aux_valor");

              try {
                await TargetRepository().updateTarget(
                    target, aux_des, aux_valor, editStore.tipoTarget);
              } catch (e) {}
              Navigator.pop(context, true);
            },
          ),
        ],
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
                      onChanged: (valor) {
                        editDescricao = true;
                        editStore.setDescricao(valor);
                      },
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
                      decoration: InputDecoration(
                        prefixText: editStore.tipoTarget == TypeDebit.REAL
                            ? 'R\$ '
                            : 'U\$ ',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: SelectItems(editStore.setTipoTarget),
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
                        editValor = true;
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
                            return Dismissible(
                              key: Key(editStore.debitList[index].id!),
                              onDismissed: (direction) async {
                                await editStore.removeDebit(index);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('O debito foi removido'),
                                ));
                              },
                              background: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Text(
                                        'Remover?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: Padding(
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
                                              .formattedMoneyWithType(editStore
                                                  .debitList[index].tipo),
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
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
    return Row(
      children: [
        ElevatedButton(
          child: Text(
            'Depositar',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                          prefixText: editStore.tipoDeposito == TypeDebit.REAL
                              ? 'R\$ '
                              : 'U\$ ',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          errorText: editStore.valorDepositarError,
                          suffixIcon: SelectItems(editStore.setTipoDeposito)),
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
                        await DebitStore().saveDebit(target,
                            editStore.valorADepositar!, editStore.tipoDeposito);
                        editStore.setValorDepositar(null);
                        editStore.setTipoDeposito(TypeDebit.REAL);
                        await editStore.reloadDebit(target);
                        editStore.edit = true;
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
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          child: Text(
            'Retirar',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFFF6961),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Retirar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Observer(builder: (_) {
                    return TextField(
                      enabled: !editStore.loading,
                      style: const TextStyle(
                        fontSize: 15,
                        color: const Color(0xFFFF6961),
                      ),
                      decoration: InputDecoration(
                          prefixText: editStore.tipoDeposito == TypeDebit.REAL
                              ? 'R\$ '
                              : 'U\$ ',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          errorText: editStore.valorDepositarError,
                          suffixIcon: SelectItems(editStore.setTipoDeposito)),
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
                        await DebitStore().saveDebit(target,
                            (-1 * editStore.valorADepositar!), editStore.tipoDeposito);
                        editStore.setValorDepositar(null);
                        editStore.setTipoDeposito(TypeDebit.REAL);
                        await editStore.reloadDebit(target);
                        editStore.edit = true;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Retirar',
                        style: TextStyle(color: Color(0xFF00008B)),
                      ),
                    );
                  } else {
                    return TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Retirar',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
