import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuite/app/routes/app_pages.dart';
import 'package:uuite/utils/remove_scroll_glow.dart';

void main() {
  runZonedGuarded(() async {
    await GetStorage.init();
    runApp(
      GetMaterialApp(
        title: 'UU ITE',
        getPages: AppPages.routes,
        initialRoute: AppPages.initial,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        builder: (context, child) =>
            ScrollConfiguration(behavior: RemoveScrollGlow(), child: child!),
      ),
    );
  }, (error, stackTrace) {
    if (kDebugMode) {
      print('runZonedGuarded: error $error \nstackTrace $stackTrace');
    }
  });
}
