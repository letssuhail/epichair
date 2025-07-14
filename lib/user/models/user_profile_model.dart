class UserProfile {
  final String? username;
  final String? imageUrl;

  UserProfile({this.username, this.imageUrl});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      imageUrl: json['image_url'],
    );
  }
}

class StaffProfile {
  final String? username;
  final String? imageUrl;
  final bool? isOnHoliday;
  final Map<String, String>? workingHours;
  final List<CustomAvailableHour>? customAvailableHours;
  final List<HolidayDate>? holidayDates;

  StaffProfile({
    this.username,
    this.imageUrl,
    this.isOnHoliday,
    this.workingHours,
    this.customAvailableHours,
    this.holidayDates,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      username: json['username'],
      imageUrl: json['image_url'],
      isOnHoliday: json['isOnHoliday'],
      workingHours: json['workingHours'] != null
          ? Map<String, String>.from(json['workingHours'])
          : null,
      customAvailableHours: json['customAvailableHours'] != null
          ? List<CustomAvailableHour>.from(
              json['customAvailableHours']
                  .map((x) => CustomAvailableHour.fromJson(x)),
            )
          : null,
      holidayDates: json['holidayDates'] != null
          ? List<HolidayDate>.from(
              json['holidayDates'].map((x) => HolidayDate.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'image_url': imageUrl,
      'isOnHoliday': isOnHoliday,
      'workingHours': workingHours,
      'customAvailableHours':
          customAvailableHours?.map((e) => e.toJson()).toList(),
      'holidayDates': holidayDates?.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomAvailableHour {
  final String date;
  final String start;
  final String end;

  CustomAvailableHour({
    required this.date,
    required this.start,
    required this.end,
  });

  factory CustomAvailableHour.fromJson(Map<String, dynamic> json) {
    return CustomAvailableHour(
      date: json['date'],
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'start': start,
      'end': end,
    };
  }
}

class HolidayDate {
  final String from;
  final String to;

  HolidayDate({
    required this.from,
    required this.to,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) {
    return HolidayDate(
      from: json['from'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}
