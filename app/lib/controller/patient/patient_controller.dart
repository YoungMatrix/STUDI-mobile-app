import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/model/patient/patient_model.dart';

// File verified

/// Controller class for handling patient-related operations.
class PatientController {
  /// Retrieves a list of patients associated with a given doctor.
  ///
  /// This method checks if the doctor is not null, then it
  /// calls the retrievePatient method from the PatientModel to get the list
  /// of patients associated with the doctor from the database.
  ///
  /// @param database The database instance to be used for the query.
  /// @param doctor The doctor whose patients are to be retrieved.
  /// @return A Future that completes with a list of Patient objects if the doctor
  /// is not null, or an empty list if the doctor is null.
  static Future<List<Patient>> patientList(
      Database? database, Doctor? doctor) async {
    if (doctor != null) {
      // Attempt to retrieve the list of patients for the given doctor
      List<Patient> patientList =
          await PatientModel.retrievePatient(database, doctor);
      return patientList;
    }
    // Return an empty list if the doctor is null
    return [];
  }

  /// Retrieves a list of labels and drugs based on patient information.
  ///
  /// This method calls the retrieveLabelAndDrugLists method from the PatientModel
  /// to get the list of labels and drugs from the database.
  ///
  /// @param database The database instance to be used for the query.
  /// @param patientInformationDrug A list of strings representing patient drug information.
  /// @return A Future that completes with a list of labels and drugs.
  static Future<List<dynamic>> labelAndDrugLists(
      Database? database, List<String> patientInformationDrug) async {
    // Retrieve the list of labels and drugs from the database
    List<dynamic> labelList = await PatientModel.retrieveLabelAndDrugLists(
        database, patientInformationDrug);
    return labelList;
  }

  /// Saves patient information to the database.
  ///
  /// This method calls the savePatientInformation method from the PatientModel
  /// to save the patient information in the database.
  ///
  /// @param database The database instance to be used for the query.
  /// @param patient The patient whose information is to be saved.
  /// @param patientInformation A list of strings representing patient information.
  /// @param patientInformationDrug A list of strings representing patient drug information.
  /// @return A Future that completes with a boolean indicating the success of the operation.
  static Future<bool> successSavePatientInformation(
      Database? database,
      Patient? patient,
      List<String> patientInformation,
      List<String> patientInformationDrug) async {
    // Save the patient information in the database and return the success status
    return PatientModel.savePatientInformation(
        database, patient, patientInformation, patientInformationDrug);
  }
}
