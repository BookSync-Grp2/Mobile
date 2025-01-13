import 'package:get_it/get_it.dart';

import 'auth_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<AuthService>(AuthService());
}
