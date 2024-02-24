import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final box = GetStorage();
  final _token = RxnString();
  final _session = RxnString();

  String? get token => _token.value;
  String? get session => _session.value;

  @override
  void onInit() {
    _token.value = box.read(StorageKey.token.toString());
    _session.value = box.read(StorageKey.session.toString());

    box.listenKey(
      StorageKey.token.toString(),
      (value) => _token.value = value,
    );
    box.listenKey(
      StorageKey.session.toString(),
      (value) => _session.value = value,
    );

    super.onInit();
  }

  Future<void> saveToken(String token) {
    return box.write(StorageKey.token.toString(), token);
  }

  Future<void> saveSession(String session) {
    return box.write(StorageKey.session.toString(), session);
  }
}

enum StorageKey { token, session }
