import 'package:flutter/material.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';

class StatusChip extends StatelessWidget {
  final ApplicationStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusLabel(status),
        style: TextStyle(
          color: config.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusLabel(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return 'Saved';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  _StatusConfig _getStatusConfig(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return _StatusConfig(
          backgroundColor: const Color(0xFFE0E0E0),
          textColor: const Color(0xFF616161),
        );
      case ApplicationStatus.applied:
        return _StatusConfig(
          backgroundColor: const Color(0xFFE3F2FD),
          textColor: const Color(0xFF1565C0),
        );
      case ApplicationStatus.interview:
        return _StatusConfig(
          backgroundColor: const Color(0xFFFFF3E0),
          textColor: const Color(0xFFE65100),
        );
      case ApplicationStatus.offer:
        return _StatusConfig(
          backgroundColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF2E7D32),
        );
      case ApplicationStatus.rejected:
        return _StatusConfig(
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: const Color(0xFFC62828),
        );
      case ApplicationStatus.withdrawn:
        return _StatusConfig(
          backgroundColor: const Color(0xFFF3E5F5),
          textColor: const Color(0xFF7B1FA2),
        );
    }
  }
}

class _StatusConfig {
  final Color backgroundColor;
  final Color textColor;

  const _StatusConfig({
    required this.backgroundColor,
    required this.textColor,
  });
}
