import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_fit/core/common/common_methods.dart';
import 'package:track_fit/core/common/file_operation_methods.dart';
import 'package:track_fit/core/domain/status.dart';
import 'package:track_fit/core/theme/app_palette.dart';
import 'package:track_fit/features/home_screen/bloc/photos_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    context.read<PhotosBloc>().add(const PhotosRequestedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Fitness'),
      ),
      body: BlocConsumer<PhotosBloc, PhotosState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.photosState is StatusLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppPallete.gradient2,
              ),
            );
          } else if (state.photosState is StatusSuccess) {
            final widthFraction =
                (MediaQuery.of(context).size.width - 20) * 0.5;
            return ListView.separated(
              padding: const EdgeInsets.all(5),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.photos[index].date,
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
                          width: widthFraction,
                          height: widthFraction * 16 / 9,
                          child: state.photos[index].frontPic != ''
                              ? Image.file(
                                  File(state.photos[index].frontPic),
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
                          width: widthFraction,
                          height: widthFraction * 16 / 9,
                          child: state.photos[index].sidePic != ''
                              ? Image.file(
                                  File(state.photos[index].sidePic),
                                )
                              : const Center(
                                  child: Text('Side Facing Image'),
                                ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          } else if (state.photosState is StatusFailure) {
            return const Center(
              child: Text('failed to load'),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String? selectedSide = 'front';
          CommonMethods.showBottomSheet(context, StatefulBuilder(
            builder: (context, setState) {
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
                        value: 'back',
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
            },
          ), 'Today\'s Image');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
