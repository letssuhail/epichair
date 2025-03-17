class Staff {
  final String id;
  final String username;
  final String phoneNumber;
  final bool isVerified;
  final List<String> services;
  final String? imageUrl;

  Staff({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.isVerified,
    required this.services,
    this.imageUrl,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['_id'] ?? '',
      username: json['username'] ?? 'New Stylist',
      phoneNumber: json['phoneNumber'] ?? 'No Phone',
      isVerified: json['isVerified'] ?? false,
      services: List<String>.from(json['services'] ?? []),
      imageUrl: json['image_url'], // nullable field
    );
  }
}
