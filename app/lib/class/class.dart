import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

// File verified

/// Database class for managing the database connection.
///
/// @return A MySqlConnection object representing the database connection.
class Database {
  // Singleton instance of Database
  static final Database _instance = Database._internal();

  // MySQL connection instance
  late MySqlConnection _connection;

  // Connection status flag
  bool _isConnected = false;

  // Factory constructor for Database, returning the singleton instance
  factory Database() {
    return _instance;
  }

  // Private named constructor for internal initialization
  Database._internal();

  /// Connects to the database with the provided parameters.
  ///
  /// @param host The host address of the database.
  /// @param port The port number of the database.
  /// @param user The username for database authentication.
  /// @param password The password for database authentication.
  /// @param db The name of the database to connect to.
  Future<void> connect({
    required String host,
    required int port,
    required String user,
    required String password,
    required String db,
  }) async {
    final settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );

    // Establishing the connection
    _connection = await MySqlConnection.connect(settings);
    _isConnected = true;
  }

  // Getter for the database connection instance
  MySqlConnection get connection => _connection;

  /// Closes the database connection.
  Future<void> closeConnection() async {
    await _connection.close();
    _isConnected = false;
    if (kDebugMode) {
      // Uncomment to enable debug message
      // print('Database closed with success.');
    }
  }

  // Getter for the connection status
  bool get isConnected => _isConnected;
}

/// Represents a person.
///
/// @return A Person object.
class Person {
  // Person's identifier
  final String id;

  // Person's last name
  final String lastName;

  // Person's first name
  final String firstName;

  // Person's role
  String role;

  /// Constructor for the Person class.
  ///
  /// @param id The identifier of the person.
  /// @param lastName The last name of the person.
  /// @param firstName The first name of the person.
  /// @param role The role of the person. Default is an empty string.
  ///
  /// @return A Person object.
  Person({
    required this.id,
    required this.lastName,
    required this.firstName,
    this.role = '', // Default role is an empty string
  });
}

/// Represents a doctor, extending the Person class.
///
/// @return A Doctor object created from the provided map.
class Doctor extends Person {
  // Doctor's field/specialization
  final String field;

  /// Constructor for creating a Doctor object.
  /// Requires id, field, last name, and first name parameters.
  /// Inherits id, last name, and first name parameters from the Person class.
  ///
  /// @param id The identifier of the doctor.
  /// @param field The field/specialization of the doctor.
  /// @param lastName The last name of the doctor.
  /// @param firstName The first name of the doctor.
  /// @return A Doctor object.
  Doctor({
    required super.id,
    required this.field,
    required super.lastName,
    required super.firstName,
  }) : super(
          role: 'Docteur', // Assigning 'Doctor' as the role for Doctor objects
        );

  /// Factory constructor to create a Doctor object from a map.
  ///
  /// @param map A map containing doctor data.
  /// @return A Doctor object.
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['doctorId'],
      field: map['doctorFieldName'],
      lastName: map['doctorLastName'],
      firstName: map['doctorFirstName'],
    );
  }

  /// Converts the Doctor object to a map.
  ///
  /// @return A map representing the Doctor object.
  Map<String, dynamic> toMap() {
    return {
      'doctorId': id,
      'doctorFieldName': field,
      'doctorLastName': lastName,
      'doctorFirstName': firstName,
      'role': 'Docteur', // Since 'role' is constant for Doctor objects
    };
  }

  /// Factory constructor to create a Doctor object from JSON.
  ///
  /// @param json A map containing doctor data in JSON format.
  /// @return A Doctor object.
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['doctorId'],
      field: json['doctorFieldName'],
      lastName: json['doctorLastName'],
      firstName: json['doctorFirstName'],
    );
  }

  /// Converts the Doctor object to JSON.
  ///
  /// @return A JSON map representing the Doctor object.
  Map<String, dynamic> toJson() {
    return {
      'doctorId': id,
      'doctorFieldName': field,
      'doctorLastName': lastName,
      'doctorFirstName': firstName,
    };
  }
}

/// Represents a patient.
class Patient extends Person {
  // Reference to Prescription
  Prescription? prescription;

  // Planning ID
  String? planningId;

  /// Constructor for creating a Patient object.
  ///
  /// @param id The identifier of the patient.
  /// @param lastName The last name of the patient.
  /// @param firstName The first name of the patient.
  /// @param role The role of the patient. Default is 'Patient'.
  /// @param prescription The prescription object associated with the patient.
  /// @param planningId The planning ID associated with the patient.
  /// @return A Patient object.
  Patient({
    required super.id,
    required super.lastName,
    required super.firstName,
    super.role = 'Patient',
    this.prescription,
    this.planningId,
  });

  /// Factory constructor to create a Patient object from a map.
  ///
  /// @param map A map containing patient data.
  /// @return A Patient object.
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['patientId'],
      lastName: map['patientLastName'],
      firstName: map['patientFirstName'],
      role: 'Patient',
      prescription: map['patientPrescription'] != null
          ? Prescription.fromMap(map['patientPrescription'])
          : null,
      planningId: map['planningId'],
    );
  }

  /// Converts the Patient object to a map.
  ///
  /// @return A map representing the Patient object.
  Map<String, dynamic> toMap() {
    return {
      'patientId': id,
      'patientLastName': lastName,
      'patientFirstName': firstName,
      'role': 'Patient',
      'patientPrescription': prescription?.toMap(),
      // Convert Prescription to map
      'planningId': planningId,
    };
  }
}

/// Represents a prescription.
class Prescription {
  final String id; // Prescription identifier
  final String prescriptionDate; // Date of prescription
  final String titleLabel; // Title of prescription
  final List<Map<String, String>>? medicationList; // List of medications
  final String prescriptionStartDate; // Start date of prescription
  final String prescriptionEndDate; // End date of prescription
  final String prescriptionDescription; // Description of prescription

  /// Constructor for creating a Prescription object.
  ///
  /// @param id The identifier of the prescription.
  /// @param prescriptionDate The date of the prescription.
  /// @param titleLabel The title of the prescription.
  /// @param medicationList The list of medications in the prescription.
  /// @param prescriptionStartDate The start date of the prescription.
  /// @param prescriptionEndDate The end date of the prescription.
  /// @param prescriptionDescription The description of the prescription.
  /// @return A Prescription object.
  Prescription({
    required this.id,
    required this.prescriptionDate,
    required this.titleLabel,
    required this.medicationList,
    required this.prescriptionStartDate,
    required this.prescriptionEndDate,
    required this.prescriptionDescription,
  });

  /// Factory constructor to create a Prescription object from a map.
  ///
  /// @param map A map containing prescription data.
  /// @return A Prescription object.
  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['prescriptionId'],
      prescriptionDate: map['prescriptionDate'],
      titleLabel: map['titleLabel'],
      medicationList: map['prescriptionMedicationList'],
      prescriptionStartDate: map['prescriptionStartDate'],
      prescriptionEndDate: map['prescriptionEndDate'],
      prescriptionDescription: map['prescriptionDescription'],
    );
  }

  /// Converts the Prescription object to a map.
  ///
  /// @return A map representing the Prescription object.
  Map<String, dynamic> toMap() {
    return {
      'prescriptionId': id,
      'prescriptionDate': prescriptionDate,
      'titleLabel': titleLabel,
      'prescriptionMedicationList': medicationList,
      'prescriptionStartDate': prescriptionStartDate,
      'prescriptionEndDate': prescriptionEndDate,
      'prescriptionDescription': prescriptionDescription,
    };
  }
}
