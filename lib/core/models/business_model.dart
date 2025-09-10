import 'dart:convert';

import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  const BusinessModel({
    required this.name,
    required this.location,
    required this.phone,
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      name: (map['name'] ?? '') as String,
      location: (map['location'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
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

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, location, phone];
}
