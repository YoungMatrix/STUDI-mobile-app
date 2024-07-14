// This file represents the log-out page of the application.

import 'package:flutter/material.dart';

// File verified

/// MyHomeLogOutPage StatefulWidget for displaying the home page when the user is logged out.
class MyHomeLogOutPage extends StatefulWidget {
  const MyHomeLogOutPage({super.key});

  @override
  State<MyHomeLogOutPage> createState() => _MyHomeLogOutPageState();
}

/// State class for MyHomeLogOutPage widget.
class _MyHomeLogOutPageState extends State<MyHomeLogOutPage> {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Bienvenue à l\'hôpital ',
                          ),
                          TextSpan(
                            text: 'SoigneMoi',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                        'Cette application est destinée aux professionnels de la santé afin de donner un avis et une prescription à chaque patient.',
                        style: TextStyle(color: Colors.black, fontSize: 12)),
                    const SizedBox(height: 15),
                    const Text('Pour ce faire, veuillez-vous connecter.',
                        style: TextStyle(color: Colors.black, fontSize: 12)),
                    const SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/home.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5), // Border radius
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
