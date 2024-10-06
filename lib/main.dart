import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_fit/core/hive/initilize_adapters.dart';
import 'package:track_fit/core/theme/theme.dart';
import 'package:track_fit/features/home_screen/bloc/photos_bloc.dart';
import 'package:track_fit/features/home_screen/repos/photo_repo.dart';
import 'package:track_fit/features/home_screen/ui/home_screen.dart';

void main() async {
  await initilizeHiveAdapters();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => PhotosRepo(),
      )
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhotosBloc(
            photosRepo: context.read<PhotosRepo>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Finder',
      theme: AppTheme.darkThemeMode,
      home: const HomeScreen(),
    );
  }
}
