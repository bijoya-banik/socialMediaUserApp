
class GroupCategoryModel {
    GroupCategoryModel({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? name;
    dynamic createdAt;
    dynamic updatedAt;

    factory GroupCategoryModel.fromJson(Map<String, dynamic> json) => GroupCategoryModel(
        id: json["id"],
        name: json["category_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
