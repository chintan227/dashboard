import 'dart:math';

class SubscriptionModel {
  String? id; // Document ID
  String? name; // Document ID
  String cost;
  String noOfWash;
  String addService;
  String removeService;
  String notes;

  SubscriptionModel({
    this.id,
    required this.name,
    required this.cost,
    required this.noOfWash,
    required this.addService,
    required this.removeService,
    required this.notes,
  });


  factory SubscriptionModel.fromMap(String id, Map<String, dynamic> map) {
    return SubscriptionModel(
        id: id,
        name: map['name'] ?? "",
        cost: map['cost'] ?? "",
        addService: map['addService'] ??"",
        removeService: map['removeService'] ?? "",
        noOfWash: map['noOfWash'] ?? "",
        notes: map['notes'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name':name,
      'cost': cost,
      'addService': addService,
      'removeService': removeService,
      'noOfWash': noOfWash,
      'notes': notes,
    };
  }
}
