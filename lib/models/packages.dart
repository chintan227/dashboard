class PromoCodes {
  List<ServiceModel>? promoCodes;

  PromoCodes({this.promoCodes});

  PromoCodes.fromJson(Map<String, dynamic> json) {
    if (json['codes'] != null) {
      promoCodes = <ServiceModel>[];
      json['codes'].forEach((v) {
        promoCodes!.add(ServiceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    if (promoCodes != null) {
      data['codes'] = promoCodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Package {
  final String name;
  final String about;
  final Map<String, dynamic> pricing;
  final List<String> services;
  List<ServiceModel>? addServices;
  List<ServiceModel>? removeServices;

  Package(
      {required this.name,
      required this.about,
      required this.pricing,
      required this.services,
      this.addServices,
      this.removeServices});

       Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'pricing': pricing,
      'services': services,
      'addServices': addServices?.map((service) => service.toJson()).toList(),
      'removeServices': removeServices?.map((service) => service.toJson()).toList(),
    };
  }

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      pricing: json['pricing'] ?? {},
      services: List<String>.from(json['services'] ?? []),
      addServices: (json['add_service'] as List<dynamic>?)
          ?.map((serviceJson) => ServiceModel.fromJson(serviceJson))
          .toList(),
      removeServices: (json['remove_service'] as List<dynamic>?)
          ?.map((serviceJson) => ServiceModel.fromJson(serviceJson))
          .toList(),
    );
  }
  int getPriceForWash(String washType) {
    return pricing[washType] ?? 0;
  }
}

class ServiceModel {
  String? name;
  String? subtitle;
  int? price;

  ServiceModel({this.name, this.price, this.subtitle});

  // Deserialize from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        name: json['name'], price: json['price'], subtitle: json['subtitle']);
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'subtitle': subtitle,
    };
  }
}
