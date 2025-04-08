import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey[800]!,
    secondary: Colors.grey[600]!,
    surface: Colors.grey[300]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 60, color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[900]!,
    secondary: Colors.grey[700]!,
    surface: Colors.grey[800]!,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 60, color: Colors.white),
  ),
);
final appTitle = "Katit";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle(appTitle);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katit Title bar',
      theme: lightTheme, // Light theme applied by default
      darkTheme: darkTheme, // Dark theme configuration
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor:
                Theme.of(context).colorScheme.surface, // Should be grey[800]
            body: Center(
              child: Text(
                'Katit',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
