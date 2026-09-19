import 'package:flutter/material.dart';

/// A service category (plumbing, carpentry, ...). Every category covers
/// visit + labor only — parts/materials/supply are always on the client,
/// per the platform's scope decision.
class ServiceCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final IconData icon;
  final double visitFee;
  final double fairPriceMin;
  final double fairPriceMax;
  final bool involvesSupply;

  const ServiceCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.visitFee,
    required this.fairPriceMin,
    required this.fairPriceMax,
    this.involvesSupply = false,
  });
}

const List<ServiceCategory> kServiceCategories = [
  ServiceCategory(
    id: 'plumbing',
    nameAr: 'سباكة',
    nameEn: 'Plumbing',
    icon: Icons.plumbing,
    visitFee: 50,
    fairPriceMin: 100,
    fairPriceMax: 300,
    involvesSupply: true,
  ),
  ServiceCategory(
    id: 'carpentry',
    nameAr: 'نجارة',
    nameEn: 'Carpentry',
    icon: Icons.carpenter,
    visitFee: 50,
    fairPriceMin: 120,
    fairPriceMax: 400,
    involvesSupply: true,
  ),
  ServiceCategory(
    id: 'electrical',
    nameAr: 'كهرباء',
    nameEn: 'Electrical',
    icon: Icons.electrical_services,
    visitFee: 50,
    fairPriceMin: 100,
    fairPriceMax: 350,
    involvesSupply: true,
  ),
  ServiceCategory(
    id: 'painting',
    nameAr: 'نقاشة',
    nameEn: 'Painting',
    icon: Icons.format_paint,
    visitFee: 60,
    fairPriceMin: 300,
    fairPriceMax: 1500,
    involvesSupply: true,
  ),
  ServiceCategory(
    id: 'moving',
    nameAr: 'نقل عفش',
    nameEn: 'Furniture Moving',
    icon: Icons.local_shipping,
    visitFee: 0,
    fairPriceMin: 400,
    fairPriceMax: 2000,
  ),
  ServiceCategory(
    id: 'cleaning',
    nameAr: 'تنظيف منازل وسلالم',
    nameEn: 'Home & Stairs Cleaning',
    icon: Icons.cleaning_services,
    visitFee: 0,
    fairPriceMin: 150,
    fairPriceMax: 600,
  ),
  ServiceCategory(
    id: 'car_wash',
    nameAr: 'غسيل سيارات',
    nameEn: 'Car Wash',
    icon: Icons.local_car_wash,
    visitFee: 0,
    fairPriceMin: 60,
    fairPriceMax: 200,
  ),
  ServiceCategory(
    id: 'delivery',
    nameAr: 'دليفري',
    nameEn: 'Delivery',
    icon: Icons.delivery_dining,
    visitFee: 0,
    fairPriceMin: 30,
    fairPriceMax: 150,
  ),
  ServiceCategory(
    id: 'hairdressing',
    nameAr: 'حلاقة',
    nameEn: 'Hairdressing',
    icon: Icons.content_cut,
    visitFee: 0,
    fairPriceMin: 50,
    fairPriceMax: 200,
  ),
  ServiceCategory(
    id: 'ac_repair',
    nameAr: 'تكييف وتبريد',
    nameEn: 'AC & Cooling',
    icon: Icons.ac_unit,
    visitFee: 80,
    fairPriceMin: 150,
    fairPriceMax: 600,
    involvesSupply: true,
  ),
];

ServiceCategory categoryById(String id) =>
    kServiceCategories.firstWhere((c) => c.id == id, orElse: () => kServiceCategories.first);
