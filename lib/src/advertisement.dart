import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


// ignore: constant_identifier_names
const double type_vertical = 7.0;
// ignore: constant_identifier_names
const double type_horizontal = 8.0;

class CustomImageCard extends StatelessWidget {
  final String imagePath; // Đường dẫn ảnh
  final String title; // Văn bản hiển thị
  final String link;
  final double height; // Chiều cao card

  const CustomImageCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.link,
    this.height = 200, // Chiều cao mặc định
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final cardWidth = screenWidth * 0.9; // Card chiếm 90% chiều rộng màn hình
    final cardHeight = height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
      child: Material(
        borderRadius: BorderRadius.circular(11),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.black26,
          onTap: () {
            launchURL(link);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink.image(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                // width: cardWidth,
                height: cardHeight * 0.75, // 75% chiều cao dành cho ảnh
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 2, 2, 2),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchURL(String url) async {
    // final Uri _url = Uri.parse(url);
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $url');
    // }
    // HelpScreen(),
  }
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.loadFlutterAsset('assets/help.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}