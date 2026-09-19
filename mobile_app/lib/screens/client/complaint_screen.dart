import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/complaint_model.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/support_sheet.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  ComplaintType _type = ComplaintType.serviceIssue;
  final _descController = TextEditingController();
  final List<XFile> _photos = [];
  bool _submitted = false;

  static const _labels = {
    ComplaintType.serviceIssue: 'مشكلة في الخدمة',
    ComplaintType.fraudOrMisconduct: 'نصب / سوء سلوك',
    ComplaintType.appIssue: 'مشكلة في التطبيق',
    ComplaintType.other: 'أخرى',
  };

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)?.settings.arguments as String?;

    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('الشكاوى')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 56),
                const SizedBox(height: 16),
                const Text('تم استلام شكواك وهيتم مراجعتها', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                PrimaryButton(label: 'رجوع', onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تقديم شكوى')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('نوع الشكوى', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ComplaintType.values.map((t) {
                  final selected = _type == t;
                  return ChoiceChip(
                    label: Text(_labels[t]!),
                    selected: selected,
                    onSelected: (_) => setState(() => _type = t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'اشرح المشكلة بالتفصيل'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (f != null) setState(() => _photos.add(f));
                  } catch (_) {}
                },
                icon: const Icon(Icons.attach_file),
                label: Text(_photos.isEmpty ? 'إرفاق صور كدليل' : 'تم إرفاق ${_photos.length} صورة'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'إرسال الشكوى', onPressed: () => _submit(requestId)),
              const SizedBox(height: 10),
              TextButton(onPressed: () => showSupportSheet(context), child: const Text('محتاج تتكلم مع حد؟ تواصل معانا')),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(String? requestId) {
    if (_descController.text.trim().isEmpty) return;
    final appState = pv.Provider.of<AppState>(context, listen: false);
    appState.fileComplaint(
      userId: appState.currentUser!.id,
      requestId: requestId,
      type: _type,
      description: _descController.text.trim(),
      photoPaths: _photos.map((p) => p.path).toList(),
    );
    setState(() => _submitted = true);
  }
}
