import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Objetivos'),
          centerTitle: true,
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
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 100,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ocorreu um erro!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      );
                    } else if (mainStore.showProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: mainStore.itemCount,
                        itemBuilder: (_, index) {
                          if (index < mainStore.targetList.length) {
                            return Card();
                          }
                          mainStore.loadNextPage();
                          return Container(
                            height: 10,
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
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
