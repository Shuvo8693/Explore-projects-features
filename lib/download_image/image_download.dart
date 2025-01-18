import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDownload extends StatefulWidget {
  const ImageDownload({super.key, required this.title});

  final String title;

  @override
  State<ImageDownload> createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownload> {
  String imageUrl =
      "https://images.unsplash.com/photo-1574088242473-ff04939a61ec?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGFybXl8ZW58MHx8MHx8fDA%3D";

  bool _isDownloading = false;
  double _progress = 0;

  Future<void> downloadImage(String url, String fileName) async {
    try {
      /// Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar('Denied', 'You denied the storage permission');
        return;
      }

      setState(() {
        _isDownloading = true;
        _progress = 0;
      });

      /// Get storage directory
      String? selectDirectory = await FilePicker.platform.getDirectoryPath();
      if(selectDirectory!.isEmpty){
        print("User canceled directory selection.");
        return ;
      }
      String filePath = "$selectDirectory/$fileName";
      File file = File(filePath);

      /// Make HTTP request
      final request = http.Request('GET', Uri.parse(url));
      var response = await request.send();

      if (response.statusCode == 200) {
        int total = response.contentLength ?? 0;
        int received = 0;

        var sink = file.openWrite();
        response.stream.listen(
              (chunkData) {
            received += chunkData.length;
            sink.add(chunkData);

            setState(() {
              _progress = (received / total);
            });
          },
          onDone: () async {
            await sink.close();
            setState(() {
              _isDownloading = false;
              _progress = 0;
            });
            Get.snackbar('Done', 'Image saved to $filePath');
          },
          onError: (error, stackTrace) async {
            await sink.close();
            setState(() {
              _isDownloading = false;
              _progress = 0;
            });
            Get.snackbar('Failed', 'Failed to save image: $error');
          },
          cancelOnError: true,
        );
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = 0;
      });
      Get.snackbar('Error', '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDownloading)
              Column(
                children: [
                  CircularProgressIndicator(value: _progress),
                  const SizedBox(height: 10),
                  Text('Downloading... ${(_progress * 100).toStringAsFixed(0)}%')
                ],
              ),
            if (!_isDownloading)
              Image.network(
                imageUrl,
                height: 200,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadImage(imageUrl, "downloaded_image2.jpg");
        },
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ),
    );
  }
}

