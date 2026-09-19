enum ComplaintType { serviceIssue, fraudOrMisconduct, appIssue, other }

enum ComplaintStatus { open, inReview, resolved }

class ComplaintModel {
  final String id;
  final String userId;
  final String? requestId;
  final ComplaintType type;
  final String description;
  final List<String> photoPaths;
  ComplaintStatus status;
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.userId,
    this.requestId,
    required this.type,
    required this.description,
    this.photoPaths = const [],
    this.status = ComplaintStatus.open,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
