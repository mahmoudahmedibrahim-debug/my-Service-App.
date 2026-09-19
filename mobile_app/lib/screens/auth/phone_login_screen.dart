import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';

/// Mock phone + OTP login. A real build swaps the OTP step for Firebase
/// Phone Authentication; the UX and routing logic stay the same.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  bool _otpSent = false;
  final _otpController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final intent = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'client';

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                intent == 'admin' ? 'دخول لوحة الإدارة' : 'سجل دخولك برقم موبايلك',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                enabled: !_otpSent,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(prefixText: '+20  ', hintText: '01XXXXXXXXX'),
              ),
              if (_otpSent) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'كود التحقق (OTP) — 1234 تجريبيًا'),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: _otpSent ? 'تأكيد الكود' : 'إرسال كود التحقق',
                onPressed: () => _otpSent ? _confirmOtp(intent) : _sendOtp(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOtp() {
    if (_phoneController.text.trim().length < 8) {
      setState(() => _error = 'أدخل رقم موبايل صحيح');
      return;
    }
    setState(() {
      _otpSent = true;
      _error = null;
    });
  }

  void _confirmOtp(String intent) {
    final appState = pv.Provider.of<AppState>(context, listen: false);
    final phone = _phoneController.text.trim();
    final user = appState.loginWithPhone(phone);

    if (user == null) {
      // New number: send them to the matching registration flow.
      if (intent == 'provider') {
        Navigator.of(context).pushReplacementNamed('/register-provider', arguments: phone);
      } else {
        Navigator.of(context).pushReplacementNamed('/register-client', arguments: phone);
      }
      return;
    }

    _routeForUser(user);
  }

  void _routeForUser(UserModel user) {
    switch (user.role) {
      case UserRole.admin:
        Navigator.of(context).pushNamedAndRemoveUntil('/admin', (route) => false);
        break;
      case UserRole.client:
        Navigator.of(context).pushNamedAndRemoveUntil('/client/home', (route) => false);
        break;
      case UserRole.provider:
        if (user.providerStatus == ProviderStatus.approved) {
          Navigator.of(context).pushNamedAndRemoveUntil('/provider/home', (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/pending-approval', (route) => false);
        }
        break;
    }
  }
}
