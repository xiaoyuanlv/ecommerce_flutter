import 'package:ecommerce_flutter/screens/home_page.dart';
import 'package:ecommerce_flutter/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/widgets/custom_button.dart';
import 'package:ecommerce_flutter/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // Show Dialog
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      context: context, barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Close"))
          ],
        );
      }
    );
  }

  // Create a new user account
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }

      return e.message;

    } catch(e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    //Set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });

    // Run the create account method
    String _createAccountFeedback = await _createAccount();

    // if the string is not null, we got error while create account
    if(_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      // Set the form to register state [ not loading ]
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  // Default Form Loading State
  bool _registerFormLoading = false;

  // Form Input Field Values
  String _registerEmail = "";
  String _registerPassword =  "";

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    "Create A New Account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                )
                ,
                Column(
                  children: [
                    CustomInput(
                      hintText: "Email",
                      onChanged: (value) {
                        _registerEmail = value;
                      },
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                    ),
                    CustomInput(
                      hintText: "Password",
                      onChanged: (value) {
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Create New Account",
                      onPressed: () {
                       _submitForm();
                      },
                      isLoading: _registerFormLoading,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: CustomBtn(
                    text: "Back To Login",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
