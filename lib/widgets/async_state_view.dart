import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Wraps a Future-based data fetch with consistent loading, error, and
/// empty-state UI so screens don't each reinvent this. Pass [onRetry] to
/// show a retry button on error (e.g. after a network failure).
class AsyncStateView<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T data)? isEmpty;
  final String emptyMessage;
  final VoidCallback? onRetry;

  const AsyncStateView({
    super.key,
    required this.future,
    required this.builder,
    this.isEmpty,
    this.emptyMessage = 'હજુ કંઈ નથી.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: CircularProgressIndicator(color: AppColors.ink)),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Column(
              children: [
                const Icon(Icons.wifi_off_rounded, color: AppColors.slateLight, size: 36),
                const SizedBox(height: 10),
                const Text(
                  'Connection ma તકલીફ થઈ. ફરી પ્રયત્ન કરો.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.slate, fontSize: 13.5),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 12),
                  TextButton(onPressed: onRetry, child: const Text('ફરી પ્રયત્ન કરો')),
                ],
              ],
            ),
          );
        }
        final data = snapshot.data as T;
        if (isEmpty != null && isEmpty!(data)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Center(
              child: Text(emptyMessage, style: const TextStyle(color: AppColors.slateLight, fontSize: 13.5)),
            ),
          );
        }
        return builder(context, data);
      },
    );
  }
}
