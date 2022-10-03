import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/screens/edit/edit_screen.dart';
import 'package:target_flutter/stores/main_store.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../add/add_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainStore mainStore = GetIt.I<MainStore>();
  final ScrollController scrollController = ScrollController();
  final userManagerStore = GetIt.I<UserManagerStore>();

  @override
  void initState() {
    mainStore.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleTitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
    final styleNormal = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Objetivos'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              userManagerStore.logout();
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTarget()),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Observer(builder: (_) {
                    if (mainStore.error != null) {
                      print('mainStore.error != null');
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 100,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Ocorreu um erro!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (mainStore.showProgress) {
                      print('mainStore.showProgress');
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    } else if (mainStore.targetList.isEmpty) {
                      return Center(
                        child: Text(
                          'Não há objetivos criados',
                          style: styleNormal,
                        ),
                      );
                    } else {
                      print('else');
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: mainStore.itemCount,
                        itemBuilder: (_, index) {
                          //print('index: $index + total: ${mainStore.targetList.length} + target: ${mainStore.targetList[index]}');
                          //print('index: $index');
                          //if (index < mainStore.targetList.length) {
                          final _target = mainStore.targetList[index];
                          return Dismissible(
                            key: Key(_target.id!),
                            onDismissed: (direction) async {
                              await mainStore.removeTarget(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'O Objetivo ${_target.descricao} foi removido'),
                                ),
                              );
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
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => EditTarget(index)),
                                );

                                if (result)
                                  mainStore.reload();
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        mainStore.targetList[index].descricao!,
                                        style: styleTitle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Valor Atual: ',
                                            style: styleNormal,
                                          ),
                                          Text(
                                            mainStore.targetList[index]
                                                        .valorAtual !=
                                                    null
                                                ? mainStore.targetList[index]
                                                    .valorAtual!
                                                    .formattedMoney()
                                                : 'R\$ 0,00',
                                            style: styleNormal,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Valor Final: ',
                                            style: styleNormal,
                                          ),
                                          Text(
                                            mainStore
                                                .targetList[index].valorFinal!
                                                .formattedMoney(),
                                            style: styleNormal,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        mainStore.targetList[index].progress !=
                                                null
                                            ? mainStore
                                                .targetList[index].progress!
                                                .formattedPercentage()
                                            : '0.0 %',
                                        style: styleNormal,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      LinearProgressIndicator(
                                        value: ((mainStore.targetList[index]
                                                    .progress ??
                                                0) /
                                            100),
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
