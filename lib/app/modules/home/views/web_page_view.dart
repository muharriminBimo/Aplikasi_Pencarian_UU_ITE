import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:uuite/app/modules/home/controllers/home_controller.dart';

class WebPageView extends StatelessWidget {
  const WebPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        if (!controller.showWebview) return const SizedBox();
        return Expanded(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Opacity(
                  opacity: controller.isLoading ? 0 : 1,
                  child: SizedBox(
                    height: (height * 0.65) + 11.125,
                    width: width,
                    child: InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: Uri.parse(controller.url)),
                      onWebViewCreated: (webcontroller) =>
                          controller.webViewController = webcontroller,
                      onLoadStart: (webcontroller, url) {
                        controller
                          ..isLoading = true
                          ..update();

                        // clean the url & disable AMP
                        final modifiedUrl = _modifyUrl(url.toString());
                        if (modifiedUrl != url.toString()) {
                          controller.webViewController.loadUrl(
                              urlRequest:
                                  URLRequest(url: Uri.parse(modifiedUrl)));
                        }

                        if (modifiedUrl
                            .startsWith('https://www.google.com/search')) {
                          controller.fallbackUrl = modifiedUrl;
                        }
                      },
                      onScrollChanged: (webcontroller, x, y) {
                        // Mark text matching the pattern
                        _markSearchText(controller);
                      },
                      shouldOverrideUrlLoading:
                          (webController, navigationAction) async {
                        final adDomains = [
                          'adserver.com',
                          'adnetwork.net',
                          'adsense.com'
                        ];
                        final url = navigationAction.request.url.toString();

                        if (adDomains.any(url.contains)) {
                          // Return a blank response for ad requests
                          return NavigationActionPolicy.CANCEL;
                        }

                        // Continue loading other URLs
                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (webcontroller, url) {
                        // Remove HTML elements by tag or class name
                        final classList = [
                          'header', // search bar, etc
                          'msd', // filter
                          // 'MgUUmf', // web name & web logo
                          // 'OSrXXb', // article date
                          'f6F9Be', // footer
                          'cUnQKe', // people also ask widget
                          'iTPLzd', // more button
                          'adsbygoogle', // ads
                          'MgContainer', // ads
                        ];
                        for (final e in classList) {
                          final finder = e == 'header'
                              ? "document.getElementsByTagName('$e')"
                              : e == 'msd' || e == 'MgContainer'
                                  ? "document.getElementsById('$e')"
                                  : "document.getElementsByClassName('$e')";
                          controller.webViewController.evaluateJavascript(
                              source:
                                  'var elements = $finder; while (elements.length > 0) elements[0].remove();');
                        }

                        // add this script to make recaptcha works
                        controller.webViewController
                            .evaluateJavascript(
                                source:
                                    "document.documentElement.innerHTML.includes('reCAPTCHA');")
                            .then((value) {
                          if (value.toString() != 'true') {
                            // Mark text matching the pattern
                            _markSearchText(controller);
                          }
                        });

                        // show/hide button
                        controller.showBackBtn = url?.host != 'www.google.com';

                        // disable loading
                        Future.delayed(
                            const Duration(milliseconds: 300),
                            () => controller
                              ..isLoading = false
                              ..update());
                      },
                    ),
                  ),
                ),
                if (controller.isLoading)
                  SizedBox(
                    height: height * 0.6,
                    child: Center(
                      child: Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _markSearchText(HomeController controller) async {
    await controller.webViewController.evaluateJavascript(source: '''
    var pattern = /${controller.textController.text.capitalize}/gi;
    var bodyContent = document.body.innerHTML;
    var markedContent = bodyContent.replace(pattern, '<mark>\$&</mark>');
    document.body.innerHTML = markedContent;
    ''');
  }

  String _modifyUrl(String url) {
    return url
        .replaceAll('%3Cmark%3E', '')
        .replaceAll('%3C/mark%3E', '')
        .replaceAll('<mark>', '')
        .replaceAll('</mark>', '')
        .replaceAll('https://www.google.com/amp/s/', '');
  }
}
