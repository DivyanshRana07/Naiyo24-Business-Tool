import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep; // 1 or 2

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(
          context,
          stepNumber: 1,
          label: 'Basic Details',
          isActive: currentStep == 1,
          isCompleted: currentStep > 1,
        ),
        const SizedBox(width: AppSpacing.md),
        const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
        const SizedBox(width: AppSpacing.md),
        _buildStep(
          context,
          stepNumber: 2,
          label: 'Additional Details',
          isActive: currentStep == 2,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int stepNumber,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    final color = isActive || isCompleted ? AppColors.primary : AppColors.textHint;
    
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  '$stepNumber',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
