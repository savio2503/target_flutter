import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:target/app/data/models/coin.dart';
import 'package:target/app/data/models/deposit.dart';
import 'package:target/app/data/models/target.dart';
import 'package:target/app/data/models/target_request.dart';
import 'package:target/app/data/models/user.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/models/user_login_response.dart';
import 'package:target/app/data/services/storage/service.dart';
import 'package:target/app/tools/functions.dart';

class Api extends GetConnect {
  final _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    //httpClient.baseUrl = 'http://100.96.1.2:3333/';
    httpClient.baseUrl = 'http://192.168.1.18:3333/';
    //httpClient.baseUrl = 'http://192.168.0.192:3333/';

    httpClient.addRequestModifier((Request request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Access-Control-Allow-Origin'] = '*';

      return request;
    });

    httpClient.addAuthenticator((Request request) {
      var token = _storageService.token;
      var headers = {'Authorization': 'Bearer $token'};

      //printd("token: $token");

      request.headers.addAll(headers);

      return request;
    });

    super.onInit();
  }

  Future<List<TargetModel>> getTargets(bool? ativo) async {
    dynamic response;
    if (ativo == null) {
      response = _errorHandler(await get('all'));
    } else if (ativo) {
      response = _errorHandler(await get('allAtive'));
    } else {
      response = _errorHandler(await get('all'));
    }

    List<TargetModel> targets = [];

    printd("retorno getTargets($ativo) = ${response.body}");

    for (var target in response.body) {
      targets.add(TargetModel.fromJson(target));
    }

    //sleep(const Duration(seconds: 2));

    return targets;
  }

  Future<String> getImagem(int targetId) async {
    var response = _errorHandler(await get('image/$targetId'));

    return response.body;
  }

  Future<List<DeposityModel>> getAllDeposity(int targetId) async {
    printd("allDeposity($targetId)");
    var response = _errorHandler(await get('deposit/$targetId'));
    printd("response: allDeposity($response)");
    List<DeposityModel> deposits = [];

    for (var row in response.body) {
      //printd('add: $row');
      deposits.add(DeposityModel.fromJson(row));
    }

    return deposits;
  }

  Future<TargetModel> getTarget(int id) async {
    var response = _errorHandler(await get(''));

    return TargetModel.fromJson(response.body);
  }

  Future<UserLoginResponseModel> login(UserLoginRequestModel data) async {
    printd("chamando o login, body: ${jsonEncode(data)}");
    var response = _errorHandler(await post('login', jsonEncode(data)));
    printd("retorno login");
    return UserLoginResponseModel.fromJson(response.body);
  }

  Future<UserModel> getUser() async {
    var response = _errorHandler(await get('auth/me'));

    return UserModel.fromJson(response.body);
  }

  Future<void> addTarget(TargetRequestModel target) async {
    printd('chamando o add target, body: ${jsonEncode(target)}');

    _errorHandler(await post('target', jsonEncode(target)));

    return; //TargetModel.fromJson(response.body);
  }

  Future<void> editarTarget(TargetRequestModel target) async {
    printd('chamando o editar target, body: ${jsonEncode(target)}');

    _errorHandler(await put('target/${target.id}', jsonEncode(target)));

    return; //TargetModel.fromJson(response.body);
  }

  Future<void> deposit(double amount) async {
    _errorHandler(await post('inside', '{"valor":$amount}'));

    return;
  }

  Future<void> deleteTarget(int id) async {
    printd("delete id: $id");

    _errorHandler(await delete('target/$id'));

    return;
  }

  Future<List<CoinModel>> getAllCoins() async {
    var response = _errorHandler(await get('allCoin'));

    List<CoinModel> coins = [];

    for (var row in response.body) {
      //printd('add: $row');
      coins.add(CoinModel.fromJson(row));
    }

    return coins;
  }

  Response _errorHandler(Response response) {
    String? errorMessage = response.bodyString;

    //printd("-> ${response.bodyString}");

    switch (response.statusCode) {
      case 200:
      case 202:
      case 204:
        return response;
      default:
        printd("-> erro response: ${response.bodyString}");
        if (errorMessage == null) {
          throw 'Por favor, realize um login';
        } else if (errorMessage.contains("E_UNAUTHORIZED_ACCESS")) {
          throw 'Por favor, realize um login';
        } else if (errorMessage.contains("Invalid credentials")) {
          throw 'Login ou senha incorreta(s), por favor tente novamente';
        } else {
          throw 'Ocorreu um erro';
        }
    }
  }
}
