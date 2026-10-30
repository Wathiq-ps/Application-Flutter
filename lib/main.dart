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
        final currentLocale = state.locale.locale;
        AppStrings.update(lookupAppLocalizations(currentLocale));

        return MaterialApp.router(
          locale: currentLocale,
          builder: (context, child) {
            return KeyedSubtree(
              key: ValueKey(state.locale.code),
              child: child ?? const SizedBox.shrink(),
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Wathiq',
          theme: AppTheme.light,
          routerConfig: AppRoutes.router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
