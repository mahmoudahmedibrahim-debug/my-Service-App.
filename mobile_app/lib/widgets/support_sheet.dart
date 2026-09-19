import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// The support channels agreed on: a WhatsApp number for customer service
/// and a cloud-hosted support email, reachable from anywhere in the app.
void showSupportSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('خدمة العملاء', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('واتساب الدعم'),
              subtitle: const Text('+20 100 000 0000'),
              onTap: () => launchUrl(Uri.parse('https://wa.me/201000000000')),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.blue),
              title: const Text('البريد الإلكتروني'),
              subtitle: const Text('support@shatably.app'),
              onTap: () => launchUrl(Uri.parse('mailto:support@shatably.app')),
            ),
          ],
        ),
      ),
    ),
  );
}
