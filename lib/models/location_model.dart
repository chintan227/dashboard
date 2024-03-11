class LocationDetailModel {
  String? name;
  String? latitude;
  String? longitude;
  String? radius;

  LocationDetailModel({this.name, this.latitude, this.longitude, this.radius});

  LocationDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    return data;
  }
}