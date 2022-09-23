import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:target_flutter/components/error_box.dart';
import 'package:target_flutter/stores/add_store.dart';

class AddTarget extends StatelessWidget {
  final AddStore addStore = AddStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo objetivo"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Observer(builder: (_) {
                  if (addStore.loading) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text(
                            'Salvando o objetivo!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 16),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Observer(builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ErrorBox(
                              message: addStore.error,
                            ),
                          );
                        }),
                        FieldTitle(
                            title: 'Descrição',
                            subtitle: 'Descrição do objetivo'),
                        Observer(builder: (_) {
                          return TextField(
                            enabled: !addStore.loading,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '',
                              isDense: true,
                              errorText: addStore.descricaoError,
                            ),
                            onChanged: addStore.setDescricao,
                          );
                        }),
                        const SizedBox(height: 16),
                        FieldTitle(
                            title: 'Valor Inicial',
                            subtitle: 'Valor atual do objetivo'),
                        Observer(builder: (_) {
                          return TextField(
                            enabled: !addStore.loading,
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
                              print(
                                  '-> ${double.tryParse(valor.replaceAll('.', '').replaceAll(',', '.'))}');
                              double? valorDouble = double.tryParse(valor
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.'));
                              addStore.setValorInicial(valorDouble ?? 0.0);
                            },
                          );
                        }),
                        const SizedBox(height: 16),
                        FieldTitle(
                            title: 'Valor Final',
                            subtitle: 'Valor do objetivo'),
                        Observer(builder: (_) {
                          return TextField(
                            enabled: !addStore.loading,
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
                              double? valorDouble = double.tryParse(valor
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.'));
                              addStore.setValorFinal(valorDouble ?? 0.0);
                            },
                          );
                        }),
                        const SizedBox(height: 16),
                        Observer(builder: (_) {
                          return Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 20, bottom: 12),
                            child: ElevatedButton(
                              child: addStore.loading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white))
                                  : Text('CADASTRAR'),
                              onPressed: () {
                                print(
                                    'presionou o cadastrar, valid: ${addStore.formValid}: des = ${addStore.descricaoValid} + final: ${addStore.valorFinalValid}');
                                addStore.setContext(context);
                                addStore.sendPressed();
                              },
                            ),
                          );
                        })
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FieldTitle extends StatelessWidget {
  FieldTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            '$title   ',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$subtitle',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
