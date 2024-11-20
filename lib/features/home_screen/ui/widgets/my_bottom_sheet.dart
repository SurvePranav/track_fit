import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_fit/features/home_screen/bloc/photos_bloc.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({
    super.key,
    required this.selectedSide,
  });

  final String selectedSide;

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  String? selectedSide;
  @override
  void initState() {
    selectedSide = widget.selectedSide;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 'front',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value;
                });
              },
            ),
            const Text('Front Face'),
            const SizedBox(
              width: 20,
            ),
            Radio(
              value: 'side',
              groupValue: selectedSide,
              onChanged: (value) {
                setState(() {
                  selectedSide = value;
                });
              },
            ),
            const Text('Side Face'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<PhotosBloc>().add(
                          PhotoAddedEvent(
                            source: 'camera',
                            photoType: selectedSide ?? 'front',
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 40,
                  ),
                ),
                const Text(
                  'Capture',
                  // style: TextStyle(
                  //     color: AppColors.secondary),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<PhotosBloc>().add(
                          PhotoAddedEvent(
                            source: 'gallery',
                            photoType: selectedSide ?? 'front',
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.upload,
                    size: 40,
                  ),
                ),
                const Text(
                  'Upload',
                  // style: TextStyle(
                  //     color: AppColors.secondary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
