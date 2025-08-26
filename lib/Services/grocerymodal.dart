class GroceryModal {
  int? id;
  String? GroceryColumn;

  GroceryModal({this.id, this.GroceryColumn});

  GroceryModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    GroceryColumn = json['GroceryColumn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['GroceryColumn'] = this.GroceryColumn;
    return data;
  }
}
