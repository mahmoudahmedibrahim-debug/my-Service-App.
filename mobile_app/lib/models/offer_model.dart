enum OfferStatus { pending, accepted, rejected }

class OfferModel {
  final String id;
  final String requestId;
  final String providerId;
  final double price;
  final String message;
  OfferStatus status;
  final DateTime createdAt;

  OfferModel({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.price,
    this.message = '',
    this.status = OfferStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
