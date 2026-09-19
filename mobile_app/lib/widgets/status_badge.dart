import 'package:flutter/material.dart';
import '../models/service_request.dart';
import '../theme/app_theme.dart';

String requestStatusLabel(RequestStatus status) {
  switch (status) {
    case RequestStatus.awaitingOffers:
      return 'بانتظار العروض';
    case RequestStatus.offersReceived:
      return 'وصلت عروض';
    case RequestStatus.providerSelected:
      return 'تم اختيار مقدم الخدمة';
    case RequestStatus.inProgress:
      return 'جاري التنفيذ';
    case RequestStatus.completedUnpaid:
      return 'بانتظار الدفع';
    case RequestStatus.paid:
      return 'مكتملة';
    case RequestStatus.cancelled:
      return 'ملغاة';
  }
}

Color requestStatusColor(RequestStatus status) {
  switch (status) {
    case RequestStatus.paid:
      return AppColors.success;
    case RequestStatus.cancelled:
      return AppColors.danger;
    case RequestStatus.inProgress:
      return AppColors.accentOrange;
    default:
      return AppColors.primary;
  }
}

class StatusBadge extends StatelessWidget {
  final RequestStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = requestStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(requestStatusLabel(status), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
