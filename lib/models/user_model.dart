class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? password;
  final String? department;
  final bool isAdmin;
  final String? company;
  final String? companyId;
  final List? departments;

  UserModel(
      {this.id,
      this.name,
      this.phone,
      this.password,
      this.department,
      this.company,
      this.departments,
      this.companyId,
      this.isAdmin = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
      'department': department,
      'is_admin': isAdmin,
      'company_id': companyId,
      'company': company,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        password: json['password'],
        department: json['department'],
        company: json['company'],
        companyId: json['company_id'],
        departments: json['departments'],
        isAdmin: json['is_admin']);
  }
}
