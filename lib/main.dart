import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_todo_app/pages/home_page.dart';
import 'package:new_todo_app/pages/settings_page.dart';
import 'package:new_todo_app/themes/ThemeProvider.dart';
import 'package:new_todo_app/themes/theme.dart';
import 'package:provider/provider.dart';
import 'data/models/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todoBox');
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
      routes: {
        '/settingspage': (context) => SettingsPage()
      },
    );
  }
}


