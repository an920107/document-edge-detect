import 'dart:typed_data';

import 'package:flutter/material.dart';

class PicturePreviewPage extends StatelessWidget {
  const PicturePreviewPage({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.memory(
            imageBytes,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
