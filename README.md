# STUDI Mobile Application

## Requirements
- **Android Studio Electric Eel** version >= 2022.1.1 Patch 1
    - .env files support plugin
- **Flutter** version >= 3.22.2
- **Dart SDK** version >= 3.4.3
- **Emulator** Pixel 2 API 33 17 Gb for example.
- **Database connection parameters** (online or local database).

## Steps to Prepare the Application for Windows

### Clone Repository
1. Open Android Studio.
2. In the terminal:
   ```bash
   git clone https://github.com/YoungMatrix/STUDI-mobile-app
3. Login to GIT if necessary.

### Setup Environment
4. In Android Studio, open the directory directly in STUDI-mobile-app.
5. Create .env file in /app directory with the following content:
   # File verified

   # Database connection parameters (online or local database)
   DB_HOST=To Be Completed (IP for emulator if local database)
   DB_PORT=TBC
   DB_USER=TBC
   DB_PASSWORD=TBC
   DB_NAME=TBC

6. Install .env files support plugin directly from .env file.
7. Restart Android Studio.
8. Open Files => Settings => Languages & Frameworks => Dart.
9. Click on Enable Dart support for the project "STUDI-mobile-app".
10. Fill Dart SDK path: C:\...\flutter\bin\cache\dart-sdk (complete ...).
11. Enable Dart support for project "STUDI-mobile-app".
12. Open pubspec.yaml then click on "flutter pub get".

### Database Setup
13. Start Apache and MySQL from XAMPP Control Panel.
14. Open MySQL as admin.
15. In phpMyAdmin, create a new database named ecf_studi_verified.
16. Import the file ecf_studi_verified.sql from STUDI-mobile-app/db directory into the newly created database.

### Steps to Launch the Application for Windows
17. Open Android Emulator.
18. Add configuration then open Flutter for "main.dart".
19. Launch the application.
