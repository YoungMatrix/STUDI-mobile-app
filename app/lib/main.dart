import 'package:flutter/material.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/config/config.dart';
import 'package:soigne_pro/function/function.dart';
import 'package:soigne_pro/view/index.dart';
import 'package:soigne_pro/view/maintenance/maintenance_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from config file
  await Config.load();

  // Initialize the database
  Database? db = await initialiseDatabase(
    Config.dbHost,
    Config.dbPort,
    Config.dbUser,
    Config.dbPassword,
    Config.dbName,
  );

  // Run the application
  runApp(MyApp(database: db, title: 'SoignePro'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database, required this.title});

  final Database? database;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (database == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaintenanceView(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.white,
          ),
          fontFamily: 'Arial',
        ),
        home: MyIndexPage(
          database: database,
          title: title,
          token: false,
          selectedTab: 0,
          doctor: null,
          patientList: const [],
          selectedPatient: null,
        ),
      );
    }
  }
}
