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
import 'package:target/app/data/services/storage/storage_service.dart';
import 'package:target/app/tools/functions.dart';

class Api extends GetConnect {
  final _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    //server address
    httpClient.baseUrl = 'http://192.168.3.20:3333/';

    httpClient.addRequestModifier((Request request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Access-Control-Allow-Origin'] = '*';

      return request;
    });

    httpClient.addAuthenticator((Request request) {
      var token = _storageService.token;
      var session = _storageService.session;

      var authorization = {'Authorization': 'Bearer $token'};
      var cookie = {'Cookie': '$session'};

      request.headers.addAll(authorization);
      request.headers.addAll(cookie);

      return request;
    });

    super.onInit();
  }

  Map<String, String> getHeaders() {

    Map<String, String> res = {};

    var token = _storageService.token;
    var session = _storageService.session;

    var authorization = {'Authorization': 'Bearer $token'};
    var cookie = {'Cookie': '$session'};
    var keep = {'Connection': 'keep-alive'};

    res.addAll(authorization);
    res.addAll(cookie);
    res.addAll(keep);

    return res;
  }

  Future<List<TargetModel>> getTargets(bool? ativo) async {
    dynamic response;

    if (ativo == null) {
      response = _errorHandler(await get('all', headers: getHeaders()));
    } else if (ativo) {
      response = _errorHandler(await get('allAtive', headers: getHeaders()));
    }

    List<TargetModel> targets = [];

    for (var target in response.body) {
      targets.add(TargetModel.fromJson(target));
    }

    return targets;
  }

  Future<String> getImage(int targetId) async {
    var response = _errorHandler(await get('image/$targetId', headers: getHeaders()));

    return response.body;
  }

  Future<List<DepositModel>> getAllDeposit(int targetId) async {
    
    var response = _errorHandler(await get('deposit/$targetId', headers: getHeaders()));
    
    List<DepositModel> deposits = [];

    for (var row in response.body) {
      
      var aux = DepositModel.fromJson(row);
      if (aux.valor != 0) {
        deposits.add(aux);
      }
    }

    return deposits;
  }

  Future<TargetModel> getTarget(int id) async {
    var response = _errorHandler(await get('', headers: getHeaders()));

    return TargetModel.fromJson(response.body);
  }

  Future<void> login(UserLoginRequestModel data) async {
    String error = "";
    try {
      var response = _errorHandler(await post('login', jsonEncode(data)));

      //getting the cookie in the response
      response.headers!.forEach((key, value) {
        if (key == HttpHeaders.setCookieHeader) {
          String cookie = "";

          RegExp regex = RegExp(r"SameSite=([^;]+),([^;]+)");
          Iterable<Match> matches = regex.allMatches(value);
          List<String> values = [];

          matches.forEach((element) {
            String? value = element.group(2);
            if (value != null && value.isNotEmpty) {
              values.add(value);
            }
          });

          cookie = values.join('; ');

          _storageService.saveSession(cookie);
        }
      });
    } catch (e) {
      RegExp regex = RegExp('"message":"(.*?)"');
      Iterable<Match> matches = regex.allMatches(e.toString());

      matches.forEach((element) {
        String? value = element.group(1);
        if (value != null && value.isNotEmpty) {
          error = value;
        }
      });

      if (error.isEmpty) {
        error = e.toString();
      }

      throw error;
    }
  }

  Future<UserModel> getUser() async {

    if (_storageService.session != null && _storageService.session!.isNotEmpty ) {

      var response = _errorHandler(await get('auth/me', headers: getHeaders()));
      return UserModel.fromJson(response.body);

    } else {
      throw 'Not logged in';
    }

  }

  Future<void> addTarget(TargetRequestModel target) async {

    _errorHandler(await post('target', jsonEncode(target), headers: getHeaders()));

    return;
  }

  Future<void> editTarget(TargetRequestModel target) async {

    _errorHandler(await put('target/${target.id}', jsonEncode(target), headers: getHeaders()));

    return;
  }
  
  Future<void> editImage(int targetId, String image) async {

    String request = '{"targetId":"$targetId","image":"$image"}';

    try {
      _errorHandler(await put('image', request, headers: getHeaders()));
    } catch (error) {
      printd('error updating image: $error');
    }
  }

  Future<void> deposit(double amount) async {
    _errorHandler(await post('inside', '{"valor":$amount}', headers: getHeaders()));

    return;
  }

  Future<void> deleteTarget(int id) async {

    _errorHandler(await delete('target/$id', headers: getHeaders()));

    return;
  }

  Future<List<CoinModel>> getAllCoins() async {
    var response = _errorHandler(await get('allCoin', headers: getHeaders()));

    List<CoinModel> coins = [];

    for (var row in response.body) {
      coins.add(CoinModel.fromJson(row));
    }

    return coins;
  }

  Response _errorHandler(Response response) {
    String? errorMessage = response.bodyString;

    switch (response.statusCode) {
      case 200:
      case 202:
      case 204:
        return response;
      default:
        if (errorMessage == null) {
          throw 'Please login';
        } else if (errorMessage.contains("E_UNAUTHORIZED_ACCESS")) {
          throw 'Please login';
        } else if (errorMessage.contains("Invalid credentials")) {
          throw 'Incorrect login or password, please try again';
        } else {
          throw errorMessage;
        }
    }
  }
}
