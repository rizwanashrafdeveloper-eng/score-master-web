class Facilitators {
  int? id;
  String? name;
  String? email;
  String? language;
  String? phone;

  Facilitators({this.id, this.name, this.email, this.language, this.phone});

  Facilitators.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    language = json['language'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['language'] = language;
    data['phone'] = phone;
    return data;
  }
}
