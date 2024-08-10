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
          const SizedBox(height: 15),
          Text(
            controller.getEmail(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text("Historic", textAlign: TextAlign.center,),
          const Divider(
            height: 10,
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 15),
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
