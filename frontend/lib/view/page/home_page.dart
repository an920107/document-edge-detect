import 'package:document_edge_detect/view/widget/camera_button.dart';
import 'package:document_edge_detect/view/widget/camera_screen.dart';
import 'package:document_edge_detect/view_model/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Consumer<CameraViewModel>(builder: (context, value, child) {
            if (value.controller != null) {
              return Stack(
                children: [
                  Positioned(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          CameraScreen(controller: value.controller!),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CameraButton(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }
}
