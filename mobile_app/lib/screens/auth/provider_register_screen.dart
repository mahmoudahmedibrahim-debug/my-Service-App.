import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_category.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _categoryId = kServiceCategories.first.id;
  XFile? _idDocument;
  bool _agreed = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final phone = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('انضم كمقدم خدمة')),
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
              TextField(controller: _addressController, decoration: const InputDecoration(hintText: 'العنوان — الإسماعيلية')),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                decoration: const InputDecoration(hintText: 'نوع الخدمة / الكاتيجوري'),
                items: kServiceCategories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nameAr)))
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v ?? _categoryId),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _pickDocument,
                icon: const Icon(Icons.badge_outlined),
                label: Text(_idDocument == null ? 'رفع صورة البطاقة الشخصية' : 'تم اختيار: ${_idDocument!.name}'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
              ),
              const SizedBox(height: 18),
              CheckboxListTile(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'موافق على الشروط والأحكام، وأتحمّل المسؤولية القانونية الكاملة عن أي خطأ في تنفيذ الخدمة، '
                  'وأوافق على مشاركة بياناتي مع الجهات المختصة عند الحاجة.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 4, bottom: 8),
                child: Text('ملحوظة: الخدمة تشمل الزيارة والصيانة فقط، وتوريد قطع الغيار مسؤولية العميل.', style: TextStyle(fontSize: 12, color: Colors.black45)),
              ),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              PrimaryButton(label: 'إرسال طلب الانضمام', onPressed: () => _submit(phone)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDocument() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => _idDocument = file);
    } catch (_) {
      // Image picker may be unavailable in some environments (e.g. desktop demo) — ignore.
    }
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
    appState.registerProvider(
      name: _nameController.text.trim(),
      phone: phone,
      address: _addressController.text.trim(),
      categoryId: _categoryId,
      idDocumentPath: _idDocument?.path ?? 'demo-id-document.jpg',
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/pending-approval', (route) => false);
  }
}
