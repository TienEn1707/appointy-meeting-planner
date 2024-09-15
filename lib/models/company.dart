class Company {
  int? id;
  String? companyName;

  Company({
    this.id,
    this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
    };
  }

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
  }
}
