import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/activity_model.dart';
import '../theme/theme.dart';

part 'activity_notifier.g.dart';

@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  @override
  List<ActivityModel> build() {
    return const [
      ActivityModel(
        title: 'Invoice #INV-0042 sent',
        subtitle: 'Acme Corp · ₹12,500',
        time: '2 hours ago',
        icon: Icons.send_rounded,
        color: AppColors.primary,
      ),
      ActivityModel(
        title: 'Payment received',
        subtitle: 'TechSolutions Ltd · ₹45,000',
        time: '5 hours ago',
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
      ),
      ActivityModel(
        title: 'Invoice overdue',
        subtitle: 'StartupXYZ · ₹8,200',
        time: '1 day ago',
        icon: Icons.warning_rounded,
        color: AppColors.error,
      ),
      ActivityModel(
        title: 'New quotation created',
        subtitle: 'GlobalRetail Inc · ₹32,000',
        time: '2 days ago',
        icon: Icons.description_rounded,
        color: Color(0xFF06B6D4),
      ),
    ];
  }

  void addActivity(ActivityModel activity) {
    state = [activity, ...state];
  }
}
