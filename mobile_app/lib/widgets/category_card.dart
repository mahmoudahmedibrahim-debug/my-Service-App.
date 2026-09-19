import 'package:flutter/material.dart';
import '../models/service_category.dart';
import '../theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final VoidCallback onTap;
  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(category.icon, size: 34, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(category.nameAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
