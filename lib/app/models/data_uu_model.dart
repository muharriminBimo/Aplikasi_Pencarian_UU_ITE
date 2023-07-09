class DataUUModel {
  DataUUModel({this.uu, this.data});

  DataUUModel.fromJson(dynamic json) {
    uu = json['uu'] as String?;
    if (json['data'] != null) {
      data = <DataUU>[];
      json['data'].forEach((dynamic v) {
        data!.add(DataUU.fromJson(v));
      });
    }
  }

  String? uu;
  List<DataUU>? data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uu'] = uu;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataUU {
  DataUU({this.bab, this.namaBab, this.pasal});

  DataUU.fromJson(dynamic json) {
    bab = json['bab'] == null ? null : json['bab'] as String?;
    namaBab = json['namaBab'] == null ? null : json['namaBab'] as String?;
    if (json['pasal'] != null) {
      pasal = <Pasal>[];
      json['pasal'].forEach((dynamic v) {
        pasal!.add(Pasal.fromJson(v));
      });
    }
  }

  String? bab;
  String? namaBab;
  List<Pasal>? pasal;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bab'] = bab;
    data['namaBab'] = namaBab;
    if (pasal != null) {
      data['pasal'] = pasal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pasal {
  Pasal({this.no, this.bunyi, this.revisi});

  Pasal.fromJson(dynamic json) {
    no = json['no'] == null ? null : json['no'] as String?;
    bunyi = json['bunyi'] == null
        ? null
        : Bunyi.fromJson(json['bunyi'] as Map<String, dynamic>);
    revisi = json['revisi'] == null ? null : json['revisi'] as String?;
  }

  String? no;
  Bunyi? bunyi;
  String? revisi;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['no'] = no;
    if (bunyi != null) {
      data['bunyi'] = bunyi!.toJson();
    }
    data['revisi'] = revisi;
    return data;
  }
}

class Bunyi {
  Bunyi({this.text, this.subtext});

  Bunyi.fromJson(Map<String, dynamic> json) {
    text = json['text'] == null ? null : json['text'] as String?;
    if (json['subtext'] != null) {
      subtext = <Subtext>[];
      json['subtext'].forEach((dynamic v) {
        subtext!.add(Subtext.fromJson(v));
      });
    }
  }

  String? text;
  List<Subtext>? subtext;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    if (subtext != null) {
      data['subtext'] = subtext!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subtext {
  Subtext({this.listText, this.revisi, this.subListText});

  Subtext.fromJson(dynamic json) {
    listText = json['listText'] == null ? null : json['listText'] as String?;
    revisi = json['revisi'] == null ? null : json['revisi'] as String?;
    subListText = json['subListText'] == null
        ? null
        : json['subListText'].cast<String>() as List<String>?;
  }

  String? listText;
  String? revisi;
  List<String>? subListText;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['listText'] = listText;
    data['revisi'] = revisi;
    data['subListText'] = subListText;
    return data;
  }
}
