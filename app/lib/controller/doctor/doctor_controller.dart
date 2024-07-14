import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/model/doctor/doctor_model.dart';

// File verified

/// Controller class for handling doctor-related operations.
class DoctorController {
  /// Retrieves a Doctor object based on the provided email and password.
  ///
  /// This method checks if the email and password are not empty, then it
  /// calls the retrieveDoctor method from the DoctorModel to get the Doctor
  /// object from the database. If a matching doctor is found, it is returned;
  /// otherwise, null is returned.
  ///
  /// @param database The database instance to be used for the query.
  /// @param email The email of the doctor to be retrieved.
  /// @param password The password of the doctor to be retrieved.
  /// @return A Future that completes with a Doctor object if the email and password
  /// match a record in the database, or null if no match is found.
  static Future<Doctor?> doctorObject(
      Database? database, String email, String password) async {
    // Check if email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      // Attempt to retrieve the doctor from the database
      Doctor? doctor =
          await DoctorModel.retrieveDoctor(database, email, password);
      // Return the doctor object if found, otherwise return null
      if (doctor != null) {
        return doctor;
      }
    }
    // Return null if email or password are empty or if no doctor is found
    return null;
  }
}
