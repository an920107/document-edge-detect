import 'package:document_edge_detect/view/page/home_page.dart';
import 'package:document_edge_detect/view_model/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CameraViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Document Edge Detector",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
