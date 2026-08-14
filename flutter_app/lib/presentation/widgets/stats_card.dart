import 'package:flutter/material.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String number;
  final String label;
  final String? tooltipMessage;
  final Widget? trailingIcon;

  const StatsCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.number,
    required this.label,
    this.tooltipMessage,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage ?? label,
      waitDuration: const Duration(milliseconds: 500),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 156,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: iconBackgroundColor,
                      size: 24,
                    ),
                  ),
                  if (trailingIcon != null) trailingIcon!,
                ],
              ),
              const SizedBox(height: 12),
              Text(
                number,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
