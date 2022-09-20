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

class _LoadScreenState extends State<LoadScreen> with TickerProviderStateMixin {
  final userManagerStore = GetIt.I<UserManagerStore>();
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });

    autorun((_) {
      print('userLoad: ${userManagerStore.user}');
      Future.delayed(Duration(milliseconds: 100)).then((_) {});
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Circular progress indicator',
            ),
            Text(
              'Carregando...',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
