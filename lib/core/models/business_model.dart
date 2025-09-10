import 'dart:convert';

import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  const BusinessModel({
    required this.name,
    required this.location,
    required this.phone,
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    final name = map['biz_name']?.toString().trim();
    final location = map['bss_location']?.toString().trim();
    final contactNumber = map['contct_no']?.toString().trim();

    if (name == null || name.isEmpty) {
      throw ArgumentError('Invalid business name');
    }
    if (location == null || location.isEmpty) {
      throw ArgumentError('Invalid business location');
    }
    if (contactNumber == null || !_isValidPhone(contactNumber)) {
      throw ArgumentError('Invalid contact number');
    }
    return BusinessModel(
      name: name,
      location: location,
      phone: contactNumber,
    );
  }

  factory BusinessModel.fromJson(String source) =>
      BusinessModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String name;
  final String location;
  final String phone;

  BusinessModel copyWith({
    String? name,
    String? location,
    String? phone,
  }) {
    return BusinessModel(
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'location': location,
      'phone': phone,
    };
  }

  static bool _isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^\+?[0-9\s-]+$');
    return phoneRegExp.hasMatch(phone);
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, location, phone];
}
