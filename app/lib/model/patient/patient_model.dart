import 'package:flutter/foundation.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/function/function.dart';

// File verified

/// Controller class for handling patient-related operations.
class PatientModel {
  /// Retrieves a list of patients associated with a given doctor.
  ///
  /// This method checks if the database and doctor are not null, then it calls the retrievePatientToday
  /// method from the database to get the list of patients associated with the given doctor.
  ///
  /// @param database The database instance to be used for the query.
  /// @param doctor The doctor whose patients are to be retrieved.
  /// @return A Future that completes with a list of Patient objects if the database and doctor are not null,
  /// or an empty list if either of them is null.
  static Future<List<Patient>> retrievePatient(
      Database? database, Doctor? doctor) async {
    if (database != null && doctor != null) {
      final List<Map<String, dynamic>>? allPatientInfo =
          await getPatientToday(database, doctor.id);

      if (allPatientInfo != null) {
        List<Patient> patientList = [];

        for (var row in allPatientInfo) {
          final Patient patient = Patient.fromMap(row);
          patientList.add(patient);
        }
        if (kDebugMode) {
          print('List of patients retrieved from the database.');
        }
        return patientList;
      } else {
        if (kDebugMode) {
          print('Patient information not found or an error occurred.');
        }
        return [];
      }
    } else {
      if (kDebugMode) {
        print('Database or doctor is null.');
      }
      return [];
    }
  }

  /// Retrieves a list of labels and drugs based on patient information.
  ///
  /// This method calls the fetchLabel and fetchChoiceDrugList methods to get the list
  /// of labels and drugs from the database based on patient information.
  ///
  /// @param database The database instance to be used for the query.
  /// @param patientInformationDrug A list of strings representing patient drug information.
  /// @return A Future that completes with a list containing labels and drugs.
  static Future<List> retrieveLabelAndDrugLists(
      Database? database, List<String> patientInformationDrug) async {
    if (database != null) {
      final List<String> labelList = await fetchLabel(database);
      final List<List<String>> choiceListDrug = await fetchChoiceDrugList(
        database,
        patientInformationDrug,
      );

      final List<dynamic> result = [];
      result.add(labelList);
      result.add(choiceListDrug);

      return result;
    } else {
      if (kDebugMode) {
        print('Database is null.');
      }
      return [];
    }
  }

  /// Saves patient information to the database.
  ///
  /// This method calls the sendPatientInformation method to save the patient information
  /// in the database.
  ///
  /// @param database The database instance to be used for the query.
  /// @param patient The patient whose information is to be saved.
  /// @param patientInformation A list of strings representing patient information.
  /// @param patientInformationDrug A list of strings representing patient drug information.
  /// @return A Future that completes with a boolean indicating the success of the operation.
  static Future<bool> savePatientInformation(
      Database? database,
      Patient? patient,
      List<String> patientInformation,
      List<String> patientInformationDrug) async {
    if (database != null && patient != null) {
      return sendPatientInformation(
          database, patient, patientInformation, patientInformationDrug);
    } else {
      if (kDebugMode) {
        print('Database or patient is null.');
      }
      return false;
    }
  }
}
