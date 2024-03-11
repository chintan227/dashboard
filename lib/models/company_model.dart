class CompanyModel {
  String? id; // Document ID
  String companyName;
  String percentage;
  String revenue;

  CompanyModel({
    this.id,
    required this.companyName,
    required this.percentage,
    required this.revenue,
  });


  factory CompanyModel.fromMap(String id, Map<String, dynamic> map) {
    return CompanyModel(
        id: id,
        companyName: map['companyName'] ?? "",
        percentage: map['percentage'] ??"",
        revenue: map['revenue'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'percentage': percentage,
      'revenue': revenue,
    };
  }
}
