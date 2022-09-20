import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:target_flutter/screens/edit/edit_screen.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../add/add_screen.dart';

final List<String> linhas = <String>['objetivo 1', 'objetivo 2', 'objetivo 3'];

class MainScreen extends StatelessWidget {
  final userManagerStore = GetIt.I<UserManagerStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Objetivos"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            userManagerStore.logout();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.logout),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: linhas.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              height: 50,
              child: Center(
                child: Text(linhas[index]),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTarget()),
              );
            },
          );
        },
      ),
    );
  }
}
