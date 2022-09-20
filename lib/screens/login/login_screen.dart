import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:target_flutter/screens/signup/signup_screen.dart';
import 'package:target_flutter/stores/login_store.dart';

import '../../components/error_box.dart';

class LoginScreen extends StatelessWidget {
  final LoginStore loginStore = LoginStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/stocks.png'),
                  height: 200, width: 200,
                ),
                const SizedBox(height: 20),
                Observer(builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ErrorBox(message: loginStore.error),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 4, top: 8),
                  child: Text(
                    'E-mail',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !loginStore.loading,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      errorText: loginStore.emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: loginStore.setEmail,
                  );
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Senha',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        child: const Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Observer(builder: (_) {
                  return TextField(
                    enabled: !loginStore.loading,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      errorText: loginStore.passwordError,
                    ),
                    obscureText: true,
                    onChanged: loginStore.setPassword,
                  );
                }),
                Observer(builder: (_) {
                  return Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 20, bottom: 12),
                    child: ElevatedButton(
                      child: loginStore.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white))
                          : const Text('Entrar'),
                      onPressed: () {
                        print('apertou');
                        loginStore.setContext(context);
                        loginStore.loginPressed();
                      },
                    ),
                  );
                }),
                const Divider(color: Colors.black),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'Não tem uma conta? ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
