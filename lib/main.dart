import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/screens/load/load_screen.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import 'screens/login/login_screen.dart';
import 'stores/main_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeParse();
  setupLocators();
  runApp(const MyApp());
}

void setupLocators() {
  GetIt.I.registerSingleton(UserManagerStore());
  GetIt.I.registerSingleton(MainStore());
}

Future<void> initializeParse() async {
  await Parse().initialize(
    '8uFlHKY1yHG6cSC6Eme1O1RF5w2aGx7FxccVduNR',
    'https://parseapi.back4app.com/',
    clientKey: 'Mz67KJ18u6XkjDbpXYuBcjBhJLVNYSSdcferLYJ2',
    autoSendSessionId: true,
    debug: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Target',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      /*supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: [],*/
      home: LoadScreen(),
    );
  }
}
