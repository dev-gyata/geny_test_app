import 'package:flutter/material.dart';
import 'package:geny_test_app/l10n/l10n.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    required this.onRetry,
    required this.errorMessage,
    super.key,
  });
  final VoidCallback onRetry;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        const CircleAvatar(
          radius: 40,
          child: Icon(
            Icons.error_outline,
            size: 30,
          ),
        ),
        Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(
            l10n.clickHereToRetry,
          ),
        ),
      ],
    );
  }
}
