import 'package:flutter/material.dart';
import 'package:target_flutter/screens/signup/signup_screen.dart';

import '../main/main_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Usuário:"),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Senha:"),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainListTarget()),
                            );
                          },
                          child: const Text("Login"),
                        ),
                        const SizedBox(height: 35),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()),
                            );
                          },
                          child: const Text(
                            "Ainda não possui uma conta? clique aqui",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
