// This StatefulWidget represents the login page of the application.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/config/config.dart';
import 'package:soigne_pro/function/function.dart';
import 'package:soigne_pro/view/index.dart';

// File verified

/// This StatefulWidget represents the login page of the application.
class MyHomeLogInPage extends StatefulWidget {
  const MyHomeLogInPage(
      {super.key,
      required this.database,
      required this.doctor,
      required this.patientList});

  final Database? database;
  final Doctor? doctor;
  final List<Patient> patientList;

  @override
  State<MyHomeLogInPage> createState() => _MyHomeLogInPageState();
}

/// State class for the home login page.
class _MyHomeLogInPageState extends State<MyHomeLogInPage> {
  late List<String> _doctorInformationList;
  late Database? _db;
  late Doctor? _doctor;
  late List<Patient> _patientList;
  late Patient? _selectedPatient;
  late SharedPreferences _prefs;

  final DateTime _tomorrow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 10, 0);
  late int _hours;
  late int _minutes;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _hours = _tomorrow.difference(DateTime.now()).inHours;
    _minutes = _tomorrow.difference(DateTime.now()).inMinutes;
    _db = widget.database;
    setState(() {
      _initDatabase();
    });
    _doctor = widget.doctor;
    _patientList = widget.patientList;
    _selectedPatient = null;
    _doctorInformationList = fetchDoctorInformation(_doctor);

    // Update the timer every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      List<Patient> patientList = await fetchPatientList(_db, _doctor);
      setState(() {
        _hours = _tomorrow.difference(DateTime.now()).inHours;
        _minutes = _tomorrow.difference(DateTime.now()).inMinutes;
        _patientList = patientList;
        if (_db == null) {
          _initDatabase();
        }
      });
    });
  }

  /// Initializes the database connection if connexion lost.
  Future<void> _initDatabase() async {
    _db = await initialiseDatabase(
      Config.dbHost,
      Config.dbPort,
      Config.dbUser,
      Config.dbPassword,
      Config.dbName,
    );
  }

  /// Disposes of resources when the widget is disposed.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Builds the UI for the login page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1, // Border width
                ),
                borderRadius: BorderRadius.circular(10), // Border radius
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPresentation(_patientList),
                    const SizedBox(height: 5),
                    if (_db != null)
                      for (int i = 0; i < _patientList.length; i++)
                        _buildCard(_patientList[i])
                    else
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Le serveur est indisponible pour le moment.\n'
                              'Veuillez réessayer ultérieurement.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the presentation section of the UI.
  Widget _buildPresentation(List<Patient>? patient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 17.0, color: Colors.black),
            children: <TextSpan>[
              const TextSpan(
                text: 'Bienvenue ',
              ),
              TextSpan(
                text: _doctorInformationList[0] != 'N/A'
                    ? 'Dr. ${_doctorInformationList[2]}'
                    : 'Chargement...',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: ',',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: <TextSpan>[
              _patientList.length <= 1
                  ? const TextSpan(
                      text: 'Prochaine prescription dans: ',
                      style: TextStyle(fontSize: 15.0),
                    )
                  : const TextSpan(
                      text: 'Prochaines prescriptions dans: ',
                      style: TextStyle(fontSize: 15.0),
                    ),
              TextSpan(
                text: '${(_hours % 24).toString().padLeft(2, '0')}h'
                    '${(_minutes % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _patientList.length <= 1
                ? Text(
                    'Prochain patient à visiter: (${_patientList.length})',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  )
                : Text(
                    'Prochains patients à visiter: (${_patientList.length})',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
            Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.only(left: 5),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  List<Patient> patientList =
                      await fetchPatientList(_db, _doctor);
                  _initDatabase();
                  setState(
                    () {
                      _patientList = patientList;
                    },
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a card widget for displaying patient information.
  Widget _buildCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.black, // Color of the border
          width: 1.0, // Width of the border
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, top: 0, right: 10, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Nom: ${patient.lastName}\nPrénom: ${patient.firstName}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              width: 25,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_right),
                onPressed: () async {
                  setState(() {
                    _selectedPatient = patient;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyIndexPage(
                        database: _db,
                        title: 'SoignePro',
                        token: true,
                        selectedTab: 3,
                        doctor: _doctor,
                        patientList: _patientList,
                        selectedPatient: _selectedPatient,
                      ),
                    ),
                  );
                  _prefs = await SharedPreferences.getInstance();
                  _prefs.setInt('selectedTab', 3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
