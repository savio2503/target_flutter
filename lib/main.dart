import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:target/app/core/theme/app_theme.dart';
import 'package:target/app/data/provider/api.dart';
import 'package:target/app/data/services/auth/repositoy.dart';
import 'package:target/app/data/services/auth/auth_service..dart';
import 'package:target/app/data/services/coin/repository.dart';
import 'package:target/app/data/services/coin/service.dart';
import 'package:target/app/data/services/storage/storage_service.dart';
import 'package:target/routes/pages.dart';
import 'package:target/routes/routes.dart';

void main() async {
  await GetStorage.init();
  Get.put<StorageService>(StorageService());
  Get.put<Api>(Api());
  Get.put<AuthService>(AuthService(AuthRepository(Get.find<Api>())));
  Get.put<CoinService>(CoinService(CoinRepository(Get.find<Api>())));

  Intl.defaultLocale = 'pt-BR';

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.dashboard,
      theme: themeData,
      getPages: AppPages.pages,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    ),
  );
}
