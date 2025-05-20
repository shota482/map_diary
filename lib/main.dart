import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: '三つのボタン',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            ElevatedButton(
              child: Text('MapPage'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> SvgMapPage())
                );
              },
             ),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text('to PageTwo'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> PageTwo())
                );
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text('to PageThree'),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> PageThree())
                );
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: null,
              child: Text('準備中')
            ),
          ],
        ),
      ),
    );
  }
}




//widget
class SvgMapPage extends StatefulWidget {
  @override
  _SvgMapPageState createState() => _SvgMapPageState();
}

//state
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
      backgroundColor: Colors.orange[100],
      appBar: AppBar(title: Text('SVG 都道府県選択')),
      body: InteractiveViewer(
        maxScale: 10.0, // 最大拡大率
        minScale: 1.0,  // 最小縮小率
        boundaryMargin: EdgeInsets.all(0),
        child: Stack(
          children: [
            GestureDetector(
              onTapUp: (details) {
                // ↓本格運用ではタップ位置に基づきIDを判定する必要あり
                setState(() {
                  selectedPref = 'aichi'; // ←例：熊本を選択
                });
              },
              child: SvgPicture.string(
                updatedSvg,
                width:  1300,
                height: 1300,
                fit: BoxFit.contain,
                allowDrawingOutsideViewBox: true,
              ),
            ),

            //button
            positionedButton(context: context, top: 500, left: 10, label: '九州'),
            positionedButton(context: context, top: 530, left: 100, label: '四国'),
            positionedButton(context: context, top: 400, left: 60, label: '中国'),
            positionedButton(context: context, top: 350, left: 140, label: '中部・北陸'),
            positionedButton(context: context, top: 350, left: 140, label: '関東'),
            positionedButton(context: context, top: 500, left: 180, label: '近畿'),
            positionedButton(context: context, top: 320, left: 230, label: '東北'),


            positionedButton(
              context: context,
              top: 225, left: 250,
              label: '北海道',
              onPressed:  () => navigateToPage(
                  context,
                  DetailPage(
                      assetPath: 'assets/images/Japan_hokkaido.svg')
              )
            )
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const DetailPage({
    super.key,
    required this.assetPath,
    this.width = 400,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(title: Text("北海道の思い出")),
      body: Center(
        child: SvgPicture.asset(
          assetPath,
          width: width,
          height: height,
          placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
      ),
    );
  }
}


// 画面２
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('画面２')),
      body: Center(child: Text('これは画面２です')),
    );
  }
}

// 画面３
class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('画面３')),
      body: Center(child: Text('これは画面３です')),
    );
  }
}

Widget positionedButton({
  required BuildContext context,
  required double top,
  required double left,
  required String label,
  VoidCallback? onPressed,
  Color backgroundColor = Colors.white,
  Color borderColor = Colors.green,
}) {
  return Positioned(
    top: top,
    left: left,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const StadiumBorder(),
        side: BorderSide(color: borderColor),
      ),
      child: Text(label),
    ),
  );
}

void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}