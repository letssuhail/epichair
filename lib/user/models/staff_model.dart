import 'dart:convert';

class StaffModel {
  final String? message;
  final List<StaffMember>? staffMembers;

  StaffModel({
    this.message,
    this.staffMembers,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      message: json['message'] as String?,
      staffMembers: (json['staffMembers'] as List<dynamic>?)
          ?.map((e) => StaffMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'staffMembers': staffMembers?.map((e) => e.toJson()).toList(),
    };
  }
}

class StaffMember {
  final String? id;
  final String? username;
  final String? phoneNumber;
  final String? otp;
  final DateTime? otpExpiry;
  final bool? isVerified;
  final bool? isTemp;
  final String? role;
  final List<String>? services;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isOnHoliday;
  final WorkingHours? workingHours;
  final String? imageUrl;
  final String? publicId;

  StaffMember({
    this.id,
    this.username,
    this.phoneNumber,
    this.otp,
    this.otpExpiry,
    this.isVerified,
    this.isTemp,
    this.role,
    this.services,
    this.createdAt,
    this.updatedAt,
    this.isOnHoliday,
    this.workingHours,
    this.imageUrl,
    this.publicId,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      otp: json['otp'] as String?,
      otpExpiry: json['otpExpiry'] != null
          ? DateTime.parse(json['otpExpiry'] as String)
          : null,
      isVerified: json['isVerified'] as bool?,
      isTemp: json['isTemp'] as bool?,
      role: json['role'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isOnHoliday: json['isOnHoliday'] as bool?,
      workingHours: json['workingHours'] != null
          ? WorkingHours.fromJson(json['workingHours'] as Map<String, dynamic>)
          : null,
      imageUrl: json['image_url'] as String?,
      publicId: json['public_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'phoneNumber': phoneNumber,
      'otp': otp,
      'otpExpiry': otpExpiry?.toIso8601String(),
      'isVerified': isVerified,
      'isTemp': isTemp,
      'role': role,
      'services': services,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isOnHoliday': isOnHoliday,
      'workingHours': workingHours?.toJson(),
      'image_url': imageUrl,
      'public_id': publicId,
    };
  }
}

class WorkingHours {
  final String? start;
  final String? end;

  WorkingHours({this.start, this.end});

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      start: json['start'] as String?,
      end: json['end'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}
