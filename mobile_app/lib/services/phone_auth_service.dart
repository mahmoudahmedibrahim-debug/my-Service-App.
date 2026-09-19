import 'package:firebase_auth/firebase_auth.dart';

/// Converts a local Egyptian number (e.g. "01012345678") to E.164
/// ("+201012345678") for Firebase Phone Auth. Accepts a number already in
/// E.164 form unchanged.
String toE164Egypt(String localPhone) {
  final digits = localPhone.trim().replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.startsWith('+')) return digits;
  if (digits.startsWith('20')) return '+$digits';
  if (digits.startsWith('0')) return '+20${digits.substring(1)}';
  return '+20$digits';
}

/// Thin wrapper around Firebase Phone Authentication (web flow): send a real
/// SMS code via [sendCode], then verify what the user typed via [confirmCode].
class PhoneAuthService {
  ConfirmationResult? _confirmationResult;

  Future<void> sendCode(String localPhone) async {
    final e164 = toE164Egypt(localPhone);
    _confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(e164);
  }

  Future<User> confirmCode(String smsCode) async {
    final pending = _confirmationResult;
    if (pending == null) {
      throw StateError('لازم تبعت كود التحقق الأول قبل ما تأكده.');
    }
    final credential = await pending.confirm(smsCode);
    final user = credential.user;
    if (user == null) {
      throw StateError('فشل التحقق من الكود.');
    }
    return user;
  }

  /// Arabic-friendly message for common Firebase Auth error codes.
  static String describeError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'رقم الموبايل مش صحيح.';
        case 'too-many-requests':
          return 'محاولات كتير، حاول تاني بعد شوية.';
        case 'invalid-verification-code':
          return 'كود التحقق غلط.';
        case 'code-expired':
          return 'الكود انتهت صلاحيته، ابعت كود جديد.';
        case 'unauthorized-domain':
          return 'الدومين ده مش مسموح بيه في إعدادات Firebase (Authorized domains).';
        case 'billing-not-enabled':
          return 'لازم تفعّل خطة Blaze في مشروع Firebase عشان الـ Phone Authentication يشتغل.';
        default:
          return error.message ?? 'حصل خطأ (${error.code})';
      }
    }
    return error.toString();
  }
}
