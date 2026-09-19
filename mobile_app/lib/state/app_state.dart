import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/complaint_model.dart';
import '../models/offer_model.dart';
import '../models/service_category.dart';
import '../models/service_request.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';

/// Central in-memory "backend" for the demo build of the app.
///
/// This mirrors the data + business rules agreed on in the project SOW
/// (fair pricing, 15% commission with a reduced rate for top-rated
/// providers, mandatory rating gate, provider admin approval, etc.) behind
/// a single class so a real backend (Firebase / REST API) can later replace
/// just this file without touching any screen.
class AppState extends ChangeNotifier {
  final Map<String, UserModel> _users = {};
  final List<ServiceRequestModel> _requests = [];
  final List<OfferModel> _offers = [];
  final List<ComplaintModel> _complaints = [];

  UserModel? currentUser;

  int _idCounter = 1000;
  String _nextId(String prefix) => '$prefix-${_idCounter++}';

  AppState() {
    seedDemoProviders(_users, _nextId);
  }

  // ---------------------------------------------------------------- auth

  List<ServiceCategory> get categories => kServiceCategories;

  UserModel registerClient({required String name, required String phone, required String address}) {
    final user = UserModel(
      id: _nextId('client'),
      name: name,
      phone: phone,
      address: address,
      role: UserRole.client,
      termsAccepted: true,
    );
    _users[user.id] = user;
    currentUser = user;
    notifyListeners();
    return user;
  }

  UserModel registerProvider({
    required String name,
    required String phone,
    required String address,
    required String categoryId,
    required String idDocumentPath,
  }) {
    final user = UserModel(
      id: _nextId('provider'),
      name: name,
      phone: phone,
      address: address,
      role: UserRole.provider,
      categoryId: categoryId,
      idDocumentPath: idDocumentPath,
      providerStatus: ProviderStatus.pendingReview,
      termsAccepted: true,
    );
    _users[user.id] = user;
    currentUser = user;
    notifyListeners();
    return user;
  }

  /// Demo login: looks the phone number up (or logs an admin in with a
  /// fixed demo phone). A real build swaps this for Firebase Phone-Auth OTP.
  UserModel? loginWithPhone(String phone) {
    if (phone == '01000000000') {
      final admin = _users.putIfAbsent(
        'admin-1',
        () => UserModel(id: 'admin-1', name: 'Admin', phone: phone, address: '-', role: UserRole.admin),
      );
      currentUser = admin;
      notifyListeners();
      return admin;
    }
    final match = _users.values.where((u) => u.phone == phone).toList();
    if (match.isEmpty) return null;
    currentUser = match.first;
    notifyListeners();
    return currentUser;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  // -------------------------------------------------------------- admin

  List<UserModel> get pendingProviders =>
      _users.values.where((u) => u.role == UserRole.provider && u.providerStatus == ProviderStatus.pendingReview).toList();

  List<UserModel> get allProviders => _users.values.where((u) => u.role == UserRole.provider).toList();

  void approveProvider(String userId) {
    _users[userId]?.providerStatus = ProviderStatus.approved;
    notifyListeners();
  }

  void rejectProvider(String userId) {
    _users[userId]?.providerStatus = ProviderStatus.rejected;
    notifyListeners();
  }

  // ------------------------------------------------------------ requests

  /// A client with a completed-but-unrated request is blocked from opening
  /// a new one, per the mandatory-rating rule agreed on in the flowchart.
  ServiceRequestModel? pendingRatingRequest(String clientId) {
    for (final r in _requests) {
      if (r.clientId == clientId && r.status == RequestStatus.paid && !r.clientRated) {
        return r;
      }
    }
    return null;
  }

  List<ServiceRequestModel> requestsForClient(String clientId) =>
      _requests.where((r) => r.clientId == clientId).toList().reversed.toList();

  /// Requests visible to a provider's feed: same category, still open for offers.
  List<ServiceRequestModel> requestsForProviderCategory(String categoryId, String providerId) {
    return _requests.where((r) {
      final sameCategory = r.categoryId == categoryId;
      final open = r.status == RequestStatus.awaitingOffers || r.status == RequestStatus.offersReceived;
      final alreadyOffered = _offers.any((o) => o.requestId == r.id && o.providerId == providerId);
      return sameCategory && open && !alreadyOffered;
    }).toList().reversed.toList();
  }

  List<ServiceRequestModel> activeJobsForProvider(String providerId) => _requests
      .where((r) => r.selectedProviderId == providerId &&
          (r.status == RequestStatus.providerSelected || r.status == RequestStatus.inProgress))
      .toList();

  ServiceRequestModel createRequest({
    required String clientId,
    required String categoryId,
    required String description,
    required List<String> photoPaths,
    required RequestType type,
  }) {
    final cat = categoryById(categoryId);
    final request = ServiceRequestModel(
      id: _nextId('req'),
      clientId: clientId,
      categoryId: categoryId,
      description: description,
      photoPaths: photoPaths,
      type: type,
      fairPriceMin: type == RequestType.inspection ? cat.visitFee : cat.fairPriceMin,
      fairPriceMax: type == RequestType.inspection ? cat.visitFee : cat.fairPriceMax,
    );
    _requests.add(request);
    notifyListeners();
    _simulateIncomingOffers(request);
    return request;
  }

  /// For the demo build: a couple of nearby verified providers "see" the
  /// broadcast request and send competing offers shortly after — the same
  /// InDrive-style bidding behaviour described for the real backend.
  void _simulateIncomingOffers(ServiceRequestModel request) {
    final providers = allProviders
        .where((p) => p.categoryId == request.categoryId && p.providerStatus == ProviderStatus.approved)
        .toList();
    if (providers.isEmpty) return;

    for (var i = 0; i < providers.length; i++) {
      Timer(Duration(seconds: 2 + i * 2), () {
        final base = (request.fairPriceMin + request.fairPriceMax) / 2;
        final variance = (i - providers.length / 2) * (base * 0.06);
        final price = (base + variance).roundToDouble();
        submitOffer(requestId: request.id, providerId: providers[i].id, price: price, message: providers[i].isTopRated ? 'متاح دلوقتي، تقييمي عالي 👍' : 'متاح للخدمة النهاردة');
      });
    }
  }

  OfferModel submitOffer({
    required String requestId,
    required String providerId,
    required double price,
    String message = '',
  }) {
    final offer = OfferModel(id: _nextId('offer'), requestId: requestId, providerId: providerId, price: price, message: message);
    _offers.add(offer);
    final request = _requests.firstWhere((r) => r.id == requestId);
    if (request.status == RequestStatus.awaitingOffers) {
      request.status = RequestStatus.offersReceived;
    }
    notifyListeners();
    return offer;
  }

  List<OfferModel> offersForRequest(String requestId) =>
      _offers.where((o) => o.requestId == requestId).toList()..sort((a, b) => a.price.compareTo(b.price));

  UserModel? userById(String id) => _users[id];

  ServiceRequestModel requestById(String id) => _requests.firstWhere((r) => r.id == id);

  void selectOffer(String requestId, String offerId) {
    final request = _requests.firstWhere((r) => r.id == requestId);
    final offer = _offers.firstWhere((o) => o.id == offerId);
    offer.status = OfferStatus.accepted;
    for (final o in _offers.where((o) => o.requestId == requestId && o.id != offerId)) {
      o.status = OfferStatus.rejected;
    }
    request.selectedOfferId = offerId;
    request.selectedProviderId = offer.providerId;
    request.finalPrice = offer.price;
    request.status = RequestStatus.providerSelected;
    notifyListeners();
  }

  void startService(String requestId) {
    _requests.firstWhere((r) => r.id == requestId).status = RequestStatus.inProgress;
    notifyListeners();
  }

  void completeService(String requestId) {
    _requests.firstWhere((r) => r.id == requestId).status = RequestStatus.completedUnpaid;
    notifyListeners();
  }

  /// Returns the commission amount deducted from the provider's payout.
  double pay(String requestId, {required bool online}) {
    final request = _requests.firstWhere((r) => r.id == requestId);
    final provider = _users[request.selectedProviderId];
    final rate = provider?.commissionRate ?? 0.15;
    final commission = (request.finalPrice ?? 0) * rate;
    request.status = RequestStatus.paid;
    notifyListeners();
    return commission;
  }

  void rate({required String requestId, required bool clientRatesProvider, required double stars, required String comment}) {
    final request = _requests.firstWhere((r) => r.id == requestId);
    final targetId = clientRatesProvider ? request.selectedProviderId : request.clientId;
    final target = _users[targetId];
    if (target != null) {
      final total = target.ratingAverage * target.ratingCount + stars;
      target.ratingCount += 1;
      target.ratingAverage = total / target.ratingCount;
    }
    if (clientRatesProvider) {
      request.clientRated = true;
    } else {
      request.providerRated = true;
    }
    notifyListeners();
  }

  void fileComplaint({
    required String userId,
    String? requestId,
    required ComplaintType type,
    required String description,
    List<String> photoPaths = const [],
  }) {
    _complaints.add(ComplaintModel(
      id: _nextId('complaint'),
      userId: userId,
      requestId: requestId,
      type: type,
      description: description,
      photoPaths: photoPaths,
    ));
    notifyListeners();
  }

  List<ComplaintModel> get complaints => _complaints.reversed.toList();

  void resolveComplaint(String id) {
    _complaints.firstWhere((c) => c.id == id).status = ComplaintStatus.resolved;
    notifyListeners();
  }

  // -------------------------------------------------------------- stats

  int get totalUsers => _users.length;
  int get totalRequests => _requests.length;
  double get totalCommissionCollected {
    double sum = 0;
    for (final r in _requests.where((r) => r.status == RequestStatus.paid)) {
      final provider = _users[r.selectedProviderId];
      sum += (r.finalPrice ?? 0) * (provider?.commissionRate ?? 0.15);
    }
    return sum;
  }
}
