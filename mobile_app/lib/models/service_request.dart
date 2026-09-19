enum RequestType { repair, inspection }

enum RequestStatus {
  awaitingOffers,
  offersReceived,
  providerSelected,
  inProgress,
  completedUnpaid,
  paid,
  cancelled,
}

class ServiceRequestModel {
  final String id;
  final String clientId;
  final String categoryId;
  final String description;
  final List<String> photoPaths;
  final RequestType type;
  RequestStatus status;

  final double fairPriceMin;
  final double fairPriceMax;

  String? selectedOfferId;
  String? selectedProviderId;
  double? finalPrice;

  bool clientRated;
  bool providerRated;

  final DateTime createdAt;

  ServiceRequestModel({
    required this.id,
    required this.clientId,
    required this.categoryId,
    required this.description,
    required this.photoPaths,
    required this.type,
    required this.fairPriceMin,
    required this.fairPriceMax,
    this.status = RequestStatus.awaitingOffers,
    this.selectedOfferId,
    this.selectedProviderId,
    this.finalPrice,
    this.clientRated = false,
    this.providerRated = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
