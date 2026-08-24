import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 86,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 20),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension EmptyStatePresets on EmptyState {
  static EmptyState noConnection({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      message: 'No internet connection',
      subtitle: 'Please check your connection and try again',
      actionLabel: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }

  static EmptyState searchNoResults({String? query}) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      message: 'No results found',
      subtitle: query != null ? 'We could not find anything matching "$query"' : 'Try refining your search keywords',
    );
  }

  static EmptyState generic({String? message}) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      message: message ?? 'Nothing to see here',
      subtitle: 'Check back later for updates',
    );
  }

  static EmptyState unauthorized({VoidCallback? onLogin}) {
    return EmptyState(
      icon: Icons.lock_outline_rounded,
      message: 'Access Denied',
      subtitle: 'You need to be logged in to view this content',
      actionLabel: onLogin != null ? 'Log In' : null,
      onAction: onLogin,
    );
  }
}
