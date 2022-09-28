import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:target_flutter/stores/signup_store.dart';

import '../../components/error_box.dart';

class SignupScreen extends StatelessWidget {
  final SignupStore signupStore = SignupStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Observer(builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ErrorBox(
                      message: signupStore.error,
                    ),
                  );
                }),
                FieldTitle(
                  title: 'Usuário',
                  subtitle: '',
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !signupStore.loading,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ex. joao001',
                      isDense: true,
                      errorText: signupStore.nameError,
                    ),
                    onChanged: signupStore.setName,
                  );
                }),
                const SizedBox(height: 16),
                FieldTitle(
                  title: 'E-mail',
                  subtitle: 'Enviaremos um e-mail deconfirmacao.',
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !signupStore.loading,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ex. joao@gmail.com',
                      isDense: true,
                      errorText: signupStore.emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    onChanged: signupStore.setEmail,
                  );
                }),
                const SizedBox(height: 16),
                FieldTitle(
                  title: 'Senha',
                  subtitle: 'Use letras, números e caracteres especiais',
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !signupStore.loading,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: signupStore.pass1Error),
                    obscureText: true,
                    onChanged: signupStore.setPass1,
                  );
                }),
                const SizedBox(height: 16),
                FieldTitle(
                  title: 'Confirmar Senha',
                  subtitle: 'Repita a senha',
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !signupStore.loading,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: signupStore.pass2Error),
                    obscureText: true,
                    onChanged: signupStore.setPass2,
                  );
                }),
                Observer(builder: (_) {
                  return Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 20, bottom: 12),
                    child: ElevatedButton(
                      child: signupStore.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white))
                          : Text('CADASTRAR'),
                      onPressed: signupStore.signUpPressed,
                    ),
                  );
                })
              ],
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
