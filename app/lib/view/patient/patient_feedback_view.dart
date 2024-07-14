// This StatefulWidget manages feedback and prescription data.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/config/config.dart';
import 'package:soigne_pro/controller/patient/patient_controller.dart';
import 'package:soigne_pro/function/function.dart';

// File verified

/// MyFeedbackPage StatefulWidget for managing feedback and prescription data.
class MyFeedbackPage extends StatefulWidget {
  const MyFeedbackPage(
      {super.key, required this.database, required this.selectedPatient});

  final Database? database;
  final Patient? selectedPatient;

  @override
  State<MyFeedbackPage> createState() => _MyFeedbackPageState();
}

/// State class for MyFeedbackPage widget.
class _MyFeedbackPageState extends State<MyFeedbackPage> {
  late Database? _db;
  late Patient? _selectedPatient;
  late List<String> _patientInformation;
  late List<String> _patientInformationDrug;
  late List<String> _informationDrugTitle;
  late List<List<String>> _choiceList;
  late List<List<String>> _choiceListDrug;
  late double _counter;
  late bool _completed;
  late bool _medicationFilled;

  final String _today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final List<String> _informationTitle = [
    'Nom du patient',
    'Prénom du patient',
    'Date de l\'avis',
    'Libellé',
    'Date de début',
    'Date de fin',
    'Description',
  ];

  @override
  void initState() {
    super.initState();
    _db = widget.database;
    setState(() {
      _initDatabase();
    });
    _selectedPatient = widget.selectedPatient;
    _patientInformation = fetchPatientInformation(_selectedPatient);
    _patientInformationDrug = fetchPatientInformationDrug(_selectedPatient);
    _informationDrugTitle = fetchInformationDrugTitle(_patientInformationDrug);
    _counter = _informationDrugTitle.length / 2;
    _completed = isAllCompleted(_patientInformation);
    _medicationFilled = isAllCompleted(_patientInformationDrug);
    _choiceList = [
      [''],
      [''],
      [''],
      [''],
      [''],
      ['']
    ];
    double increment = _patientInformationDrug.length / 2;
    _choiceListDrug = [];
    for (int i = 0; i < increment; i++) {
      _choiceListDrug.addAll([
        [''],
        ['']
      ]);
    }

    // Initialize data if database is connected
    if (_db!.isConnected) {
      _initializeData();
    }
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

  // Function to initialize data from the database
  Future<void> _initializeData() async {
    List<dynamic> result =
        await PatientController.labelAndDrugLists(_db, _patientInformationDrug);
    List<String> labelList = result[0];
    _choiceListDrug = result[1];
    setState(() {
      _choiceList = [
        [''],
        [''],
        _patientInformation[2] == ''
            ? generateDateList(_today, 1)
            : generateDateList(_patientInformation[2], 30),
        labelList,
        _patientInformation[4] == ''
            ? generateDateList(_today, 7)
            : generateDateList(_patientInformation[4], 30),
        _patientInformation[4] == ''
            ? generateDateList(_today, 30)
            : generateDateList(_patientInformation[4], 60),
      ];
    });
  }

  /// This method builds the main scaffold containing the form for medical information input.
  /// It includes various fields such as patient names, dropdowns for medication details, and a description field.
  /// If the database is available (_db != null), it populates the form fields. Otherwise, it displays a server error message.
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget for the presentation section
                  _buildPresentation(),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView(
                      children: [
                        // Check if database is available, if yes, display form fields
                        if (_db != null) ...[
                          // Build last and first names fields
                          for (int i = 0; i < 2; i++)
                            _buildLastAndFirstNames(i),
                          // Build dropdown buttons for medication details
                          for (int i = 2; i < 4; i++) _buildDropdownButton(i),
                          // Build presentation section for medication
                          _buildPresentationDrug(),
                          // Build sections for medication details
                          for (int i = 0;
                              i < _patientInformationDrug.length / 2;
                              i++)
                            _buildSectionDrug(i),
                          // Build more dropdown buttons for additional fields
                          for (int i = 4; i < 6; i++) _buildDropdownButton(i),
                          // Build description field
                          _buildDescription(6),
                        ] else ...[
                          // If database is not available, display error message
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This method builds the presentation section of the medical form.
  /// It includes the title "Avis & Prescription" along with the total count of information fields.
  /// If the database (_db) is available, it displays an icon button for form submission.
  Widget _buildPresentation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title "Avis & Prescription" with dynamic count of information fields
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Avis & Prescription ',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextSpan(
                    text:
                        '(${_informationTitle.length + _informationDrugTitle.length})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Icon button for form submission if database is available (_db != null)
            SizedBox(
              height: 25,
              width: 25,
              child: _db != null
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      color: _completed && _medicationFilled && _db != null
                          ? Colors.green
                          : Colors.black,
                      onPressed: () async {
                        // Form submission logic
                        if (_completed && _medicationFilled) {
                          DateTime formattedToday = DateTime.parse(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()));

                          DateTime prescriptionDate = DateFormat('yyyy-MM-dd')
                              .parse(_patientInformation[2]
                                  .split('/')
                                  .reversed
                                  .join('-'));

                          DateTime startDate = DateFormat('yyyy-MM-dd').parse(
                              _patientInformation[4]
                                  .split('/')
                                  .reversed
                                  .join('-'));

                          DateTime endDate = DateFormat('yyyy-MM-dd').parse(
                              _patientInformation[5]
                                  .split('/')
                                  .reversed
                                  .join('-'));

                          if (prescriptionDate == formattedToday &&
                              ((startDate.isAfter(prescriptionDate) ||
                                      (startDate.isAtSameMomentAs(
                                          prescriptionDate))) &&
                                  endDate.isAfter(startDate))) {
                            String errorMessage =
                                'Échec lors de l\'enregistrement.\n'
                                'Veuillez ré-essayer ultérieurement.';
                            Future<bool> success =
                                PatientController.successSavePatientInformation(
                                    _db,
                                    _selectedPatient,
                                    _patientInformation,
                                    _patientInformationDrug);
                            await success
                                ? _buildSavedMessage()
                                : _buildErrorMessage(errorMessage);
                          } else {
                            String errorMessage =
                                '- La date de prescription doit être égale à la date d\'aujourd\'hui.\n'
                                '- La date de fin de la prescription doit être postérieure à la date de début.';
                            _buildErrorMessage(errorMessage);
                          }
                        } else {
                          String errorMessage =
                              'Veuillez remplir chaque champ.';
                          _buildErrorMessage(errorMessage);
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  /// This method builds the information text widget for a given increment.
  /// It displays the information title followed by a colon.
  /// The text color is red if the corresponding patient information is empty, otherwise black.
  Widget _buildInformation(int increment) {
    return Text(
      '${_informationTitle[increment]}: ',
      style: TextStyle(
          fontSize: 15,
          color:
              _patientInformation[increment] == '' ? Colors.red : Colors.black),
    );
  }

  /// This method builds a widget displaying the last and first names of the patient.
  /// It consists of a row with the information title followed by a container displaying the names.
  /// The container has a black border and a border radius of 8.0.
  /// If the corresponding patient information is empty, the text color is red; otherwise, it's black.
  Widget _buildLastAndFirstNames(int increment) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _buildInformation(increment),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  _patientInformation[increment],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: _patientInformation[increment] == ''
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This method builds a dropdown button widget.
  /// It consists of a row with the information title followed by a dropdown button.
  /// The dropdown button is contained in a container with a black border and a border radius of 8.0.
  /// The dropdown button allows the user to select a value from a list of choices.
  /// If the current value is part of the choice list, it is displayed; otherwise, it remains null.
  /// When a new value is selected, the corresponding patient information is updated, and the completion status is checked.
  Widget _buildDropdownButton(int increment) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _buildInformation(increment),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DropdownButton<String>(
                  icon: Container(),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  value: _choiceList[increment]
                          .contains(_patientInformation[increment])
                      ? _patientInformation[increment]
                      : null,
                  items: _choiceList[increment].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _patientInformation[increment] = newValue;
                        _completed = isAllCompleted(_patientInformation);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This method builds the presentation section for drug information.
  /// It consists of a row displaying either "Médicaments:" or "Médicament:" based on the length of drug titles.
  /// The text color is determined by the medication filled status.
  /// It also includes two IconButton widgets for adding and removing medication entries.
  Widget _buildPresentationDrug() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _informationDrugTitle.length > 2
              ? Text(
                  'Médicaments: ',
                  style: TextStyle(
                      fontSize: 15,
                      color: _medicationFilled ? Colors.black : Colors.red),
                )
              : Text(
                  'Médicament: ',
                  style: TextStyle(
                      fontSize: 15,
                      color: _medicationFilled ? Colors.black : Colors.red),
                ),
          SizedBox(
            height: 25,
            width: 25,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: _patientInformationDrug.length == 2
                  ? Colors.red
                  : Colors.black,
              onPressed: () {
                setState(() {
                  if (_counter > 1) {
                    _counter -= 1;
                    for (int i = 0; i < 2; i++) {
                      _patientInformationDrug.removeLast();
                      _informationDrugTitle.removeLast();
                      _choiceListDrug.removeLast();
                    }
                    _medicationFilled = isAllCompleted(_patientInformationDrug);
                  }
                });
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ),
          SizedBox(
            height: 25,
            width: 25,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _counter += 1;
                  _patientInformationDrug.add('');
                  _informationDrugTitle.add('Médicament');
                  _choiceListDrug.add(_choiceListDrug[0]);

                  _patientInformationDrug.add('');
                  _informationDrugTitle.add('Dosage');
                  _choiceListDrug.add(_choiceListDrug[1]);

                  _medicationFilled = isAllCompleted(_patientInformationDrug);
                });
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ),
        ],
      ),
    );
  }

  /// This method builds a section for displaying drug information.
  /// It consists of two dropdown buttons horizontally aligned.
  /// The dropdown buttons are built using the _buildDropdownButtonDrug method.
  /// The increment parameter is used to calculate indices for accessing drug information.
  Widget _buildSectionDrug(int increment) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownButtonDrug(2 * increment),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownButtonDrug((2 * increment) + 1),
          ),
        ],
      ),
    );
  }

  /// This method builds a dropdown button for selecting drug information.
  /// The dropdown button displays a list of drug options horizontally.
  /// The increment parameter is used to calculate indices for accessing drug information.
  Widget _buildDropdownButtonDrug(int increment) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DropdownButton<String>(
          icon: Container(),
          underline: Container(
            height: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          value: _choiceListDrug[increment]
                  .contains(_patientInformationDrug[increment])
              ? _patientInformationDrug[increment]
              : null,
          items: _choiceListDrug[increment].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                _patientInformationDrug[increment] = newValue;
                _medicationFilled = isAllCompleted(_patientInformationDrug);
              }
            });
          },
        ),
      ),
    );
  }

  /// This method builds a container for describing patient information.
  /// The increment parameter determines which piece of information to display.
  Widget _buildDescription(int increment) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _buildInformation(increment),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: _patientInformation[increment],
                  style: TextStyle(
                    fontSize: 15,
                    color: _patientInformation[increment] == ''
                        ? Colors.red
                        : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _patientInformation[increment] = newValue!;
                      _completed = isAllCompleted(_patientInformation);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays a dialog to indicate that the data has been successfully saved.
  Future<void> _buildSavedMessage() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 40,
              ),
              const SizedBox(height: 20),
              const Text(
                'Données enregistrées',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Displays an error message dialog.
  Future<void> _buildErrorMessage(String errorMessage) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
