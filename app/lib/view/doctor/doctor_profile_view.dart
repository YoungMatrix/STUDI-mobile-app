// This StatefulWidget displays personal information of a doctor.

import 'package:flutter/material.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/function/function.dart';

/// A StatefulWidget for displaying personal information of a doctor.
class DoctorPersonalPage extends StatefulWidget {
  const DoctorPersonalPage({
    super.key,
    required this.doctor,
  });

  final Doctor? doctor;

  @override
  State<DoctorPersonalPage> createState() => _DoctorPersonalPageState();
}

/// The State class for DoctorPersonalPage.
class _DoctorPersonalPageState extends State<DoctorPersonalPage> {
  late Doctor? _doctor;
  late List<String> _doctorInformationList;

  final List<String> _information = [
    'Matricule',
    'Spécialité',
    'Nom',
    'Prénom',
    'Profession',
  ];

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
    setState(() {
      _doctorInformationList = fetchDoctorInformation(_doctor);
    });
  }

  /// Builds the UI for the page.
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
                  _buildPresentation(_information),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < _information.length; i++)
                          _buildData(
                              _information[i], _doctorInformationList[i]),
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

  /// Builds the presentation section of the UI.
  Widget _buildPresentation(List<String> information) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Informations personnelles',
                style: TextStyle(fontSize: 20.0),
              ),
              TextSpan(
                text: ' (${information.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the data section of the UI.
  Widget _buildData(String information, dynamic personalInformation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '$information: ',
              ),
              _doctorInformationList.contains('N/A')
                  ? const TextSpan(
                      text: 'Chargement...',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : TextSpan(
                      text: '$personalInformation',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
