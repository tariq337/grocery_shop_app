class UserProfileModels {
  bool? active;
  String? groceryDescription;
  String? groceryName;
  String? joinDate;
  String? location;
  String? locationDescription;
  int? menuCount;
  String? phoneNumber;
  String? userDescription;
  int? userId;
  String? userName;

  UserProfileModels(
      {this.active,
      this.groceryDescription,
      this.groceryName,
      this.joinDate,
      this.location,
      this.locationDescription,
      this.menuCount,
      this.phoneNumber,
      this.userDescription,
      this.userId,
      this.userName});

  UserProfileModels.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    groceryDescription = json['grocery description'] ?? 'لايوجد';
    groceryName = json['grocery name'];
    joinDate = json['join date'];
    location = json['location'];
    locationDescription = json['location_description'] ?? 'لايوجد';
    menuCount = json['menu_count'];
    phoneNumber = json['phone number'];
    userDescription = json['user description'] ?? 'لايوجد';
    userId = json['user id'];
    userName = json['user name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['grocery description'] = groceryDescription;
    data['grocery name'] = groceryName;
    data['join date'] = joinDate;
    data['location'] = location;
    data['location_description'] = locationDescription;
    data['menu_count'] = menuCount;
    data['phone number'] = phoneNumber;
    data['user description'] = userDescription;
    data['user id'] = userId;
    data['user name'] = userName;
    return data;
  }
}
