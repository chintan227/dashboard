class ShiftModel {
  String? id; // Document ID
  String startTime;
  String endTime;

  ShiftModel({
    this.id,
    required this.startTime,
    required this.endTime,
  });


  factory ShiftModel.fromMap(String id, Map<String, dynamic> map) {
    return ShiftModel(
        id: id,
        startTime: map['startTime'] ?? "",
        endTime: map['endTime'] ??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}