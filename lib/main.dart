import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SvgMapPage());
  }
}

class SvgMapPage extends StatefulWidget {
  @override
  _SvgMapPageState createState() => _SvgMapPageState();
}

class _SvgMapPageState extends State<SvgMapPage> {
  String? svgContent;
  String selectedPref = '';

  @override
  void initState() {
    super.initState();
    loadSvg();
  }

  Future<void> loadSvg() async {
    final rawSvg = await rootBundle.loadString('assets/images/Japan.svg');
    setState(() {
      svgContent = rawSvg;
    });
  }

  String highlightPrefecture(String svg, String id) {
    return svg.replaceAllMapped(
      RegExp(r'<path[^>]+id="' + id + r'"[^>]+fill="[^"]+"'),
          (match) {
        final original = match.group(0)!;
        return original.replaceAll(RegExp(r'fill="[^"]+"'), 'fill="#ff0000"');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (svgContent == null) return Center(child: CircularProgressIndicator());

    final updatedSvg = selectedPref.isNotEmpty
        ? highlightPrefecture(svgContent!, selectedPref)
        : svgContent!;

    return Scaffold(
      appBar: AppBar(title: Text('SVG 都道府県選択')),
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: (details) {
              // ↓本格運用ではタップ位置に基づきIDを判定する必要あり
              setState(() {
                selectedPref = 'kumamoto'; // ←例：熊本を選択
              });
            },
            child: SvgPicture.string(
              updatedSvg,
              fit: BoxFit.contain,
              allowDrawingOutsideViewBox: true,
            ),
          ),
        ],
      ),
    );
  }
}

/*
class SvgZoomExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SVG Zoom Example')),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 10,
          child: SvgPicture.asset(
            'assets/images/Japan.svg',
            width: 300, // 実際のSVGの大きさに合わせて
            height: 400,
          ),
        ),
      ),
    );
  }
}
*/