import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicbox/songslist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            title: 'Music Box',
            home: SongsList(),
            theme: ThemeData(primarySwatch: Colors.teal),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
