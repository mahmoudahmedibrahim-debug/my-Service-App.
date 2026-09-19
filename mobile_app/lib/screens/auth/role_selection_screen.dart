import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.handyman_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text('أهلاً بيك في شطبلي', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('اختار هتستخدم التطبيق إزاي', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black54)),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'عميل — عايز أطلب خدمة',
                icon: Icons.person_outline,
                onPressed: () => Navigator.of(context).pushNamed('/login', arguments: 'client'),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'مقدم خدمة — عايز أشتغل',
                icon: Icons.engineering_outlined,
                outlined: true,
                onPressed: () => Navigator.of(context).pushNamed('/login', arguments: 'provider'),
              ),
              const SizedBox(height: 28),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/login', arguments: 'admin'),
                child: const Text('دخول الإدارة (Admin)', style: TextStyle(color: Colors.black38)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
