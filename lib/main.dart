import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JapanMapScreen(), // ← ここがエラーになっていないか？
    );
  }
}

class JapanMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("日本地図 (SVG)")),
      body: Center(
        child: SvgPicture.asset(
          'assets/images/Japan.svg',
          width: 300,
          height: 400,
        ),
      ),
    );
  }
}