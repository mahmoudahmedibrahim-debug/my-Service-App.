import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/service_category.dart';
import '../../models/service_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _descController = TextEditingController();
  final List<XFile> _photos = [];
  RequestType _type = RequestType.repair;

  @override
  Widget build(BuildContext context) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as String;
    final category = categoryById(categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(category.nameAr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('وضّح المشكلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'اكتب وصف العطل... مثال: حنفية المطبخ بتسرب مياه'),
              ),
              const SizedBox(height: 18),
              const Text('صوّر العطل (اختياري بس بيساعد في تحديد السعر)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _PhotosRow(photos: _photos, onAdd: _addPhoto),
              const SizedBox(height: 22),
              const Text('نوع الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _TypeSelector(type: _type, onChanged: (t) => setState(() => _type = t)),
              const SizedBox(height: 10),
              if (category.involvesSupply)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'ملحوظة: الخدمة تشمل الزيارة والصيانة فقط، وتوريد قطع الغيار/الخامات مسؤولية العميل.',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ),
              if (_type == RequestType.inspection)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    'مش عارف العطل بالظبط؟ هيتم تحصيل رسوم كشف قدرها ${category.visitFee.toStringAsFixed(0)} ج.م، وبعد ما يتحدد العطل تقدر تكمل الطلب من التطبيق أو تتفق مع الفني مباشرة.',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              const SizedBox(height: 12),
              PrimaryButton(label: 'التالي — عرض السعر المبدئي', onPressed: _showFairPricePreview),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addPhoto() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => _photos.add(file));
    } catch (_) {
      // Picker may be unavailable in some demo environments — ignore.
    }
  }

  void _showFairPricePreview() {
    final categoryId = ModalRoute.of(context)!.settings.arguments as String;
    final category = categoryById(categoryId);
    final min = _type == RequestType.inspection ? category.visitFee : category.fairPriceMin;
    final max = _type == RequestType.inspection ? category.visitFee : category.fairPriceMax;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.price_check_rounded, size: 40, color: AppColors.primary),
              const SizedBox(height: 12),
              const Text('السعر المبدئي العادل (Fair Price)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text('${min.toStringAsFixed(0)} — ${max.toStringAsFixed(0)} ج.م', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 8),
              const Text('ده تقدير مبدئي فقط — مقدمي الخدمة هيبعتوا عروضهم وتقدر تختار الأنسب ليك.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 20),
              PrimaryButton(label: 'إرسال الطلب لمقدمي الخدمة', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final categoryId = ModalRoute.of(context)!.settings.arguments as String;
    final appState = pv.Provider.of<AppState>(context, listen: false);
    final request = appState.createRequest(
      clientId: appState.currentUser!.id,
      categoryId: categoryId,
      description: _descController.text.trim(),
      photoPaths: _photos.map((p) => p.path).toList(),
      type: _type,
    );
    Navigator.of(context)
      ..pop()
      ..pushReplacementNamed('/client/offers', arguments: request.id);
  }
}

class _PhotosRow extends StatelessWidget {
  final List<XFile> photos;
  final VoidCallback onAdd;
  const _PhotosRow({required this.photos, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...photos.map((p) => Container(
                margin: const EdgeInsets.only(left: 10),
                width: 84,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.primaryLight),
                child: const Icon(Icons.image, color: AppColors.primary),
              )),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 84,
              decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.add_a_photo_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final RequestType type;
  final ValueChanged<RequestType> onChanged;
  const _TypeSelector({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _typeChip(context, 'صيانة / تصليح', RequestType.repair),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _typeChip(context, 'كشف فقط (مش عارف العطل)', RequestType.inspection),
        ),
      ],
    );
  }

  Widget _typeChip(BuildContext context, String label, RequestType value) {
    final selected = type == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : Colors.black12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12.5),
        ),
      ),
    );
  }
}
