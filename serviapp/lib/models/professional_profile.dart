import 'package:cloud_firestore/cloud_firestore.dart';

enum VerificationStatus { pending, verified, rejected }

VerificationStatus verificationStatusFromString(String? value) {
  switch (value) {
    case 'verified':
      return VerificationStatus.verified;
    case 'rejected':
      return VerificationStatus.rejected;
    case 'pending':
    default:
      return VerificationStatus.pending;
  }
}

String verificationStatusToString(VerificationStatus status) {
  return status.name;
}

class ProfessionalProfile {
  ProfessionalProfile({
    required this.id,
    required this.userId,
    required this.professions,
    required this.description,
    required this.serviceAreas,
    this.cedula = '',
    this.references = const [],
    this.portfolio = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.verificationStatus = VerificationStatus.pending,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String userId;
  final String cedula;
  final List<String> references;
  final List<String> professions;
  final String description;
  final List<String> serviceAreas;
  final List<String> portfolio;
  final double rating;
  final int reviewCount;
  final VerificationStatus verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfessionalProfile copyWith({
    String? cedula,
    List<String>? references,
    List<String>? professions,
    String? description,
    List<String>? serviceAreas,
    List<String>? portfolio,
    double? rating,
    int? reviewCount,
    VerificationStatus? verificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalProfile(
      id: id,
      userId: userId,
      cedula: cedula ?? this.cedula,
      references: references ?? this.references,
      professions: professions ?? this.professions,
      description: description ?? this.description,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      portfolio: portfolio ?? this.portfolio,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory ProfessionalProfile.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ProfessionalProfile(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      cedula: data['cedula'] as String? ?? '',
      references: List<String>.from(data['references'] ?? const []),
      professions: List<String>.from(data['professions'] ?? const []),
      description: data['description'] as String? ?? '',
      serviceAreas: List<String>.from(data['serviceAreas'] ?? const []),
      portfolio: List<String>.from(data['portfolio'] ?? const []),
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: data['reviewCount'] as int? ?? 0,
      verificationStatus: verificationStatusFromString(
        data['verificationStatus'] as String?,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cedula': cedula,
      'references': references,
      'professions': professions,
      'description': description,
      'serviceAreas': serviceAreas,
      'portfolio': portfolio,
      'rating': rating,
      'reviewCount': reviewCount,
      'verificationStatus': verificationStatusToString(verificationStatus),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
