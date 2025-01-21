import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:test_widgets/app_utils/app_network_image.dart';
import 'package:test_widgets/app_utils/app_string.dart';

class ShareScreenShotScreen extends StatefulWidget {
  const ShareScreenShotScreen({super.key});

  @override
  State<ShareScreenShotScreen> createState() => _ShareScreenShotScreenState();
}

class _ShareScreenShotScreenState extends State<ShareScreenShotScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool isLoading = false;

  _takeScreenShotAndShare() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// 1. Capture the widget as an image
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List(); // that is share able and save able image

      /// 2. Save the image to a temporary directory
      Directory directory = await getTemporaryDirectory();
      String filePath = "${directory.path}/screenshot.png";
      File imagePath = File(filePath);
      await imagePath.writeAsBytes(pngBytes); // now pngBytes is ready for save here temporarily

      /// Share file
      await Share.shareXFiles([XFile(filePath)], subject: 'Take Tee Sheet screen shot');
    } on Exception catch (e) {
      print("Error taking screenshot: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Share ScreenShot'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: _repaintBoundaryKey,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(AppString.text400),
                    const SizedBox(height: 15),
                    Image.network(AppNetworkImage.image1),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((__) async {
                      await _takeScreenShotAndShare();
                    });
                  },
                  child: const Text('Share'),
                )
        ],
      ),
    );
  }
}
