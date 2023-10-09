import 'package:flutter/material.dart';
import 'package:flutter_hive_asif_taj_tutorials/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '1_home_screen.dart';
import '2_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // var directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path);

  await Hive.initFlutter();

  Hive.registerAdapter(NotesModelAdapter());

  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Database',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const HomeScreenTwo(title: 'Hive Database'),
    );
  }
}
