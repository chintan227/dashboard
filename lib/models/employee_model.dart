class EmployeeModel {
  String? name;
  String? phone;
  String? email;
  String? password;
  String? salary;
  String? company;
  String? id;
  String? priorityService;
  Locations? locations;

  EmployeeModel(
      {this.name,
        this.phone,
        this.email,
        this.password,
        this.salary,
        this.id,
        this.company,
        this.priorityService,
        this.locations});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    salary = json['salary'];
    company = json['company'];
    priorityService = json['Priority Service'];
    locations = json['locations'] != null
        ? new Locations.fromJson(json['locations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['salary'] = this.salary;
    data['id'] = this.id;
    data['company'] = this.company;
    data['Priority Service'] = this.priorityService;
    if (this.locations != null) {
      data['locations'] = this.locations!.toJson();
    }
    return data;
  }
}

class Locations {
  String? location1;
  String? location2;
  String? location3;
  String? location4;

  Locations({this.location1, this.location2,this.location3,this.location4});

  Locations.fromJson(Map<String, dynamic> json) {
    location1 = json['location1'];
    location2 = json['location2'];
    location3 = json['location3'];
    location4 = json['location4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location1'] = this.location1;
    data['location2'] = this.location2;
    data['location3'] = this.location3;
    data['location4'] = this.location4;
    return data;
  }
}
