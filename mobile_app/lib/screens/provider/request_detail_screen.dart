import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late final TextEditingController _priceController;
  final _messageController = TextEditingController();
  bool _initialized = false;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;
    final appState = pv.Provider.of<AppState>(context, listen: false);
    final request = appState.requestById(requestId);

    if (!_initialized) {
      final mid = ((request.fairPriceMin + request.fairPriceMax) / 2).roundToDouble();
      _priceController = TextEditingController(text: mid.toStringAsFixed(0));
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.type == RequestType.inspection ? 'كشف فقط' : 'صيانة / تصليح', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const SizedBox(height: 8),
                      Text(request.description.isEmpty ? 'بدون وصف' : request.description),
                      const SizedBox(height: 10),
                      Text('السعر العادل المقترح: ${request.fairPriceMin.toStringAsFixed(0)} - ${request.fairPriceMax.toStringAsFixed(0)} ج.م', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      if (request.photoPaths.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text('عدد الصور المرفقة: ${request.photoPaths.length}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_sent)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('تم إرسال عرضك، هيتم إعلامك لو العميل اختارك ✅')),
                )
              else ...[
                const Text('عرض سعرك', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(suffixText: 'ج.م'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(hintText: 'رسالة للعميل (اختياري)'),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'إرسال العرض',
                  onPressed: () {
                    final price = double.tryParse(_priceController.text) ?? request.fairPriceMin;
                    appState.submitOffer(requestId: requestId, providerId: appState.currentUser!.id, price: price, message: _messageController.text.trim());
                    setState(() => _sent = true);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
