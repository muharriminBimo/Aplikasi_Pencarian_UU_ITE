import 'package:get/get.dart';
import 'package:uuite/app/modules/home/bindings/home_binding.dart';
import 'package:uuite/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage<void>(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
