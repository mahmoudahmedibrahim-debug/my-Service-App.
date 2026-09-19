import '../models/user_model.dart';

typedef IdFactory = String Function(String prefix);

/// A handful of pre-approved demo service providers so a fresh install of
/// the app already has offers to show during a demo, without needing a
/// live backend connected.
void seedDemoProviders(Map<String, UserModel> users, IdFactory nextId) {
  final demo = <UserModel>[
    UserModel(
      id: nextId('provider'),
      name: 'خالد إبراهيم',
      phone: '01011111111',
      address: 'حي أول - الإسماعيلية',
      role: UserRole.provider,
      categoryId: 'plumbing',
      providerStatus: ProviderStatus.approved,
      ratingAverage: 4.8,
      ratingCount: 42,
    ),
    UserModel(
      id: nextId('provider'),
      name: 'محمد سعيد',
      phone: '01022222222',
      address: 'المنطقة الصناعية - الإسماعيلية',
      role: UserRole.provider,
      categoryId: 'plumbing',
      providerStatus: ProviderStatus.approved,
      ratingAverage: 4.1,
      ratingCount: 15,
    ),
    UserModel(
      id: nextId('provider'),
      name: 'أحمد فتحي',
      phone: '01033333333',
      address: 'حي ثان - الإسماعيلية',
      role: UserRole.provider,
      categoryId: 'carpentry',
      providerStatus: ProviderStatus.approved,
      ratingAverage: 4.6,
      ratingCount: 28,
    ),
    UserModel(
      id: nextId('provider'),
      name: 'حازم علي',
      phone: '01044444444',
      address: 'الشيخ زايد - الإسماعيلية',
      role: UserRole.provider,
      categoryId: 'electrical',
      providerStatus: ProviderStatus.approved,
      ratingAverage: 4.9,
      ratingCount: 61,
    ),
    UserModel(
      id: nextId('provider'),
      name: 'زياد دل',
      phone: '01055555555',
      address: 'أبو عطوة - الإسماعيلية',
      role: UserRole.provider,
      categoryId: 'ac_repair',
      providerStatus: ProviderStatus.pendingReview,
      ratingAverage: 0,
      ratingCount: 0,
    ),
  ];
  for (final u in demo) {
    users[u.id] = u;
  }
}
