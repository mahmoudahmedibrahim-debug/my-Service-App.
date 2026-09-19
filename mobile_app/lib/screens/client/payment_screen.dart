import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _online = true;

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;
    final appState = pv.Provider.of<AppState>(context, listen: false);
    final request = appState.requestById(requestId);
    final provider = appState.userById(request.selectedProviderId ?? '');
    final price = request.finalPrice ?? 0;
    final commissionRate = provider?.commissionRate ?? 0.15;
    final commission = price * commissionRate;

    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _row('قيمة الخدمة', '${price.toStringAsFixed(0)} ج.م'),
                      const Divider(),
                      _row('عمولة المنصة (${(commissionRate * 100).toStringAsFixed(0)}%)', '${commission.toStringAsFixed(0)} ج.م', muted: true),
                      _row('صافي مستحق مقدم الخدمة', '${(price - commission).toStringAsFixed(0)} ج.م', muted: true),
                      const Divider(),
                      _row('الإجمالي المطلوب دفعه', '${price.toStringAsFixed(0)} ج.م', bold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              RadioGroup<bool>(
                groupValue: _online,
                onChanged: (v) => setState(() => _online = v ?? true),
                child: Column(
                  children: const [
                    RadioListTile<bool>(
                      value: true,
                      title: Text('دفع إلكتروني (بطاقة / محفظة) — يُفضّل'),
                      activeColor: AppColors.primary,
                    ),
                    RadioListTile<bool>(
                      value: false,
                      title: Text('كاش عند الاستلام'),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: _online ? 'ادفع الآن' : 'تأكيد الدفع كاش',
                onPressed: () {
                  appState.pay(requestId, online: _online);
                  Navigator.of(context).pushReplacementNamed('/client/rating', arguments: requestId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, bool muted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: muted ? Colors.black45 : AppColors.text, fontSize: muted ? 13 : 15)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 18 : 15, color: bold ? AppColors.primary : AppColors.text)),
        ],
      ),
    );
  }
}
