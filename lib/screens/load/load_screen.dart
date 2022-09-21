import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/screens/login/login_screen.dart';
import 'package:target_flutter/screens/main/main_screen.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final userManagerStore = GetIt.I<UserManagerStore>();

  @override
  void initState() {
    autorun((_) {
      print('userLoad: ${userManagerStore.user}');
      Future.delayed(Duration(milliseconds: 1000)).then((_) {});
      if (!userManagerStore.isLoading) {
        if (userManagerStore.isLoggedIn) {
          Future.delayed(Duration(milliseconds: 100)).then((_) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MainScreen()),
            );
          });
        } else {
          Future.delayed(Duration(milliseconds: 100)).then((_) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.blue,
                  ),
                ),
              ),
              Text(
                'Carregando...',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
