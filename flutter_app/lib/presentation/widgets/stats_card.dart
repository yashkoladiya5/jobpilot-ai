import 'package:flutter/material.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String number;
  final String label;

  const StatsCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
