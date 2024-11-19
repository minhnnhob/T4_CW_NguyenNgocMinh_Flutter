import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yoga_center_app/providers/course_provider.dart';
import 'package:yoga_center_app/screens/course_list_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: MaterialApp(
        title: 'Yoga Center',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CourseListScreen(),
      ),
    );
  }
}