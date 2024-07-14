import 'package:flutter/foundation.dart';
import 'package:soigne_pro/class/class.dart';
import 'package:soigne_pro/function/function.dart';

// File verified

/// Controller class for handling doctor-related operations.
class DoctorModel {
  /// Retrieves a doctor from the database based on the provided email and password.
  ///
  /// This method queries the database for the doctor's information using the provided email.
  /// It then hashes the provided password and compares it with the stored hash to authenticate the doctor.
  ///
  /// @param database The database instance to be used for the query.
  /// @param email The email address of the doctor.
  /// @param password The password of the doctor.
  /// @return A Future that completes with a Doctor object if authentication is successful,
  /// or null if the doctor is not found or authentication fails.
  static Future<Doctor?> retrieveDoctor(
      Database? database, String email, String password) async {
    if (database != null) {
      // Fetching doctor information from the database using email
      final Map<String, String>? row =
          await getDoctorInformation(database, email);

      if (row != null) {
        final String doctorPassword = row['doctorPassword']!;
        final String doctorSalt = row['doctorSalt']!;

        // Hashing the entered password with salt and pepper
        String hashedPasswordDoctor = hashWord(password);
        String hashedPassword = doctorPassword;
        String hashedSalt = doctorSalt;
        String hashedPepper = hashWord('Studi');

        // Verifying the hashed password against the stored hash
        bool isPasswordValid = verifyPassword(
            hashedPasswordDoctor, hashedPassword, hashedSalt, hashedPepper);

        if (isPasswordValid) {
          final Doctor doctor = Doctor.fromMap(row);
          if (kDebugMode) {
            print('Doctor retrieved from the database.');
          }
          return doctor;
        } else {
          if (kDebugMode) {
            print('Password is invalid.');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Doctor not found or an error occurred.');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('Database is not initialized.');
      }
      return null;
    }
  }
}
