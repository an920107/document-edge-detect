import 'dart:math';

import 'package:document_edge_detect/view/page/picture_preview_page.dart';
import 'package:document_edge_detect/view_model/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final image =
            await context.read<CameraViewModel>().controller?.takePicture();
        if (image == null) return;

        final url = Uri.https("api.squidspirit.com", "/image/crop");
        final request = http.MultipartRequest("POST", url);
        final multipartFile = await http.MultipartFile.fromPath(
          "file",
          image.path,
          contentType: MediaType("image", "jpeg"),
        );
        request.files.add(multipartFile);
        final response = await request.send();
        if (response.statusCode == 200) {
          final imageBytes = await response.stream.toBytes();
          if (context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PicturePreviewPage(imageBytes: imageBytes),
            ));
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(painter: _ButtonPaiter()),
      ),
    );
  }
}

class _ButtonPaiter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()..color = Colors.white;
    final blackPaint = Paint()..color = Colors.white24;

    final radius = min(size.width, size.height) / 2;
    final centerOffset = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(centerOffset, radius, blackPaint);
    canvas.drawCircle(centerOffset, radius * 0.75, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
