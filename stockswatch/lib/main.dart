import 'package:flutter/material.dart';
import 'pages/market_watch_page.dart';

void main() => runApp(StockWatchApp());

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class StockWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Stock Watch',
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade300,
            ),
          ),

          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.grey[900],
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade800,
            ),
          ),


          themeMode: currentTheme,
          home: MarketWatchPage(),
        );
      },
    );
  }
}
