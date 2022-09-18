import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nome do usuário:"),
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
              const SizedBox(height: 20),
              const Text("Repitir a senha:"),
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
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Criar conta"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
