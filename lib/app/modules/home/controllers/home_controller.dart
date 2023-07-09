import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuite/app/constant/assets.dart';
import 'package:uuite/app/models/data_uu_model.dart';
import 'package:uuite/app/models/filtered_list_model.dart';

class HomeController extends GetxController {
  final GetStorage box = GetStorage();
  final TextEditingController textController = TextEditingController();
  final AutoScrollController scrollController = AutoScrollController();
  final FocusNode textFieldFocusNode = FocusNode();
  late InAppWebViewController webViewController;
  int scrollIndex = 0;
  bool first = true;
  bool showWebview = false;
  bool showBackBtn = false;
  bool isLoading = false;
  DataUUModel? dataUU;
  String url = 'https://www.google.com/search?q=kasus uu ite&tbm=nws';
  String? fallbackUrl;
  List<String?> allPasal = [];
  List<String?> listNoPasal = [];
  List<String> key = [];
  List<FilteredList?> allList = [];
  List<FilteredList?> filteredList = [];
  List<String> searchHistory = [];
  List<dynamic> storageList = [];

  @override
  Future<void> onReady() async {
    storageList = box.read('searchHistory') ?? [];
    if (storageList.isNotEmpty) await restoreHistory();
    await _assignModel();
    super.onReady();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    textFieldFocusNode.dispose();
    super.onClose();
  }

  void setUrl() {
    url =
        'https://www.google.com/search?q=kasus "${textController.text}" uu ite&tbm=nws';
  }

  Future<void> _assignModel() async {
    try {
      final uu = await rootBundle.loadString(Assets.dataUU);
      dataUU = DataUUModel.fromJson(jsonDecode(uu));
    } catch (error, stackTrace) {
      debugPrint('$error, $stackTrace');
    }
  }

  void getAllPasal() {
    for (final DataUU data in dataUU?.data ?? []) {
      for (final Pasal pasal in data.pasal ?? []) {
        allPasal.add(pasal.no);
      }
    }

    // filter pasal
    _findPasalInData(allList, allPasal);
  }

  String extractPrefix(String? text) {
    final RegExp regex = RegExp(r'^([0-9a-zA-Z]+\. |\([0-9a-zA-Z]+\)\s)');
    final Match? match = regex.firstMatch(text ?? '');
    return match?.group(0) ?? '';
  }

  void nextPrev(String? action) {
    if (filteredList.isEmpty || listNoPasal.isEmpty) return;
    if (action == 'next') {
      if (scrollIndex + 1 != listNoPasal.length) {
        scrollIndex++;
      } else {
        return;
      }
    } else if (action == 'prev') {
      if (scrollIndex != 0) {
        scrollIndex--;
      } else {
        return;
      }
    } else if (action == null) {
      scrollIndex = 0;
    }

    final strIndex = listNoPasal[scrollIndex];
    final index = int.parse(strIndex!.replaceAll(RegExp('[a-zA-Z]'), '')) -
        (strIndex.contains(RegExp('[a-zA-Z]')) ? 0 : 1);
    scrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    update();
  }

  void doSearch() {
    if (allPasal.isEmpty) getAllPasal();
    scrollIndex = 0;
    filteredList.clear();
    listNoPasal.clear();
    final keyword = textController.text.toLowerCase();

    // save search
    int total = 0;
    for (final String find in searchHistory) {
      if (find.toLowerCase().contains(keyword.toLowerCase())) {
        total++;
      }
    }

    // check if keyword already exist
    if (total < 1) {
      addAndStoreHistory(keyword);
    }

    key = keyword.split(' ');
    if (key.isNotEmpty) {
      // clean up the keyword
      for (final e in ['dan', 'atau', '/', '&', ',']) {
        key.remove(e);
      }

      // optimize search keyword for better result
      if (key.length > 2) {
        key = createWordPairs(key);
      }

      // Iterate through the data to perform the search
      key.insert(0, keyword);
      for (final e in key) {
        _searchLogic(e);
      }
    }

    // filter pasal
    if (listNoPasal.isEmpty) {
      key = keyword.split(' ');
      for (final e in key) {
        _searchLogic(e);
      }
    }

    // remove duplicates
    final List<String?> unique = listNoPasal.toSet().toList();
    listNoPasal = unique;
    listNoPasal.sort((a, b) =>
        int.parse('$a'.replaceAll(RegExp('[a-zA-Z]'), ''))
            .compareTo(int.parse('$b'.replaceAll(RegExp('[a-zA-Z]'), ''))));

    // find detail
    _findPasalInData(filteredList, listNoPasal);

    // scroll to selected index
    nextPrev(null);
    update();
  }

  List<String> createWordPairs(List<String> list) {
    final List<String> pairs = [];
    for (int i = 0; i < list.length - 1; i++) {
      final String pair = '${list[i]} ${list[i + 1]}';
      pairs.add(pair);
    }

    return pairs;
  }

  void _findPasalInData(List<FilteredList?> list, List<String?> search) {
    for (final DataUU data in dataUU?.data ?? []) {
      for (final Pasal pasal in data.pasal ?? []) {
        if (search.contains(pasal.no) == true) {
          list.add(FilteredList(
            bab: data.bab,
            namaBab: data.namaBab,
            pasal: pasal,
          ));
        }
      }
    }
    filterDuplicates(list);
  }

  List<FilteredList?> filterDuplicates(List<FilteredList?> data) {
    final Map<String?, dynamic> babMap = {};
    final Map<String?, dynamic> namaBabMap = {};

    return data.fold<List<FilteredList?>>([],
        (List<FilteredList?> filteredList, current) {
      final String? bab = current?.bab;
      final String? namaBab = current?.namaBab;

      if (babMap[bab] == null && namaBabMap[namaBab] == null) {
        babMap[bab] = true;
        namaBabMap[namaBab] = true;
        filteredList.add(current);
      } else {
        current?.bab = current.namaBab = null;
        filteredList.add(current);
      }
      return filteredList;
    });
  }

  void _searchLogic(String keyword) {
    for (final DataUU data in dataUU?.data ?? []) {
      for (final Pasal pasal in data.pasal ?? []) {
        if (pasal.bunyi?.text?.toLowerCase().contains(keyword) == true) {
          listNoPasal.add(pasal.no);
        }

        for (final Subtext subtext in pasal.bunyi?.subtext ?? []) {
          if (subtext.revisi?.toLowerCase().contains(keyword) == true) {
            listNoPasal.add(pasal.no);
          }

          if (subtext.listText?.toLowerCase().contains(keyword) == true) {
            listNoPasal.add(pasal.no);
          }

          for (final String subListText in subtext.subListText ?? []) {
            if (subListText.toLowerCase().contains(keyword) == true) {
              listNoPasal.add(pasal.no);
            }
          }
        }
      }
    }
  }

  void addAndStoreHistory(String data) {
    if (data.isNotEmpty) {
      searchHistory.add(data);

      // adding temp map to storageList
      storageList.add(data);

      // adding list of maps to storage
      box.write('searchHistory', storageList);
    }
  }

  void removeHistory(String data) {
    searchHistory.remove(data);
    storageList.remove(data);
    box.write('searchHistory', storageList);
    update();
  }

  Future<void> restoreHistory() async {
    // adding Historys back to your normal History list
    for (final e in storageList) {
      searchHistory.add(e.toString());
    }
    update();
  }
}
