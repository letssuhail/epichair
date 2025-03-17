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

  StaffProfile({this.username, this.imageUrl});

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      username: json['username'],
      imageUrl: json['image_url'],
    );
  }
}
