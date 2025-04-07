import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Katit',
            style: TextStyle(color: Colors.white, fontSize: 60),
          ),
        ),
      ),
    );
  }
}
