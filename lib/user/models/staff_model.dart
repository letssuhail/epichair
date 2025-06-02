// import 'dart:convert';

// class StaffModel {
//   final String? message;
//   final List<StaffMember>? staffMembers;

//   StaffModel({
//     this.message,
//     this.staffMembers,
//   });

//   factory StaffModel.fromJson(Map<String, dynamic> json) {
//     return StaffModel(
//       message: json['message'] as String?,
//       staffMembers: (json['staffMembers'] as List<dynamic>?)
//           ?.map((e) => StaffMember.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'staffMembers': staffMembers?.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class StaffMember {
//   final String? id;
//   final String? username;
//   final String? phoneNumber;
//   final String? otp;
//   final DateTime? otpExpiry;
//   final bool? isVerified;
//   final bool? isTemp;
//   final String? role;
//   final List<String>? services;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final bool? isOnHoliday;
//   final WorkingHours? workingHours;
//   final String? imageUrl;
//   final String? publicId;

//   StaffMember({
//     this.id,
//     this.username,
//     this.phoneNumber,
//     this.otp,
//     this.otpExpiry,
//     this.isVerified,
//     this.isTemp,
//     this.role,
//     this.services,
//     this.createdAt,
//     this.updatedAt,
//     this.isOnHoliday,
//     this.workingHours,
//     this.imageUrl,
//     this.publicId,
//   });

//   factory StaffMember.fromJson(Map<String, dynamic> json) {
//     return StaffMember(
//       id: json['_id'] as String?,
//       username: json['username'] as String?,
//       phoneNumber: json['phoneNumber'] as String?,
//       otp: json['otp'] as String?,
//       otpExpiry: json['otpExpiry'] != null
//           ? DateTime.parse(json['otpExpiry'] as String)
//           : null,
//       isVerified: json['isVerified'] as bool?,
//       isTemp: json['isTemp'] as bool?,
//       role: json['role'] as String?,
//       services: (json['services'] as List<dynamic>?)
//           ?.map((e) => e as String)
//           .toList(),
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'] as String)
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'] as String)
//           : null,
//       isOnHoliday: json['isOnHoliday'] as bool?,
//       workingHours: json['workingHours'] != null
//           ? WorkingHours.fromJson(json['workingHours'] as Map<String, dynamic>)
//           : null,
//       imageUrl: json['image_url'] as String?,
//       publicId: json['public_id'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'username': username,
//       'phoneNumber': phoneNumber,
//       'otp': otp,
//       'otpExpiry': otpExpiry?.toIso8601String(),
//       'isVerified': isVerified,
//       'isTemp': isTemp,
//       'role': role,
//       'services': services,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'isOnHoliday': isOnHoliday,
//       'workingHours': workingHours?.toJson(),
//       'image_url': imageUrl,
//       'public_id': publicId,
//     };
//   }
// }

// class WorkingHours {
//   final String? start;
//   final String? end;

//   WorkingHours({this.start, this.end});

//   factory WorkingHours.fromJson(Map<String, dynamic> json) {
//     return WorkingHours(
//       start: json['start'] as String?,
//       end: json['end'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'start': start,
//       'end': end,
//     };
//   }
// }

class StaffModel {
  String? message;
  List<StaffWithSlot>? staffWithSlots;

  StaffModel({
    this.message,
    this.staffWithSlots,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        message: json["message"],
        staffWithSlots: json["staffWithSlots"] == null
            ? []
            : List<StaffWithSlot>.from(
                json["staffWithSlots"]!.map((x) => StaffWithSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "staffWithSlots": staffWithSlots == null
            ? []
            : List<dynamic>.from(staffWithSlots!.map((x) => x.toJson())),
      };
}

class StaffWithSlot {
  String? id;
  String? username;
  String? phoneNumber;
  DateTime? otpExpiry;
  bool? isVerified;
  bool? isTemp;
  bool? isOnHoliday;
  WorkingHours? workingHours;
  String? role;
  List<String>? services;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<dynamic>? customAvailableHours;
  List<AvailableSlot>? availableSlots;
  String? otp;
  String? imageUrl;
  String? publicId;

  StaffWithSlot({
    this.id,
    this.username,
    this.phoneNumber,
    this.otpExpiry,
    this.isVerified,
    this.isTemp,
    this.isOnHoliday,
    this.workingHours,
    this.role,
    this.services,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.customAvailableHours,
    this.availableSlots,
    this.otp,
    this.imageUrl,
    this.publicId,
  });

  factory StaffWithSlot.fromJson(Map<String, dynamic> json) => StaffWithSlot(
        id: json["_id"],
        username: json["username"],
        phoneNumber: json["phoneNumber"],
        otpExpiry: json["otpExpiry"] == null
            ? null
            : DateTime.parse(json["otpExpiry"]),
        isVerified: json["isVerified"],
        isTemp: json["isTemp"],
        isOnHoliday: json["isOnHoliday"],
        workingHours: json["workingHours"] == null
            ? null
            : WorkingHours.fromJson(json["workingHours"]),
        role: json["role"],
        services: json["services"] == null
            ? []
            : List<String>.from(json["services"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        customAvailableHours: json["customAvailableHours"] == null
            ? []
            : List<dynamic>.from(json["customAvailableHours"]!.map((x) => x)),
        availableSlots: json["availableSlots"] == null
            ? []
            : List<AvailableSlot>.from(
                json["availableSlots"]!.map((x) => AvailableSlot.fromJson(x))),
        otp: json["otp"],
        imageUrl: json["image_url"],
        publicId: json["public_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "phoneNumber": phoneNumber,
        "otpExpiry": otpExpiry?.toIso8601String(),
        "isVerified": isVerified,
        "isTemp": isTemp,
        "isOnHoliday": isOnHoliday,
        "workingHours": workingHours?.toJson(),
        "role": role,
        "services":
            services == null ? [] : List<dynamic>.from(services!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "customAvailableHours": customAvailableHours == null
            ? []
            : List<dynamic>.from(customAvailableHours!.map((x) => x)),
        "availableSlots": availableSlots == null
            ? []
            : List<dynamic>.from(availableSlots!.map((x) => x.toJson())),
        "otp": otp,
        "image_url": imageUrl,
        "public_id": publicId,
      };
}

class AvailableSlot {
  DateTime? date;
  List<Slot>? slots;

  AvailableSlot({
    this.date,
    this.slots,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) => AvailableSlot(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slots: json["slots"] == null
            ? []
            : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "slots": slots == null
            ? []
            : List<dynamic>.from(slots!.map((x) => x.toJson())),
      };
}

class Slot {
  String? time;
  bool? available;

  Slot({
    this.time,
    this.available,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        time: json["time"],
        available: json["available"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "available": available,
      };
}

class WorkingHours {
  String? start;
  String? end;

  WorkingHours({
    this.start,
    this.end,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}
