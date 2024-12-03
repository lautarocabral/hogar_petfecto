class OcResponseModel {
  String? token;
  String? file;

  OcResponseModel({this.token, this.file});

  OcResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['file'] = file;

    return data;
  }
}
