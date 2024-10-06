import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final File file;
  final String tag;

  const FullScreenImage({super.key, required this.file, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: InteractiveViewer(
          // Setting boundary to allow image to be zoomed and panned
          boundaryMargin: const EdgeInsets.all(20.0),
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: tag,
            child: Image.file(file),
          ),
        ),
      ),
      backgroundColor: Colors.black, // To make it full-screen dark background
    );
  }
}
