import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  State<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _agreed = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final phone = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('حساب عميل جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'الاسم بالكامل')),
              const SizedBox(height: 14),
              TextField(
                enabled: false,
                controller: TextEditingController(text: phone),
                decoration: const InputDecoration(hintText: 'رقم الموبايل'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'العنوان (حي / منطقة) — الإسماعيلية'),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text('📍 هيتم تحديد موقعك على الخريطة عشان يوصلك أقرب مقدم خدمة', style: TextStyle(fontSize: 12, color: Colors.black45)),
              ),
              const SizedBox(height: 18),
              CheckboxListTile(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'موافق على الشروط والأحكام، وأتحمل مسؤولية متعلقاتي الشخصية أثناء تنفيذ الخدمة.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              PrimaryButton(label: 'إنشاء الحساب', onPressed: () => _submit(phone)),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(String phone) {
    if (_nameController.text.trim().isEmpty || _addressController.text.trim().isEmpty) {
      setState(() => _error = 'من فضلك أكمل كل البيانات');
      return;
    }
    if (!_agreed) {
      setState(() => _error = 'لازم توافق على الشروط والأحكام الأول');
      return;
    }
    final appState = pv.Provider.of<AppState>(context, listen: false);
    appState.registerClient(name: _nameController.text.trim(), phone: phone, address: _addressController.text.trim());
    Navigator.of(context).pushNamedAndRemoveUntil('/client/home', (route) => false);
  }
}
