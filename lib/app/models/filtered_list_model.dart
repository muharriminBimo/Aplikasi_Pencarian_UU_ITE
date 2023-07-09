import 'package:uuite/app/models/data_uu_model.dart';

class FilteredList {
  FilteredList({this.bab, this.namaBab, this.pasal});

  String? bab;
  String? namaBab;
  Pasal? pasal;

  Map<String, dynamic> toJson() {
    return {
      'bab': bab,
      'namaBab': namaBab,
      'pasal': pasal?.toJson(),
    };
  }
}
