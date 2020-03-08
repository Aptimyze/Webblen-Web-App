import 'package:get_it/get_it.dart';

import 'services/navigation/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocater() {
  locator.registerLazySingleton(() => NavigationService());
}
