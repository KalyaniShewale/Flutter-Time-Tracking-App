import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/screens/home_screen.dart';
import 'package:timetrackingapp/utils/strings.dart';
import 'providers/time_entry_provider.dart';

void main() {
  runApp(const TimeTrackerApp());
}

class TimeTrackerApp extends StatelessWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}