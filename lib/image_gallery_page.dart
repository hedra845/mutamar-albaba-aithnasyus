import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGalleryPage extends StatelessWidget {
  final List<String> imagePaths = const [
    'assets/images/IMG-20250711-WA0039.jpg',
    // Add 3 more image asset paths here
    'assets/images/IMG-20250711-WA0040.jpg',
    'assets/images/IMG-20250711-WA0042.jpg',
    'assets/images/IMG-20250711-WA0041.jpg',
  ];

  const ImageGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Image Gallery'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imagePaths.length,
        scrollDirection: Axis.vertical,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(imagePaths[index]),
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.covered * 3.0,
            heroAttributes: PhotoViewHeroAttributes(tag: imagePaths[index]),
          );
        },
        loadingBuilder:
            (context, event) =>
                const Center(child: CircularProgressIndicator()),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
