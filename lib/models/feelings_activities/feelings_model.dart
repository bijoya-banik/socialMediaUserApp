
class FeelingsModel {
    FeelingsModel({
        this.id,
        this.name,
        this.type,
        this.icon,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? name;
    String? type;
    String? icon;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory FeelingsModel.fromJson(Map<String, dynamic> json) => FeelingsModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        icon: json["icon"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "icon": icon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
