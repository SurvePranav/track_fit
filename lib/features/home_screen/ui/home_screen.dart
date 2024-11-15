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
import 'package:track_fit/features/home_screen/ui/widgets/image_widget.dart';

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
            final photos = state.photos.reversed.toList();
            final widthFraction =
                (MediaQuery.of(context).size.width - 26) * 0.5;
            // return ListView.separated(
            //   padding: const EdgeInsets.all(5),
            //   separatorBuilder: (context, index) {
            //     return const SizedBox(
            //       height: 10,
            //     );
            //   },
            //   itemCount: photos.length,
            //   itemBuilder: (context, index) {
            //     return ImageWidget(
            //       photo: photos[index],
            //       width: widthFraction,
            //       height: widthFraction * 16 / 9,
            //     );
            //   },
            // );

            return SingleChildScrollView(
              child: Column(
                  children: List.generate(
                photos.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageWidget(
                    photo: photos[index],
                    width: widthFraction,
                    height: widthFraction * 16 / 9,
                  ),
                ),
              )),
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
            },
          ), 'Today\'s Image');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
