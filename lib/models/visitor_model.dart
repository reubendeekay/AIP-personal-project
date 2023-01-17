class VisitorModel {
  final String? name;
  final String? cnic;

  final String? phone;
  final DateTime? checkIn;
  DateTime? checkOut;

  final String? departmentId;
  final String? companyId;
  final String? department;
  final String? company;

  dynamic frontCnic;
  dynamic backCnic;

  final String? gender;
  final String? vehicleNumber;
  final int? children;
  final bool? hasVehicle;
  final bool? hasChildren;
  final String? visitorPass;

  VisitorModel(
      {this.name,
      this.cnic,
      this.phone,
      this.checkIn,
      this.checkOut,
      this.departmentId,
      this.hasChildren,
      this.hasVehicle,
      this.children,
      this.visitorPass,
      this.vehicleNumber,
      this.companyId,
      this.company,
      this.department,
      this.frontCnic,
      this.backCnic,
      this.gender});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnic': cnic!,
      'no_of_children': children,
      'vehicle_number': vehicleNumber,
      'has_vehicle': vehicleNumber != null,
      'has_child': children != null,
      'phone':
          '${phone!.substring(0, 3)}-${phone!.substring(3, phone!.length)}',
      'gender': gender!.toLowerCase().replaceAll('gender.', ''),
      'department_id': departmentId,
      'company_id': companyId,
      'front_cnic': frontCnic as String,
      'back_cnic': backCnic as String,
      'department': department,
      'company': company,
      'check_in': checkIn!.toIso8601String(),
      'check_out': checkOut != null ? checkOut!.toIso8601String() : null,
      'visitorPass': visitorPass,
    };
  }

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
        name: json['name'],
        cnic: json['cnic'],
        phone: json['phone'],
        children: json['no_of_children'],
        hasChildren: json['has_child'],
        vehicleNumber: json['vehicle_number'],
        hasVehicle: json['has_vehicle'],
        departmentId: json['department_id'],
        department: json['department'],
        checkIn:
            json['check_in'] != null ? DateTime.parse(json['check_in']) : null,
        checkOut: json['check_out'] != null
            ? DateTime.parse(json['check_out'])
            : null,
        gender: json['gender']);
  }
}
