import 'package:flutter/material.dart';
import 'package:target_flutter/screens/edit/edit_screen.dart';

import '../add/add_screen.dart';

final List<String> linhas = <String>['objetivo 1', 'objetivo 2', 'objetivo 3'];

class MainListTarget extends StatelessWidget {
  const MainListTarget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Objetivos"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
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
