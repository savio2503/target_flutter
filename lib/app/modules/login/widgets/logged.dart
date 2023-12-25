import 'package:flutter/material.dart';
import 'package:target/app/modules/login/controller.dart';

class Logged extends StatelessWidget {
  const Logged(this.controller);

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text(
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
      )
    );
  }
}
