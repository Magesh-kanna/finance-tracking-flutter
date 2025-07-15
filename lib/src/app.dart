import 'package:flutter/material.dart';
import 'package:paywize/src/features/homepage/presentation/homepage.dart';

class PaywizeApp extends StatelessWidget {
  const PaywizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paywize Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
