import 'package:flutter/material.dart';
import 'package:geny_test_app/core/config/constants.dart';
import 'package:geny_test_app/core/injector/di.dart';
import 'package:geny_test_app/core/widgets/retry_widget.dart';
import 'package:geny_test_app/features/home/notifiers/business_notifier.dart';
import 'package:geny_test_app/features/home/widgets/business_list_widget.dart';
import 'package:geny_test_app/l10n/l10n.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ChangeNotifierProvider<BusinessNotifier>(
      create: (context) =>
          BusinessNotifier(businessRepository: getIt())..fetchBusinesses(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appName),
        ),
        body: Consumer<BusinessNotifier>(
          builder: (context, businessNotifier, _) {
            return businessNotifier.state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (data) => data.isEmpty
                  ? Center(
                      child: RetryWidget(
                        onRetry: businessNotifier.fetchBusinesses,
                        errorMessage: l10n.emptyBusinessList,
                      ),
                    )
                  : BusinessListWidget(businesses: data),
              failed: (error, st) => Center(
                child: RetryWidget(
                  onRetry: businessNotifier.fetchBusinesses,
                  errorMessage: l10n.somethingWentWrong,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
