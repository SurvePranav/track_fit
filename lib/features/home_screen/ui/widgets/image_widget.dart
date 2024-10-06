import 'dart:io';

import 'package:flutter/material.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/features/home_screen/ui/image_full_screen.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.photo,
    required this.width,
    required this.height,
  });

  final PhotosModel photo;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          photo.date,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: width,
              height: height,
              child: photo.frontPic != ''
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            file: File(photo.frontPic),
                            tag: 'front_${photo.id}',
                          ),
                        ));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                              tag: 'front_${photo.id}',
                              child: Image.file(File(photo.frontPic)))),
                    )
                  : const Center(child: Text('Front Facing Image')),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: width,
              height: height,
              child: photo.sidePic != ''
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            file: File(photo.sidePic),
                            tag: 'side_${photo.id}',
                          ),
                        ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: 'side_${photo.id}',
                          child: Image.file(
                            File(photo.sidePic),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('Side Facing Image'),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
