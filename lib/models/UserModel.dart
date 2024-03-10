class UserModel {
  UserModel({name, email, department});
  late String name;
  late String email;
  late String department;
  late String sessionId;

  UserModel.fromJSON(Map<String, dynamic> json) : name = json['name'] ?? '';
}
