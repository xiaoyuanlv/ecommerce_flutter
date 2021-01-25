import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/screens/home_page.dart';
import 'package:ecommerce_flutter/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                if(streamSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamSnapshot.error}"),
                    ),
                  );
                }

                // Connection state acive - do the user login check inside
                if(streamSnapshot.connectionState == ConnectionState.active) {
                  User _user = streamSnapshot.data;

                  // if the user is null, we are not logged in
                  if(_user == null) {
                    return LoginPage();
                  } else {
                    return HomePage();
                  }
                }

                  //Checking the auth state - loading
                 return Scaffold(
                    body: Container(
                      child: Center(
                        child: Text(
                          "Checking Authentication...",
                          style: Constants.regularHeading,
                        ),
                      ),
                    ),
                  );

              },
            );
          }

          return Scaffold(
            body: Container(
              child: Center(
                child: Text(
                  "Initialization App",
                  style: Constants.regularHeading,
                ),
              ),
            ),
          );

        }
    );
  }
}