import 'package:cloud_firestore/cloud_firestore.dart';

enum JobStatus { posted, accepted, inProgress, completed, cancelled }

JobStatus jobStatusFromString(String? value) {
  switch (value) {
    case 'accepted':
      return JobStatus.accepted;
    case 'in_progress':
      return JobStatus.inProgress;
    case 'completed':
      return JobStatus.completed;
    case 'cancelled':
      return JobStatus.cancelled;
    case 'posted':
    default:
      return JobStatus.posted;
  }
}

String jobStatusToString(JobStatus status) {
  switch (status) {
    case JobStatus.posted:
      return 'posted';
    case JobStatus.accepted:
      return 'accepted';
    case JobStatus.inProgress:
      return 'in_progress';
    case JobStatus.completed:
      return 'completed';
    case JobStatus.cancelled:
      return 'cancelled';
  }
}

class JobRequest {
  JobRequest({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.category,
    required this.locationName,
    this.professionalId,
    this.photos = const [],
    this.budget,
    this.status = JobStatus.posted,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String clientId;
  final String? professionalId;
  final String title;
  final String description;
  final String category;
  final String locationName;
  final List<String> photos;
  final double? budget;
  final JobStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  JobRequest copyWith({
    String? professionalId,
    String? title,
    String? description,
    String? category,
    String? locationName,
    List<String>? photos,
    double? budget,
    JobStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return JobRequest(
      id: id,
      clientId: clientId,
      professionalId: professionalId ?? this.professionalId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      locationName: locationName ?? this.locationName,
      photos: photos ?? this.photos,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory JobRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return JobRequest(
      id: doc.id,
      clientId: data['clientId'] as String? ?? '',
      professionalId: data['professionalId'] as String?,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      locationName: data['locationName'] as String? ?? '',
      photos: List<String>.from(data['photos'] ?? const []),
      budget: (data['budget'] as num?)?.toDouble(),
      status: jobStatusFromString(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'professionalId': professionalId,
      'title': title,
      'description': description,
      'category': category,
      'locationName': locationName,
      'photos': photos,
      'budget': budget,
      'status': jobStatusToString(status),
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}
