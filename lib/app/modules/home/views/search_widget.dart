import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:uuite/app/constant/colorhex.dart';
import 'package:uuite/app/modules/home/controllers/home_controller.dart';
import 'package:uuite/app/shared/button_default.dart';
import 'package:uuite/app/shared/text_default.dart';
import 'package:uuite/app/shared/textfield_default.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              if (controller.first)
                const Column(
                  children: [
                    SizedBox(height: 5),
                    TextDefault(
                      'Aturan - aturan yang diatur didalam Undang-Undang ITE No. 11 Tahun 2008 dan Undang-Undang ITE No. 19 Tahun 2016.',
                      fontSize: 13,
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.w600,
                    ),
                    TextDefault(
                      'Undang-undang Informasi dan Transaksi Elektronik atau undang-undang nomor 11 tahun 2008 adalah UU yang mengatur tentang informasi serta transaksi elektronik atau teknologi informasi secara umum.',
                      fontSize: 13,
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              Stack(
                children: [
                  if (controller.textFieldFocusNode.hasFocus &&
                      controller.searchHistory.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxHeight: height * 0.35),
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: controller.searchHistory.map((e) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  controller.textController.text = e;
                                  controller.textFieldFocusNode.unfocus();
                                  controller
                                    ..setUrl()
                                    ..update();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      TextDefault(
                                        e,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () =>
                                            controller.removeHistory(e),
                                        child: const Icon(
                                          Icons.clear,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  TextFieldDefault(
                    controller: controller.textController,
                    focusNode: controller.textFieldFocusNode,
                    borderRadius: 30,
                    borderSide: const BorderSide(),
                    hintText: 'Masukkan kata kunci',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    onChanged: (key) => controller
                      ..setUrl()
                      ..update(),
                    textInputAction: TextInputAction.search,
                    contentPadding: const EdgeInsets.only(top: 12, bottom: 15),
                    suffixIcon: Visibility(
                      visible: controller.searchHistory.isNotEmpty,
                      child: InkWell(
                        onTap: () => controller.textFieldFocusNode.hasFocus
                            ? controller.textFieldFocusNode.unfocus()
                            : controller.textFieldFocusNode.requestFocus(),
                        child: Visibility(
                          visible: controller.searchHistory.isNotEmpty,
                          child: Icon(
                            size: 26,
                            controller.textFieldFocusNode.hasFocus
                                ? Icons.arrow_drop_down
                                : Icons.arrow_left,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: controller.first
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!controller.first)
                    ButtonDefault(
                      title: 'KASUS',
                      width: (width * 0.50) - 16,
                      borderRadius: 20,
                      height: 35,
                      fontSize: 12,
                      backgroundColor: ColorHex.blue,
                      borderColor: Colors.black,
                      margin: const EdgeInsets.only(right: 10),
                      onPressed: () {
                        if (controller.showWebview) {
                          controller
                            ..setUrl()
                            ..webViewController.loadUrl(
                              urlRequest:
                                  URLRequest(url: Uri.parse(controller.url)),
                            );
                        } else {
                          controller
                            ..showWebview = true
                            ..update();
                        }
                        controller.textFieldFocusNode.unfocus();
                      },
                    ),
                  ButtonDefault(
                    title: 'LIHAT',
                    width: (width * 0.50) - 16,
                    borderRadius: 20,
                    height: 35,
                    fontSize: 12,
                    backgroundColor: ColorHex.green,
                    borderColor: Colors.black,
                    onPressed: controller.textController.text.isEmpty
                        ? null
                        : () {
                            // perform search
                            controller
                              ..first = false
                              ..showWebview = false
                              ..doSearch()
                              ..update();

                            // close keyboard
                            WidgetsBinding.instance.focusManager.primaryFocus
                                ?.unfocus();
                          },
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
