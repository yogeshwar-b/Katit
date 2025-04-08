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
      title: 'Katit',
      theme: lightTheme, // Light theme applied by default
      darkTheme: darkTheme, // Dark theme configuration
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Column(
              children: [
                Expanded(flex: 1, child: TopBar()),
                Expanded(flex: 7, child: PlayerArea()),
                Expanded(flex: 2, child: BottomBar()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'Katit',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('Select Source'),
            ),
          ),
          Container(color: Colors.deepPurple, child: Text('Clear')),
        ],
      ),
    );
  }
}

class PlayerArea extends StatefulWidget {
  const PlayerArea({super.key});

  @override
  State<PlayerArea> createState() => _PlayerAreaState();
}

class _PlayerAreaState extends State<PlayerArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: Text('Player Area'),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text('Bottom Bar', style: TextStyle(color: Colors.white)),
    );
  }
}
