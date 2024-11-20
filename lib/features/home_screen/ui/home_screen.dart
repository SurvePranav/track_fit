import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_fit/core/common/common_methods.dart';
import 'package:track_fit/core/common/file_operation_methods.dart';
import 'package:track_fit/core/domain/status.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/core/theme/app_palette.dart';
import 'package:track_fit/features/home_screen/bloc/photos_bloc.dart';
import 'package:track_fit/features/home_screen/ui/widgets/image_widget.dart';
import 'package:track_fit/features/home_screen/ui/widgets/my_bottom_sheet.dart';

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
                (MediaQuery.of(context).size.width - 26) * 0.5;

            return SingleChildScrollView(
              child: Column(
                  children: List.generate(
                state.photos.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageWidget(
                    photo: state.photos[index],
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
          CommonMethods.showBottomSheet(
            context,
            const MyBottomSheet(
              selectedSide: 'front',
            ),
            ''''Today's Image''',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
