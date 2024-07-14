// This file contains the main index page of the application, managing navigation and state.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/config/config.dart';
import 'package:soigne_pro/function/function.dart';
import 'package:soigne_pro/view/doctor/doctor_home_view.dart';
import 'package:soigne_pro/view/doctor/doctor_profile_view.dart';
import 'package:soigne_pro/view/patient/patient_feedback_view.dart';
import 'package:soigne_pro/view/public/public_view.dart';

// File verified

/// This StatefulWidget represents the main index page of the application.
class MyIndexPage extends StatefulWidget {
  const MyIndexPage({
    super.key,
    required this.database,
    required this.title,
    required this.token,
    required this.selectedTab,
    required this.doctor,
    required this.patientList,
    required this.selectedPatient,
  });

  final Database? database;
  final String title;
  final bool token;
  final int selectedTab;
  final Doctor? doctor;
  final List<Patient> patientList;
  final Patient? selectedPatient;

  @override
  State<MyIndexPage> createState() => _MyIndexPageState();
}

/// State class for MyIndexPage widget.
class _MyIndexPageState extends State<MyIndexPage> with WidgetsBindingObserver {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  late Database? _db;
  late String _title;
  late bool _token;
  late int _selectedTab;
  late Doctor? _doctor;
  late List<Patient> _patientList;
  late Patient? _selectedPatient;
  late String _email;
  late String _password;
  late String? _errorText;
  late bool _passwordHidden;
  late List<Widget> _pages;
  late SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _controllerEmail.addListener(() {
      setState(() {
        _email = _controllerEmail.text;
      });
    });
    _controllerPassword.addListener(() {
      setState(() {
        _password = _controllerPassword.text;
      });
    });

    _prefs = null;
    _db = widget.database;
    _title = widget.title;
    _token = widget.token;
    _selectedTab = widget.selectedTab;
    _doctor = widget.doctor;
    _patientList = widget.patientList;
    _selectedPatient = widget.selectedPatient;
    _errorText = null;
    _email = '';
    _password = '';
    _passwordHidden = true;
    _pages = [
      const MyHomeLogOutPage(),
      DoctorPersonalPage(doctor: _doctor),
      MyHomeLogInPage(
          database: _db, doctor: _doctor, patientList: _patientList),
      MyFeedbackPage(database: _db, selectedPatient: _selectedPatient),
    ];
    _initStateData();
  }

  // This method initializes the state data asynchronously.
  Future<void> _initStateData() async {
    await _initDatabase();
    _prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> result = await loadSavedData(_prefs, _db!);
    _token = result['token'];
    _selectedTab = result['selectedTab'];
    _doctor = result['doctor'];
    _patientList = result['patientList'];
    setState(() {
      _pages = [
        const MyHomeLogOutPage(),
        DoctorPersonalPage(doctor: _doctor),
        MyHomeLogInPage(
          database: _db,
          doctor: _doctor,
          patientList: _patientList,
        ),
        MyFeedbackPage(
          database: _db,
          selectedPatient: _selectedPatient,
        ),
      ];
    });
  }

  // Function to initialize database connection if connexion lost.
  Future<void> _initDatabase() async {
    _db = await initialiseDatabase(
      Config.dbHost,
      Config.dbPort,
      Config.dbUser,
      Config.dbPassword,
      Config.dbName,
    );
  }

  // This method is called when the app's lifecycle state changes.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_db == null || !_db!.isConnected) {
        await _initDatabase();
        if (kDebugMode) {
          print('Connected to the database.');
        }
      }
    } else {
      if (_db != null && _db!.isConnected) {
        await _db!.closeConnection();
        if (kDebugMode) {
          print('Database closed with success.');
        }
      }
    }
  }

  // This method is called when the State object is removed, typically because the widget is removed from the tree.
  @override
  void dispose() {
    if (_token) {
      _selectedTab = 2;
      saveData(_token, _selectedTab, _doctor);
    }
    super.dispose();
  }

  /// Build method for constructing the UI of the page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: _pages[_selectedTab],
      extendBody: false,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: _buildFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Widget for building the Drawer.
  Widget _buildDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      width: MediaQuery.of(context).size.width / 2,
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: const DrawerHeader(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Informations',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
              child: const Text(
                'Application développée par l\'hôpital SoigneMoi - 2024 ©',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget for building the AppBar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.info_outline));
        },
      ),
      centerTitle: true,
      title: Text(_title,
          style: const TextStyle(
              color: Colors.red, fontSize: 20, fontStyle: FontStyle.italic)),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              _token ? _buildShowDialogLogOut() : _buildShowDialogLogIn();
            },
            icon: _token
                ? const Icon(Icons.toggle_on, color: Colors.green, size: 35.0)
                : const Icon(Icons.toggle_off, color: Colors.red, size: 35.0),
          ),
        )
      ],
    );
  }

  /// Widget for building the FloatingActionButton.
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 10,
      onPressed: () {
        _token ? _onItemTapped(2) : _onItemTapped(0);
      },
      child: Icon(Icons.home,
          size: 30,
          color: (_selectedTab == 0 || _selectedTab == 2)
              ? Colors.red
              : Colors.black),
    );
  }

  /// Widget for building the Bottom Navigation Bar.
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomNavItem(
            icon: Icons.person,
            iconSize: 30,
            color: _selectedTab == 1 ? Colors.red : Colors.black,
            onPressed: () {
              _token ? _onItemTapped(1) : _buildShowDialogLogIn();
            },
          ),
          _buildBottomNavItem(
            icon: Icons.list,
            iconSize: 30,
            color: _selectedTab == 3 ? Colors.red : Colors.black,
            onPressed: () {
              _token ? _onItemTapped(3) : _buildShowDialogLogIn();
            },
          ),
        ],
      ),
    );
  }

  /// Widget for building each item in the Bottom Navigation Bar.
  Widget _buildBottomNavItem({
    required IconData icon,
    required double iconSize,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 40,
      child: IconButton(
        icon: Icon(icon, size: iconSize, color: color),
        onPressed: onPressed,
      ),
    );
  }

  /// Asynchronously shows a login dialog.
  Future _buildShowDialogLogIn() {
    _controllerEmail.clear();
    _controllerPassword.clear();
    return showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 10, right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: "E-mail",
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        cursorColor: Colors.black,
                        controller: _controllerEmail,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _passwordHidden,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: "Mot de passe",
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordHidden
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _passwordHidden = !_passwordHidden;
                              });
                            },
                          ),
                          errorText: _errorText,
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        cursorColor: Colors.black,
                        controller: _controllerPassword,
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.only(
                    left: 0, top: 10, right: 0, bottom: 10),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _initDatabase();
                          });
                          Map<String, dynamic> result = await submitLoginButton(
                              context, _db, _prefs!, _email, _password);
                          setState(() {
                            _prefs = result['prefs'];
                            _doctor = result['doctor'];
                            _patientList = result['patientList'];
                            _token = result['token'];
                            _errorText = result['errorText'];
                            _selectedTab = result['selectedTab'];
                            _pages = [
                              const MyHomeLogOutPage(),
                              DoctorPersonalPage(doctor: _doctor),
                              MyHomeLogInPage(
                                  database: _db,
                                  doctor: _doctor,
                                  patientList: _patientList),
                              MyFeedbackPage(
                                  database: _db,
                                  selectedPatient: _selectedPatient),
                            ];
                            if (_token) {
                              Navigator.of(context).pop();
                            }
                          });
                          _onItemTapped(_selectedTab);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Se connecter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Retour'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Asynchronously shows a logout confirmation dialog.
  Future _buildShowDialogLogOut() {
    return showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 10, right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: const Text(
                  'Souhaitez-vous vous déconnecter?',
                  textAlign: TextAlign.center,
                ),
                actionsPadding: const EdgeInsets.only(
                    left: 0, top: 10, right: 0, bottom: 10),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> result =
                              submitLogoutButton(context, _patientList);
                          _prefs?.clear();
                          _token = result['token'];
                          _errorText = result['errorText'];
                          _selectedTab = result['selectedTab'];
                          _doctor = result['doctor'];
                          _patientList = result['patientList'];
                          _onItemTapped(_selectedTab);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Oui'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Non'),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Handles the tap event on the bottom navigation bar.
  Future<void> _onItemTapped(int index) async {
    if (index == 2 || index == 3) {
      List<Patient> patientList = await fetchPatientList(_db, _doctor);
      _patientList = patientList;
      for (int i = 0; i < patientList.length; i++) {
        if (patientList[i].id == _selectedPatient?.id) {
          _selectedPatient = patientList[i];
        }
      }
    }
    setState(() {
      _pages = [
        const MyHomeLogOutPage(),
        DoctorPersonalPage(doctor: _doctor),
        MyHomeLogInPage(
            database: _db, doctor: _doctor, patientList: _patientList),
        MyFeedbackPage(database: _db, selectedPatient: _selectedPatient),
      ];
      _selectedTab = index;
    });
  }
}
