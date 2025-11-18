import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { client, professional }

UserType userTypeFromString(String? value) {
  switch (value) {
    case 'professional':
      return UserType.professional;
    case 'client':
    default:
      return UserType.client;
  }
}

String userTypeToString(UserType type) {
  return type.name;
}

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.avatarUrl = '',
    this.location,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final String avatarUrl;
  final GeoPoint? location;
  final DateTime createdAt;

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    UserType? userType,
    String? avatarUrl,
    GeoPoint? location,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      id: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      userType: userTypeFromString(data['userType'] as String?),
      avatarUrl: data['avatarUrl'] as String? ?? '',
      location: data['location'] as GeoPoint?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userTypeToString(userType),
      'avatarUrl': avatarUrl,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
