import 'package:flutter/material.dart';
import 'package:test_widgets/see_more/see_more.dart';
import 'package:test_widgets/share_screen_shot/share_screen_shot.dart';

import 'download_image/image_download.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShareScreenShotScreen(),
    );
  }
}

