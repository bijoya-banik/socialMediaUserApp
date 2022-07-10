class CountryModel {
  CountryModel({
    this.name,
    this.code,
  });

  String? name;
  String? code;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}
