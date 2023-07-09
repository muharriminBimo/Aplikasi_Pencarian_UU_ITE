import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuite/app/constant/assets.dart';
import 'package:uuite/app/modules/home/controllers/home_controller.dart';
import 'package:uuite/app/shared/text_default.dart';

class ListPasalView extends StatelessWidget {
  const ListPasalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.showWebview) return const SizedBox();
          if (controller.filteredList.isEmpty &&
              controller.textController.text.isNotEmpty &&
              !controller.first) {
            return Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.emptyData, width: 200),
                  const TextDefault(
                    'Tidak ada hasil pencarian ditemukan, silakan coba masukkan kata kunci lain.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: EdgeInsets.fromLTRB(
                    10, 10, 15, controller.filteredList.isEmpty ? 0 : 50),
                child: Column(
                  // use controller.filteredList to show filtered result only
                  children: controller.allList.map((e) {
                    final pasal = e?.pasal;
                    final index = controller.allList.indexOf(e);
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: controller.scrollController,
                      index: index,
                      highlightColor: Colors.black.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                if (e?.bab != null) 'BAB ${e?.bab}',
                                if (e?.namaBab != null) '${e?.namaBab}',
                                'Pasal ${pasal?.no}',
                              ].map((bab) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: TextDefault(
                                      bab,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (pasal?.bunyi?.text != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 10),
                                child: TextHighlighter(
                                  text: '${pasal?.bunyi?.text}',
                                  search: controller.key,
                                  revisi: pasal?.revisi,
                                ),
                              ),
                            Column(
                              children: (pasal?.bunyi?.subtext ?? []).map((f) {
                                final no = controller.extractPrefix(f.listText);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Center(child: TextDefault(no)),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextHighlighter(
                                              text: '${f.listText}'
                                                  .replaceAll(no, ''),
                                              revisi: f.revisi ?? pasal?.revisi,
                                              search: controller.key,
                                            ),
                                            Column(
                                              children: (f.subListText ?? [])
                                                  .map((text) {
                                                final abj =
                                                    text.substring(0, 3);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextDefault(abj),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: TextHighlighter(
                                                          text: text.replaceAll(
                                                              abj, ''),
                                                          search:
                                                              controller.key,
                                                          revisi: f.revisi ??
                                                              pasal?.revisi,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }
}

class TextHighlighter extends StatelessWidget {
  const TextHighlighter({
    required this.text,
    required this.search,
    this.revisi,
    super.key,
  });

  final String text;
  final String? revisi;
  final List<String> search;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> spans = _getHighlightedSpans(text, search, revisi);
    return RichText(
      text: TextSpan(
        children: spans,
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }

  List<TextSpan> _getHighlightedSpans(
      String text, List<String> search, String? revisi) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(search.join('|'), caseSensitive: false);
    final List<RegExpMatch> matches = regex.allMatches(text).toList();

    if (matches.isEmpty) {
      spans.add(TextSpan(text: text));
      addRevisi(revisi, spans);
      return spans;
    }

    int lastIndex = 0;
    for (final RegExpMatch match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(backgroundColor: Colors.yellow.withOpacity(0.75)),
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    addRevisi(revisi, spans);
    return spans;
  }

  void addRevisi(String? revisi, List<TextSpan> spans) {
    if (revisi != null) {
      spans.add(TextSpan(
          text: ' ($revisi).',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          )));
    }
  }
}
