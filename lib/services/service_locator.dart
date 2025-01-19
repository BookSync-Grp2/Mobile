import 'package:get_it/get_it.dart';

import 'auth_service.dart';
import 'book_service.dart';
import 'loan_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt<AuthService>().init();
  getIt.registerLazySingleton<LoanService>(
      () => LoanService(getIt<AuthService>()));
  getIt.registerLazySingleton(() => BookService(getIt<AuthService>()));
}
