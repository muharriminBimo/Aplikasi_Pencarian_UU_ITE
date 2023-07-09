import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:uuite/app/modules/home/controllers/home_controller.dart';
import 'package:uuite/app/modules/home/views/list_pasal_view.dart';
import 'package:uuite/app/modules/home/views/search_widget.dart';
import 'package:uuite/app/modules/home/views/web_page_view.dart';
import 'package:uuite/app/shared/appbar_default.dart';
import 'package:uuite/app/shared/text_default.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () {
            if (controller.showWebview) {
              controller.webViewController.goBack();
            }
            return Future.value(!controller.showWebview);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: const SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarDefault(),
                  SearchWidget(),
                  WebPageView(),
                  ListPasalView(),
                ],
              ),
            ),
            floatingActionButton: controller.showBackBtn
                ? FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      if (controller.fallbackUrl == null) {
                        controller.webViewController.goBack();
                      } else {
                        controller.webViewController.stopLoading();
                        controller.webViewController.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse(controller.fallbackUrl!)));
                      }
                    },
                    child: const Icon(Icons.arrow_back, size: 20),
                  )
                : Visibility(
                    visible: !controller.showWebview &&
                        controller.filteredList.isNotEmpty,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton.extended(
                        onPressed: null,
                        extendedPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        label: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => controller.nextPrev('prev'),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                                child: Icon(Icons.arrow_back_ios, size: 15),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextDefault(
                                  '${controller.scrollIndex + 1}/${controller.listNoPasal.length} Pasal'),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => controller.nextPrev('next'),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                                child: Icon(Icons.arrow_forward_ios, size: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
