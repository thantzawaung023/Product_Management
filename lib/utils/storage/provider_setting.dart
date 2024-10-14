import 'package:get_storage/get_storage.dart';

class CurrentProviderSetting {
  factory CurrentProviderSetting() {
    return _instance;
  }
  CurrentProviderSetting._internal();

  static final CurrentProviderSetting _instance =
      CurrentProviderSetting._internal();

  static const _providerIdKey = 'userLoginType';

  Future<String?> get() async {
    final box = GetStorage();
    final providerId = box.read(_providerIdKey);
    return providerId;
  }

  Future<void> update({required String providerId}) async {
    final box = GetStorage();
    await box.write(_providerIdKey, providerId);
  }
}
