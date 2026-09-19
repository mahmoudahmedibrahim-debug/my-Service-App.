import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/user_model.dart';
import '../../services/phone_auth_service.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';

const _kAdminBackdoorPhone = '01000000000';

/// Real Firebase Phone Auth needs the project's Blaze (pay-as-you-go) plan
/// linked before it can send any SMS at all, including free-tier ones — the
/// team held off on linking a bank card for now, so this flips the login
/// screen back to a demo OTP (any code is accepted) until that's ready.
/// Flip to true once Blaze is enabled — the real Firebase flow below is
/// otherwise fully wired and unchanged.
const kUseRealOtp = false;

/// Phone-based login for clients and providers. Set up for real Firebase
/// Phone Authentication (SMS OTP) — see [kUseRealOtp]. The admin phone
/// number is a fixed backdoor for the founding team and always skips SMS,
/// real or demo — it never has a real subscriber behind it.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneAuth = PhoneAuthService();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _busy = false;
  String? _error;

  bool get _isAdminBackdoor => _phoneController.text.trim() == _kAdminBackdoorPhone;
  bool get _skipRealSms => _isAdminBackdoor || !kUseRealOtp;

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
              const SizedBox(height: 6),
              if (!_otpSent)
                Text(
                  kUseRealOtp ? 'هيوصلك كود تحقق حقيقي برسالة SMS' : 'نسخة تجريبية: اكتب أي كود من 4 أرقام في الخطوة الجاية',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                enabled: !_otpSent && !_busy,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(prefixText: '+20  ', hintText: '01XXXXXXXXX'),
              ),
              if (_otpSent) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  enabled: !_busy,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _skipRealSms ? 'اكتب أي كود (مثلاً 1234)' : 'اكتب كود التحقق اللي وصلك بالـ SMS',
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: _busy
                    ? '...جاري التنفيذ'
                    : (_otpSent ? 'تأكيد الكود' : 'إرسال كود التحقق'),
                onPressed: _busy ? null : () => _otpSent ? _confirmOtp(intent) : _sendOtp(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().length < 8) {
      setState(() => _error = 'أدخل رقم موبايل صحيح');
      return;
    }

    if (_skipRealSms) {
      setState(() {
        _otpSent = true;
        _error = null;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _phoneAuth.sendCode(_phoneController.text.trim());
      setState(() => _otpSent = true);
    } catch (e) {
      setState(() => _error = PhoneAuthService.describeError(e));
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _confirmOtp(String intent) async {
    final appState = pv.Provider.of<AppState>(context, listen: false);
    final phone = _phoneController.text.trim();

    if (!_skipRealSms) {
      setState(() {
        _busy = true;
        _error = null;
      });
      try {
        await _phoneAuth.confirmCode(_otpController.text.trim());
      } catch (e) {
        setState(() {
          _error = PhoneAuthService.describeError(e);
          _busy = false;
        });
        return;
      }
      setState(() => _busy = false);
    }

    if (!mounted) return;

    final user = appState.loginWithPhone(phone);
    if (user == null) {
      // Verified number, but no profile yet: send them to the matching registration flow.
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
