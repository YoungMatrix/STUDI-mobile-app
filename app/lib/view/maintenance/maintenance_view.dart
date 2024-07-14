// This view is displayed when the application is undergoing maintenance.
// It informs users about the temporary unavailability of the application.

import 'package:flutter/material.dart';

// File verified

/// Represents the maintenance view displayed when the app is under maintenance.
///
/// @return A Scaffold widget with maintenance information.
class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maintenance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.settings,
                size: 100,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 20),
              const Text(
                'Désolé, nous sommes actuellement en maintenance.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Nous serons bientôt de retour.\nMerci pour votre compréhension.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
