import 'package:decisions/pages/decisions.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Decisions());
}

class Decisions extends StatelessWidget {
  Decisions({super.key});

  final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
  );
  final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.indigo,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MakingDecisions(),
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
