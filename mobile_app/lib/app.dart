import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/client_register_screen.dart';
import 'screens/auth/pending_approval_screen.dart';
import 'screens/auth/phone_login_screen.dart';
import 'screens/auth/provider_register_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/approve_providers_screen.dart';
import 'screens/admin/complaints_review_screen.dart';
import 'screens/client/client_home_screen.dart';
import 'screens/client/client_profile_screen.dart';
import 'screens/client/complaint_screen.dart';
import 'screens/client/create_request_screen.dart';
import 'screens/client/offers_screen.dart';
import 'screens/client/payment_screen.dart';
import 'screens/client/rating_screen.dart';
import 'screens/client/tracking_screen.dart';
import 'screens/provider/active_job_screen.dart';
import 'screens/provider/provider_home_screen.dart';
import 'screens/provider/provider_profile_screen.dart';
import 'screens/provider/request_detail_screen.dart';
import 'theme/app_theme.dart';

class ShatablyApp extends StatelessWidget {
  const ShatablyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شطبلي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/role': (context) => const RoleSelectionScreen(),
        '/login': (context) => const PhoneLoginScreen(),
        '/register-client': (context) => const ClientRegisterScreen(),
        '/register-provider': (context) => const ProviderRegisterScreen(),
        '/pending-approval': (context) => const PendingApprovalScreen(),

        '/client/home': (context) => const ClientHomeScreen(),
        '/client/create-request': (context) => const CreateRequestScreen(),
        '/client/offers': (context) => const OffersScreen(),
        '/client/tracking': (context) => const TrackingScreen(),
        '/client/payment': (context) => const PaymentScreen(),
        '/client/rating': (context) => const RatingScreen(),
        '/client/complaint': (context) => const ComplaintScreen(),
        '/client/profile': (context) => const ClientProfileScreen(),

        '/provider/home': (context) => const ProviderHomeScreen(),
        '/provider/request-detail': (context) => const RequestDetailScreen(),
        '/provider/active-job': (context) => const ActiveJobScreen(),
        '/provider/profile': (context) => const ProviderProfileScreen(),

        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/approve-providers': (context) => const ApproveProvidersScreen(),
        '/admin/complaints': (context) => const ComplaintsReviewScreen(),
      },
    );
  }
}
