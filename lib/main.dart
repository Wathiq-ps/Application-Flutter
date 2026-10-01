import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'core/constant/strings.dart';
import 'core/di/injector.dart';
import 'core/localization/locale_cubit.dart';
import 'core/localization/locale_state.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const WathiqApp(),
  //   ),
  // );
  runApp(
    BlocProvider(
      create: (_) => LocaleCubit(Injector.localeStorageService)..load(),
      child: const WathiqApp(),
    ),
  );
}

class WathiqApp extends StatelessWidget {
  const WathiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Wathiq',
          theme: AppTheme.light,
          routerConfig: AppRoutes.router,
          locale: state.locale.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            // Refreshes the AppStrings facade once per locale change —
            // every existing AppStrings.xxx call site keeps working as-is.
            AppStrings.update(AppLocalizations.of(context));
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}