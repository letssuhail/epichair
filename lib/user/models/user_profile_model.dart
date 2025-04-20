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

  StaffProfile({
    this.username,
    this.imageUrl,
    this.isOnHoliday,
    this.workingHours,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      username: json['username'],
      imageUrl: json[
          'image_url'], // Note: Changed to 'image_url' to match your current code
      isOnHoliday: json['isOnHoliday'],
      workingHours: json['workingHours'] != null
          ? Map<String, String>.from(json['workingHours'])
          : null,
    );
  }
}
