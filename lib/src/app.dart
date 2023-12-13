import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'movies_feature/screens/movie_details_view.dart';
import 'movies_feature/screens/movies_list_view.dart';
import 'movies_feature/base_api.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MoviesApp extends StatefulWidget {
  final SettingsController settingsController;
  final BaseAPI baseAPI;

  const MoviesApp({
    super.key,
    required this.settingsController,
    required this.baseAPI,
  });

  @override
  State<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                final args = routeSettings.arguments as Map<String, dynamic>?;
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case MovieDetailsView.routeName:
                    return MovieDetailsView(
                      baseAPI: widget.baseAPI,
                      movie: args?['movie'],
                    );
                  case MoviesListView.routeName:
                  default:
                    return MoviesListView(baseAPI: widget.baseAPI);
                }
              },
            );
          },
        );
      },
    );
  }
}
