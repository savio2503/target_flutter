import 'package:flutter/material.dart';
import 'package:target/app/modules/login/controller.dart';

class Logged extends StatelessWidget {
  const Logged(this.controller, {super.key});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            "Logado",
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () => controller.logout(),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
