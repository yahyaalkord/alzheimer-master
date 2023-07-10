class PatientModel {
  late String patientId;
  late String name;
  late String email;
  late String phone;
  late String password;
  late bool isAdmin;
  late String token;
  PatientModel({
    required this.patientId,
    required this.name,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.phone,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      "patientId": patientId,
      "name": name,
      "email": email,
      "password": password,
      "isAdmin": isAdmin,
      "phone": phone,
      "token": token
    };
  }
}
