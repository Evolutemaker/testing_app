class MedicineInfo {
  String? textName;
  String? text;

  MedicineInfo({this.textName, this.text});

  MedicineInfo.fromJson(Map<String, dynamic> json) {
    textName = json["text_name"];
    text = json["text"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text_name"] = this.textName;
    data["text"] = this.text;
    return data;
  }
}
