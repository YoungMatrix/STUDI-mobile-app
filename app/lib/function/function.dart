import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/controller/doctor/doctor_controller.dart';
import 'package:soigne_pro/controller/patient/patient_controller.dart';
import 'package:flutter/services.dart' show rootBundle;

// File verified

// For All
/// Function to set up the database connection.
///
/// This function initializes and configures the database connection using the provided parameters.
///
/// @param hostData The host address of the database server.
/// @param portData The port number of the database server.
/// @param userData The username for authenticating with the database server.
/// @param passwordData The password for authenticating with the database server.
/// @param dbData The name of the database to connect to.
/// @return A Future containing a Database instance once the connection is established, or null if the connection fails.
Future<Database?> initialiseDatabase(String hostData, int portData,
    String userData, String passwordData, String dbData) async {
  try {
    final db = Database(); // Create an instance of the Database class
    await db.connect(
      // Use the connect() method of the Database class
      host: hostData,
      port: portData,
      user: userData,
      password: passwordData,
      db: dbData,
    );

    if (kDebugMode) {
      // Print a debug message if in debug mode
      //print('Connected to the database.');
    }
    return db; // Return the database instance once the connection is established
  } catch (e) {
    if (kDebugMode) {
      // Print an error message if in debug mode
      //print('Error connecting to the database: $e');
    }
    return null; // Return null if an error occurs during connection
  }
}

/// Generates a hash of the provided word using the SHA-256 algorithm.
///
/// @param word The word to be hashed.
/// @return A hexadecimal string representing the hashed word.
String hashWord(String word) {
  // Convert word to bytes
  final List<int> wordBytes = utf8.encode(word);

  // Hash the word using SHA-256
  final Digest digest = sha256.convert(wordBytes);

  // Convert the hash digest to a hexadecimal string
  final String hashedWord = digest.toString();

  return hashedWord;
}

/// Verify the hashed password against the entered password.
///
/// This function reconstructs the hashed password using the provided salt and pepper,
/// and then compares it with the hashed password entered by the doctor.
///
/// @param hashedPasswordDoctor The hashed password entered by the doctor.
/// @param hashedPassword The hashed password stored in the database.
/// @param hashedSalt The salt used for password hashing.
/// @param hashedPepper The hashed pepper used for password hashing.
/// @return True if the passwords match, otherwise false.
bool verifyPassword(String hashedPasswordDoctor, String hashedPassword,
    String hashedSalt, String hashedPepper) {
  // Reconstruct the hashed password without salt and pepper
  String passwordNoSalt = hashedPassword.replaceAll(RegExp(hashedSalt), '');
  String passwordNoSaltNoPepper =
      passwordNoSalt.replaceAll(RegExp(hashedPepper), '');

  // Compare the reconstructed hash with the entered hashed password
  return hashedPasswordDoctor == passwordNoSaltNoPepper;
}

/// Authenticates a user using the provided email and password asynchronously.
///
/// @param context The BuildContext used for navigation purposes.
/// @param database The database instance.
/// @param prefs SharedPreferences instance containing user data.
/// @param email The user's email address.
/// @param password The user's password.
/// @return A Future containing a Map with authentication-related data:
///         - 'token': A boolean indicating whether authentication was successful.
///         - 'doctor': The authenticated doctor object, if authentication was successful.
///         - 'patientList': The list of patients associated with the authenticated doctor.
///         - 'errorText': A string containing an error message if authentication failed.
///         - 'selectedTab': An integer representing the index of the selected tab after authentication.
Future<Map<String, dynamic>> submitLoginButton(
    BuildContext context,
    Database? database,
    SharedPreferences prefs,
    String email,
    String password) async {
  // Attempt to retrieve a Doctor object using the provided email and password.
  Doctor? doctor =
      await DoctorController.doctorObject(database, email, password);

  // Retrieve the list of patients associated with the authenticated doctor.
  List<Patient> patientList =
      await PatientController.patientList(database, doctor);

  // Determine authentication success and error message.
  bool token = doctor != null;
  String errorText = doctor != null ? '' : 'E-mail/Mot de passe incorrects';
  int selectedTab = doctor != null ? 2 : 0;

  // Save user data, including token, email, password, and potential error message, in SharedPreferences.
  prefs = (await saveData(token, selectedTab, doctor));

  // Return a Map containing authentication-related data.
  return {
    'prefs': prefs,
    'doctor': doctor,
    'patientList': patientList,
    'token': token,
    'errorText': errorText,
    'selectedTab': selectedTab,
  };
}

/// Logs out a user by clearing patient data and returning authentication-related data.
///
/// @param context The BuildContext used for navigation purposes.
/// @param patientList The list of patients associated with the authenticated doctor.
///
/// @return A Map containing authentication-related data:
///         - 'token': A boolean indicating whether authentication was successful.
///         - 'errorText': An optional error message to be displayed.
///         - 'selectedTab': An integer representing the index of the selected tab.
///         - 'doctor': The authenticated doctor object, if available.
///         - 'patientList': An empty list of patients.
Map<String, dynamic> submitLogoutButton(
    BuildContext context, List<Patient> patientList) {
  // Clear patient data
  patientList.clear();

  // Close the logout dialog
  Navigator.of(context).pop();

  // Return authentication-related data indicating logout
  return {
    'token': false,
    'errorText': null,
    'selectedTab': 0,
    'doctor': null,
    'patientList': patientList,
  };
}

/// Saves user data, including the authentication token, selected tab index, and doctor object,
/// into SharedPreferences.
///
/// @param token A boolean indicating whether authentication was successful.
/// @param selectedTab An integer representing the index of the selected tab.
/// @param doctor The authenticated doctor object, if available.
///
/// @return A Future containing SharedPreferences after the data is successfully saved.
Future<SharedPreferences> saveData(
    bool token, int selectedTab, Doctor? doctor) async {
  // Retrieve an instance of SharedPreferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Save user data to SharedPreferences.
  prefs.setBool('token', token);
  prefs.setInt('selectedTab', selectedTab);
  prefs.setString('doctor', doctor != null ? jsonEncode(doctor.toJson()) : '');

  // Return the updated SharedPreferences instance.
  return prefs;
}

/// Loads saved user data from SharedPreferences asynchronously.
///
/// @param prefs The SharedPreferences instance from which to load data.
/// @param database The database instance needed for loading patient data.
///
/// @return A Future containing a Map with user data:
///         - 'token': A boolean indicating whether authentication was successful.
///         - 'selectedTab': An integer representing the index of the selected tab.
///         - 'doctor': The authenticated doctor object, if available.
///         - 'patientList': A list of patients associated with the authenticated doctor.
Future<Map<String, dynamic>> loadSavedData(
    SharedPreferences? prefs, Database database) async {
  // Define variables to store user data
  bool token;
  int selectedTab;
  Doctor? doctor;
  List<Patient> patientList;

  // Retrieve data from SharedPreferences and set default values if not found
  token = prefs?.getBool('token') ?? false;
  selectedTab = prefs?.getInt('selectedTab') ?? 0;
  String? doctorJson = prefs?.getString('doctor');
  if (doctorJson != null && doctorJson.isNotEmpty) {
    doctor = Doctor.fromJson(jsonDecode(doctorJson));
  } else {
    doctor = null;
  }
  patientList = await PatientController.patientList(database, doctor);

  // Return user data as a Map
  return {
    'token': token,
    'selectedTab': selectedTab,
    'doctor': doctor,
    'patientList': patientList
  };
}
// End All

// For Doctor
/// Function to retrieve doctor information from the database based on the email address.
///
/// @param db The database instance.
/// @param emailDoctor The email address of the doctor.
/// @return A Future containing a Map with the doctor information,
///         including ID, field name, last name, first name, password, and salt,
///         or null if the doctor is not found.
Future<Map<String, String>?> getDoctorInformation(
    Database db, String emailDoctor) async {
  try {
    // Load the SQL script from the assets
    String query =
        await rootBundle.loadString('assets/sql/get_doctor_information.sql');

    //
    String queryWithPositionalParams = query.replaceAll(':emailDoctor', '?');

    // Execute the query
    var results =
        await db.connection.query(queryWithPositionalParams, [emailDoctor]);

    if (results.isNotEmpty) {
      final row = results.first;
      final Map<String, String> doctorInformation = {
        'doctorId': row['id_doctor'].toString(),
        'doctorFieldName': row['name_field'].toString(),
        'doctorLastName': row['last_name_doctor'].toString(),
        'doctorFirstName': row['first_name_doctor'].toString(),
        'doctorPassword': row['password_doctor'].toString(),
        'doctorSalt': row['salt_doctor'].toString(),
      };

      return doctorInformation;
    } else {
      // Doctor not found
      //print('Doctor not found.');
      return null;
    }
  } catch (e) {
    // Handle errors
    //print('Error retrieving doctor information: $e');
    return null;
  }
}

/// Fetches doctor information and returns a list containing doctor details.
///
/// @param doctor The doctor object containing the information.
///
/// @return A list containing doctor information in the following order:
///         - Doctor ID
///         - Field
///         - Last Name
///         - First Name
///         - Role
List<String> fetchDoctorInformation(Doctor? doctor) {
  if (doctor != null) {
    return [
      doctor.id,
      doctor.field,
      doctor.lastName,
      doctor.firstName,
      doctor.role,
    ];
  } else {
    // Return default values if the doctor is null
    return ['N/A', 'N/A', 'N/A', 'N/A', 'N/A'];
  }
}

/// Fetches the list of patients associated with a doctor asynchronously.
///
/// @param database The database instance.
/// @param doctor The doctor object for whom the patient list is fetched.
///
/// @return A Future containing a list of Patient objects.
Future<List<Patient>> fetchPatientList(
    Database? database, Doctor? doctor) async {
  // Retrieve the list of patients associated with the doctor
  List<Patient> patientList =
      await PatientController.patientList(database, doctor);
  return patientList;
}
// End Doctor

// For Patient
/// Function to retrieve patients scheduled for today from the database based on the doctor ID.
///
/// @param db The database instance.
/// @param doctorId The ID of the doctor.
/// @return A Future containing a List of Maps with patient information scheduled for today,
///         including patient ID, last name, first name, prescription details, and planning ID,
///         or null if no patients are scheduled for today.
Future<List<Map<String, dynamic>>?> getPatientToday(
    Database db, String doctorId) async {
  try {
    // Get today's date
    DateTime today = DateTime.now();

    // Format the date as yyyy-MM-dd
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    // Load the SQL script from the assets
    String query =
        await rootBundle.loadString('assets/sql/get_patient_today.sql');

    //
    String queryWithPositionalParams =
        query.replaceAll(':doctorId', '?').replaceAll(':formattedDate', '?');

    // Execute the query with the doctorId and formattedDate parameters
    var results = await db.connection
        .query(queryWithPositionalParams, [doctorId, formattedDate]);

    if (results.isNotEmpty) {
      List<Map<String, dynamic>> allPatientInfo = [];

      for (var row in results) {
        final String patientId = row['id_patient'].toString();
        final String prescriptionId = row['id_prescription'].toString();
        final String planningId = row['id_planning'].toString();

        Map<String, dynamic>? patientInfo = await getPatientInformation(
            db, patientId, prescriptionId, planningId);

        if (patientInfo != null) {
          allPatientInfo.add(patientInfo);
        }
      }

      return allPatientInfo;
    } else {
      // No patients scheduled for today
      //print('No patients scheduled for today.');
      return null;
    }
  } catch (e) {
    // Handle errors
    //print('Error retrieving patients for today: $e');
    return null;
  }
}

/// Function to retrieve patient information from the database based on the patient ID and prescription ID.
///
/// @param db The database instance.
/// @param patientId The ID of the patient.
/// @param prescriptionId The ID of the prescription.
/// @return A Future containing a Map with the patient information,
///         including ID, last name, first name, and prescription details,
///         or null if the patient is not found.
Future<Map<String, dynamic>?> getPatientInformation(Database db,
    String patientId, String prescriptionId, String planningId) async {
  try {
    // Load the SQL script from assets
    String query =
        await rootBundle.loadString('assets/sql/get_patient_information.sql');

    //
    String queryWithPositionalParams = query.replaceAll(':patientId', '?');

    // Execute the query with the patient ID parameter
    var results =
        await db.connection.query(queryWithPositionalParams, [patientId]);

    if (results.isNotEmpty) {
      final row = results.first;
      final Map<String, dynamic>? prescriptionList =
          await getPrescription(db, prescriptionId);

      // Construct the patient information map
      final Map<String, dynamic> patientInformation = {
        'patientId': patientId,
        'patientLastName': row['last_name_patient'].toString(),
        'patientFirstName': row['first_name_patient'].toString(),
        'patientPrescription': prescriptionList,
        'planningId': planningId,
      };

      return patientInformation;
    } else {
      // Patient not found
      //print('Patient not found');
      return null;
    }
  } catch (e) {
    // Handle errors
    //print('Error retrieving patient information: $e');
    return null;
  }
}

/// Function to retrieve prescription information from the database based on the prescription ID.
///
/// @param db The database instance.
/// @param prescriptionId The ID of the prescription.
/// @return A Future containing a Map with prescription information,
///         including prescription ID, date, title, medication list, start date,
///         end date, and description, or null if the prescription is not found.
Future<Map<String, dynamic>?> getPrescription(
    Database db, String? prescriptionId) async {
  try {
    if (prescriptionId == null || prescriptionId.isEmpty) {
      return null;
    }

    // Load the SQL script from the assets
    String query =
        await rootBundle.loadString('assets/sql/get_prescription.sql');

    // Replace the placeholder with the prescriptionId
    String queryWithPositionalParams = query.replaceAll(':prescriptionId', '?');

    // Execute the query with the prescriptionId parameter
    var results =
        await db.connection.query(queryWithPositionalParams, [prescriptionId]);

    if (results.isNotEmpty) {
      // Format the date fields
      final DateTime prescriptionDate =
          results.first['date_prescription'] as DateTime;
      final DateTime prescriptionStartDate =
          results.first['date_start_prescription'] as DateTime;
      final DateTime prescriptionEndDate =
          results.first['date_end_prescription'] as DateTime;

      // Retrieve medication list
      List<Map<String, String>> medicationList =
          await getMedication(db, prescriptionId);

      // Construct the prescription map
      final Map<String, dynamic> prescriptionMap = {
        'prescriptionId': results.first['id_prescription'].toString(),
        'prescriptionDate': DateFormat('dd/MM/yyyy').format(prescriptionDate),
        'titleLabel': results.first['title_label'].toString(),
        'prescriptionMedicationList': medicationList,
        'prescriptionStartDate':
            DateFormat('dd/MM/yyyy').format(prescriptionStartDate),
        'prescriptionEndDate':
            DateFormat('dd/MM/yyyy').format(prescriptionEndDate),
        'prescriptionDescription': results.first['description'].toString(),
      };

      return prescriptionMap;
    } else {
      // No prescription found.
      //print('No prescription found.');
      return null;
    }
  } catch (e) {
    // Log or report the error
    //print('Error retrieving prescription: $e');
    return null;
  }
}

/// Function to retrieve medication information from the database based on the prescription ID.
///
/// @param db The database instance.
/// @param prescriptionId The ID of the prescription.
/// @return A Future containing a list of maps, where each map represents medication information
///         including medication ID, drug name, and dosage quantity, or an empty list if no medication is found.
Future<List<Map<String, String>>> getMedication(
    Database db, String? prescriptionId) async {
  try {
    if (prescriptionId == null || prescriptionId.isEmpty) {
      return [];
    }

    // Load the SQL script from the assets
    String query = await rootBundle.loadString('assets/sql/get_medication.sql');

    // Replace the placeholder with the prescriptionId
    String queryWithPositionalParams = query.replaceAll(':prescriptionId', '?');

    // Execute the query with the prescriptionId parameter
    var results =
        await db.connection.query(queryWithPositionalParams, [prescriptionId]);

    if (results.isNotEmpty) {
      // Construct the medication list using map
      List<Map<String, String>> medicationList = results.map((row) {
        final String id = row['id_medication'].toString();
        final String drugName = row['name_drug'].toString();
        final String dosageQuantity = row['quantity_dosage'].toString();

        return {
          'medicationId': id,
          'drugName': drugName,
          'dosageQuantity': dosageQuantity,
        };
      }).toList();

      return medicationList;
    } else {
      // No medication found.
      //print('No medication found.');
      return [];
    }
  } catch (e) {
    // Log or report the error
    //print('Error retrieving medication: $e');
    return [];
  }
}

/// Function to send patient information to the database.
///
/// @param db The database instance.
/// @param patient The patient object containing information about the patient.
/// @param patientInformation List of patient information.
/// @param patientInformationDrug List of patient information about medication.
/// @return A Future<bool> indicating whether the patient information was successfully saved.
Future<bool> sendPatientInformation(
    Database db,
    Patient patient,
    List<String> patientInformation,
    List<String> patientInformationDrug) async {
  try {
    // Extract and format patient information
    String prescriptionDate =
        patientInformation[2].split('/').reversed.join('-');
    String startDate = patientInformation[4].split('/').reversed.join('-');
    String endDate = patientInformation[5].split('/').reversed.join('-');
    String description = patientInformation[6];

    // Load the SQL script from the assets
    String query =
        await rootBundle.loadString('assets/sql/send_patient_information.sql');

    // Split the SQL script into multiple queries
    List<String> queries = query
        .split(';')
        .map((q) => q.trim())
        .where((q) => q.isNotEmpty)
        .toList();

    // Begin transaction
    await db.connection.query('START TRANSACTION');

    // Get the label ID
    String labelQuery = queries[1].replaceAll(':labelTitle', '?');
    final labelIdResult =
        await db.connection.query(labelQuery, [patientInformation[3]]);

    if (labelIdResult.isEmpty) {
      await db.connection.query('ROLLBACK');
      return false; // Label ID not found
    }

    final labelId = int.parse(labelIdResult.first['id_label'].toString());
    // End

    // Get the drug and dosage ID
    List<int> drugIdList = [];
    List<int> dosageIdList = [];

    for (int i = 0; i < patientInformationDrug.length; i += 2) {
      // Get the drug ID
      String drugQuery = queries[2].replaceAll(':drugName', '?');
      final drugIdResult =
          await db.connection.query(drugQuery, [patientInformationDrug[i]]);

      // Get the dosage ID
      String dosageQuery = queries[3].replaceAll(':dosageQuantity', '?');
      final dosageIdResult = await db.connection
          .query(dosageQuery, [patientInformationDrug[i + 1]]);

      if (drugIdResult.isEmpty || dosageIdResult.isEmpty) {
        await db.connection.query('ROLLBACK');
        return false; // Drug or dosage ID not found
      }

      drugIdList.add(int.parse(drugIdResult.first['id_drug'].toString()));
      dosageIdList.add(int.parse(dosageIdResult.first['id_dosage'].toString()));
    }
    // End

    // Get planning information from planning
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String planningQuery =
        queries[4].replaceAll(':planningId', '?').replaceAll(':date', '?');

    final planningResult = await db.connection
        .query(planningQuery, [patient.planningId, formattedDate]);

    if (planningResult.isEmpty) {
      await db.connection.query('ROLLBACK');
      return false; // Planning result not found
    }

    // Extracting necessary information from planning result
    final historyId = int.parse(planningResult.first['id_history'].toString());
    final confirmedDoctorId =
        int.parse(planningResult.first['id_confirmed_doctor'].toString());
    var prescriptionId = planningResult.first['id_prescription'];

    if (prescriptionId != null) {
      prescriptionId = int.parse(prescriptionId.toString());
    }
    // End

    // Get planning dates from planning
    String dateQuery = queries[5].replaceAll(':historyId', '?');
    final dateResult = await db.connection.query(dateQuery, [historyId]);

    if (dateResult.isEmpty) {
      await db.connection.query('ROLLBACK');
      return false; // Planning result not found
    }

    final firstPlanningDateTime = dateResult.first['date_planning'];
    // End

    // Update history with end date
    String historyUpdateQuery = queries[6]
        .replaceAll(':doctorId', '?')
        .replaceAll(':endDate', '?')
        .replaceAll(':historyId', '?');
    await db.connection
        .query(historyUpdateQuery, [confirmedDoctorId, endDate, historyId]);
    // End

    // Delete from planning
    String planningDeleteQuery = queries[7].replaceAll(':historyId', '?');
    await db.connection.query(planningDeleteQuery, [historyId]);
    // End

    // Reset AUTO_INCREMENT for the planning table
    await db.connection.query(queries[8]);
    // End

    // Insert into planning table
    DateTime endDateTime = DateTime.parse(endDate);
    for (DateTime date = firstPlanningDateTime;
        date.isBefore(endDateTime.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      String planningInsertQuery = queries[9]
          .replaceAll(':historyId', '?')
          .replaceAll(':confirmedDoctorId', '?')
          .replaceAll(':prescriptionId', '?')
          .replaceAll(':date', '?');

      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      await db.connection.query(planningInsertQuery, [
        historyId,
        confirmedDoctorId,
        prescriptionId,
        formattedDate,
      ]);
    }
    // End

    if (patient.prescription != null) {
      // Update prescription table
      String updatePrescriptionQuery = queries[10]
          .replaceAll(':labelId', '?')
          .replaceAll(':prescriptionDate', '?')
          .replaceAll(':startDate', '?')
          .replaceAll(':endDate', '?')
          .replaceAll(':prescriptionDescription', '?')
          .replaceAll(':prescriptionId', '?');
      await db.connection.query(updatePrescriptionQuery, [
        labelId,
        prescriptionDate,
        startDate,
        endDate,
        description,
        prescriptionId
      ]);
      // End

      // Delete all patient medications to re-build
      String deleteMedicationQuery =
          queries[11].replaceAll(':prescriptionId', '?');
      await db.connection.query(deleteMedicationQuery, [prescriptionId]);
      // End

      // Reset AUTO_INCREMENT for the medication table
      await db.connection.query(queries[12]);
      // End

      // Insert into medication table if the row does not already exist
      for (int i = 0; i < drugIdList.length; i++) {
        // Check if the row already exists
        String checkMedicationQuery = queries[13]
            .replaceAll(':prescriptionId', '?')
            .replaceAll(':drugId', '?')
            .replaceAll(':dosageId', '?');
        final checkMedicationResult = await db.connection.query(
            checkMedicationQuery,
            [prescriptionId, drugIdList[i], dosageIdList[i]]);

        if (checkMedicationResult.first[0] == 0) {
          // Insert the new medication entry
          String insertMedicationQuery = queries[14]
              .replaceAll(':prescriptionId', '?')
              .replaceAll(':drugId', '?')
              .replaceAll(':dosageId', '?');
          final medicationInsertResult = await db.connection.query(
              insertMedicationQuery,
              [prescriptionId, drugIdList[i], dosageIdList[i]]);

          if (medicationInsertResult.affectedRows! == 0) {
            if (kDebugMode) {
              print(
                  'Insertion failed for id_drug: ${drugIdList[i]}, id_dosage: ${dosageIdList[i]}');
            }
            await db.connection.query('ROLLBACK');
            return false; // Insertion failed
          }
        } else {
          if (kDebugMode) {
            print(
                'Row already exists for id_drug: ${drugIdList[i]}, id_dosage: ${dosageIdList[i]}');
          }
        }
      }
      // End

      // Commit the transaction
      await db.connection.query('COMMIT');
      return true;
    } else {
      // Insert into prescription table
      String prescriptionInsertQuery = queries[15]
          .replaceAll(':labelId', '?')
          .replaceAll(':prescriptionDate', '?')
          .replaceAll(':startDate', '?')
          .replaceAll(':endDate', '?')
          .replaceAll(':prescriptionDescription', '?');
      await db.connection.query(prescriptionInsertQuery,
          [labelId, prescriptionDate, startDate, endDate, description]);
      // End

      // Get the ID of the inserted prescription
      String prescriptionIdQuery = queries[16]
          .replaceAll(':labelId', '?')
          .replaceAll(':prescriptionDate', '?')
          .replaceAll(':startDate', '?')
          .replaceAll(':endDate', '?')
          .replaceAll(':prescriptionDescription', '?');
      final prescriptionIdResult = await db.connection.query(
          prescriptionIdQuery,
          [labelId, prescriptionDate, startDate, endDate, description]);

      if (prescriptionIdResult.isEmpty) {
        await db.connection.query('ROLLBACK');
        return false; // Failed to retrieve inserted prescription ID
      }
      final lastInsertId =
          int.parse(prescriptionIdResult.first['id_prescription'].toString());
      // End

      // Insert into medication table if the row does not already exist
      for (int i = 0; i < drugIdList.length; i++) {
        // Check if the row already exists
        String checkQuery = queries[13]
            .replaceAll(':prescriptionId', '?')
            .replaceAll(':drugId', '?')
            .replaceAll(':dosageId', '?');
        final checkResult = await db.connection
            .query(checkQuery, [lastInsertId, drugIdList[i], dosageIdList[i]]);

        if (checkResult.first[0] == 0) {
          // Insert only if the row does not exist
          String medicationInsertQuery = queries[14]
              .replaceAll(':prescriptionId', '?')
              .replaceAll(':drugId', '?')
              .replaceAll(':dosageId', '?');
          final medicationInsertResult = await db.connection.query(
              medicationInsertQuery,
              [lastInsertId, drugIdList[i], dosageIdList[i]]);

          if (medicationInsertResult.affectedRows! == 0) {
            if (kDebugMode) {
              print(
                  'Insertion failed for id_drug: ${drugIdList[i]}, id_dosage: ${dosageIdList[i]}');
            }
            await db.connection.query('ROLLBACK');
            return false; // Insertion failed
          }
        } else {
          if (kDebugMode) {
            print(
                'Row already exists for id_drug: ${drugIdList[i]}, id_dosage: ${dosageIdList[i]}');
          }
        }
      }
      // End

      // Update planning table
      String planningUpdateQuery = queries[17]
          .replaceAll(':prescriptionId', '?')
          .replaceAll(':historyId', '?');
      await db.connection.query(planningUpdateQuery, [lastInsertId, historyId]);
      // End

      // Commit the transaction
      await db.connection.query('COMMIT');
      return true;
    }
  } catch (e) {
    if (kDebugMode) {
      //print('Error during saving datas: $e');
      await db.connection.query('ROLLBACK');
    }
    return false;
  }
}

/// Fetches patient information for display.
///
/// @param selectedPatient The selected patient for whom information is fetched.
///
/// @return A list of strings containing patient information.
List<String> fetchPatientInformation(Patient? selectedPatient) {
  if (selectedPatient != null) {
    return [
      selectedPatient.lastName,
      selectedPatient.firstName,
      selectedPatient.prescription?.prescriptionDate ?? '',
      selectedPatient.prescription?.titleLabel ?? '',
      selectedPatient.prescription?.prescriptionStartDate ?? '',
      selectedPatient.prescription?.prescriptionEndDate ?? '',
      selectedPatient.prescription?.prescriptionDescription ?? '',
    ];
  } else {
    return ['', '', '', '', '', '', ''];
  }
}

/// Fetches patient medication information for display.
///
/// @param selectedPatient The selected patient for whom medication information is fetched.
///
/// @return A list of strings containing medication information.
List<String> fetchPatientInformationDrug(Patient? selectedPatient) {
  if (selectedPatient != null && selectedPatient.prescription != null) {
    List<String> patientInformationDrug = [];
    List<Map<String, String>>? medicationList =
        selectedPatient.prescription!.medicationList;
    if (medicationList != null) {
      for (var medication in medicationList) {
        if (medication['drugName'] != null) {
          patientInformationDrug.add(medication['drugName']!);
        }
        if (medication['dosageQuantity'] != null) {
          patientInformationDrug.add('${medication['dosageQuantity']}');
        }
      }
    }
    return patientInformationDrug;
  } else {
    return ['', ''];
  }
}

/// Fetches titles for patient medication information for display.
///
/// @param patientInformationDrug The list of patient medication information.
///
/// @return A list of strings containing titles for medication information.
List<String> fetchInformationDrugTitle(List<String> patientInformationDrug) {
  List<String> informationDrugTitle = [];
  double increment = patientInformationDrug.length / 2;
  for (int i = 0; i < increment; i++) {
    informationDrugTitle.add('Médicament');
    informationDrugTitle.add('Dosage');
  }
  return informationDrugTitle;
}

/// Fetches labels asynchronously from the database.
///
/// @param db The database instance.
///
/// @return A Future containing a list of strings representing labels.
Future<List<String>> fetchLabel(Database db) async {
  try {
    // Load the SQL script from the assets
    String query = await rootBundle.loadString('assets/sql/get_labels.sql');

    // Execute the query and fetch results
    final results = await db.connection.query(query);

    if (results.isNotEmpty) {
      List<String> labelList = ['']; // Initialize with an empty string
      for (var row in results) {
        labelList.add(row[0].toString());
      }
      return labelList;
    } else {
      // Return an empty list if no labels are found
      return [];
    }
  } catch (e) {
    // Handle errors and return an empty list
    return [];
  }
}

/// Fetches choice lists for drugs and dosages asynchronously from the database.
///
/// @param db The database instance.
/// @param patientInformationDrug A list containing patient drug information.
///
/// @return A Future containing a list of lists of strings representing choice lists for drugs and dosages.
Future<List<List<String>>> fetchChoiceDrugList(
    Database db, List<String> patientInformationDrug) async {
  try {
    // Load the SQL scripts for retrieving drugs and dosages from the assets
    String drugQuery = await rootBundle.loadString('assets/sql/get_drugs.sql');
    String dosageQuery =
        await rootBundle.loadString('assets/sql/get_dosages.sql');

    // Execute the queries to fetch drugs and dosages
    final drugResults = await db.connection.query(drugQuery);
    final dosageResults = await db.connection.query(dosageQuery);

    // Initialize lists to store choice options for drugs and dosages
    List<String> choiceListDrug = [''];
    List<String> choiceListDosage = [''];

    // Extract drug names from the results and add them to the choice list for drugs
    for (var row in drugResults) {
      choiceListDrug.add(row['name_drug'].toString());
    }

    // Extract dosage quantities from the results and add them to the choice list for dosages
    for (var row in dosageResults) {
      choiceListDosage.add(row['quantity_dosage'].toString());
    }

    // Create the result list by duplicating the choice lists based on the number of drug information pairs
    List<List<String>> result = [];
    double increment = patientInformationDrug.length / 2;
    for (int i = 0; i < increment; i++) {
      result.addAll([choiceListDrug, choiceListDosage]);
    }

    // Return the choice lists for drugs and dosages
    return result;
  } catch (e) {
    // Handle errors and return an empty list in case of failure
    return [[]];
  }
}

/// Generates a list of formatted dates starting from the provided start date.
///
/// @param startDate The start date in the format 'dd/MM/yyyy'.
/// @param count The number of dates to generate.
///
/// @return A list of formatted dates starting from the provided start date.
List<String> generateDateList(String startDate, int count) {
  // Initialize the list with an empty string as the first element
  List<String> dateList = [''];
  try {
    // Parse the start date
    DateTime initialDate = DateFormat('dd/MM/yyyy').parse(startDate);
    // Generate and format the subsequent dates
    for (int i = 0; i < count; i++) {
      DateTime date = initialDate.add(Duration(days: i));
      String dateFormatted = DateFormat('dd/MM/yyyy').format(date);
      dateList.add(dateFormatted);
    }
  } catch (e) {
    // Handle date parsing errors
    if (kDebugMode) {
      print('Error parsing date: $e');
    }
  }
  return dateList;
}

/// Checks if all elements in the provided list are non-empty strings.
///
/// @param list The list to be checked.
///
/// @return True if all elements are non-empty strings, otherwise false.
bool isAllCompleted(List<String> list) {
  for (var element in list) {
    if (element == '') {
      return false;
    }
  }
  return true;
}
// End Patient
