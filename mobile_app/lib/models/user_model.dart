enum UserRole { client, provider, admin }

enum ProviderStatus { pendingReview, approved, rejected }

class UserModel {
  final String id;
  String name;
  String phone;
  String address;
  final UserRole role;

  // Provider-only fields
  String? categoryId;
  String? idDocumentPath;
  ProviderStatus providerStatus;

  double ratingAverage;
  int ratingCount;
  bool termsAccepted;

  /// Client cannot create a new request while a past request awaits their rating.
  bool hasPendingRating;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.role,
    this.categoryId,
    this.idDocumentPath,
    this.providerStatus = ProviderStatus.approved,
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.termsAccepted = false,
    this.hasPendingRating = false,
  });

  /// Providers rated 4.5+ get a reduced platform commission as an incentive.
  double get commissionRate => ratingAverage >= 4.5 && ratingCount >= 3 ? 0.12 : 0.15;

  bool get isTopRated => ratingAverage >= 4.5 && ratingCount >= 3;
}
