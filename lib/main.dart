// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoflutter/Themes/theme_model.dart';

import 'pages/home_page.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModal(),
      child: Consumer(builder: (context, ThemeModal themeNotifier, child) {
        return MaterialApp(
          title: "ToDo App",
          themeMode: ThemeMode.light,
          theme: themeNotifier.isDark
              ? ThemeData.dark(
                  useMaterial3: true,
                )
              : ThemeData.light(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      }),
    );
  }
}
