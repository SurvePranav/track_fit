import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:track_fit/core/common/common_methods.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/features/home_screen/bloc/photos_bloc.dart';
import 'package:track_fit/features/home_screen/ui/image_full_screen.dart';
import 'package:track_fit/features/home_screen/ui/widgets/my_bottom_sheet.dart';

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
          DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(photo.date))
              .toString(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (photo.frontPic != '') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      file: File(photo.frontPic),
                      tag: 'front_${photo.id}',
                    ),
                  ));
                } else {
                  CommonMethods.showBottomSheet(
                    context,
                    const MyBottomSheet(
                      selectedSide: 'front',
                    ),
                    ''''Today's Image''',
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: width,
                height: height,
                child: photo.frontPic != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                            tag: 'front_${photo.id}',
                            child: Image.file(File(photo.frontPic))))
                    : const Center(child: Text('Front Facing Image')),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                if (photo.sidePic != '') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      file: File(photo.sidePic),
                      tag: 'side_${photo.id}',
                    ),
                  ));
                } else {
                  CommonMethods.showBottomSheet(
                    context,
                    const MyBottomSheet(
                      selectedSide: 'side',
                    ),
                    ''''Today's Image''',
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: width,
                height: height,
                child: photo.sidePic != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: 'side_${photo.id}',
                          child: Image.file(
                            File(photo.sidePic),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text('Side Facing Image'),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
