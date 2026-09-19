import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rating_stars.dart';

/// Mandatory rating step: the client cannot open a new request until this
/// is submitted, per the platform's risk-mitigation rule.
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _stars = 5;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: const Text('قيّم الخدمة')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Icon(Icons.emoji_emotions_outlined, size: 56, color: Colors.orange),
                const SizedBox(height: 12),
                const Text('إزاي كانت تجربتك مع مقدم الخدمة؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                const Text('التقييم إجباري ومطلوب عشان تقدر تفتح طلب جديد', style: TextStyle(fontSize: 12, color: Colors.black45), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                InteractiveRatingStars(rating: _stars, onChanged: (v) => setState(() => _stars = v)),
                const SizedBox(height: 24),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'اكتب تعليق (اختياري)'),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'إرسال التقييم',
                  onPressed: () {
                    final appState = pv.Provider.of<AppState>(context, listen: false);
                    appState.rate(requestId: requestId, clientRatesProvider: true, stars: _stars, comment: _commentController.text.trim());
                    Navigator.of(context).pushNamedAndRemoveUntil('/client/home', (route) => false);
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/client/complaint', arguments: requestId),
                  child: const Text('في مشكلة حصلت؟ اعمل شكوى', style: TextStyle(color: Colors.black45)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
