class SeguridadModel {
  final int id;
  final String name;

  SeguridadModel({required this.id, required this.name});

  factory SeguridadModel.fromJson(Map<String, dynamic> json) {
    return SeguridadModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
