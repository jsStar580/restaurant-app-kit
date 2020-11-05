import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/models/auth_service.dart';
import 'package:restaurant_ui_kit/models/users.dart';
import 'package:restaurant_ui_kit/screens/join.dart';
import 'package:restaurant_ui_kit/screens/login.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_ui_kit/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    Users users = Users();
    showAlerttDialog(message) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('An error Occured'),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Confirm'),
            ),
          ],
        ),
      );
    }

    _registerMethod() async {
      setState(() {
        _isLoading = true;
      });
      try {
        if (_emailControl.text.trim().isNotEmpty &&
            _passwordControl.text.trim().isNotEmpty) {
          await context.read<AuthService>().signUp(
                email: _emailControl.text.trim(),
                password: _passwordControl.text.trim(),
              );
          users.addDatatoCloud(firebaseUser);
          Timer(Duration(seconds: 1), () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => JoinApp(0),
              ),
            );
          });
        }
      } on FirebaseAuthException catch (error) {
        _emailControl.clear();
        _passwordControl.clear();
        setState(() {
          _isLoading = false;
        });
        return showAlerttDialog(error.message);
      }

      setState(() {
        _isLoading = false;
      });
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "Create an account",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty ||
                      !value.contains("@") ||
                      !value.endsWith('.com')) {
                    return 'Please enter a valid E-mail';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _emailControl,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Please enter a valid password';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordControl,
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: 50.0,
            child: _isLoading
                ? CupertinoActivityIndicator(animating: true)
                : RaisedButton(
                    child: Text(
                      "Register".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await _registerMethod();
                    },
                    color: Theme.of(context).accentColor,
                  ),
          ),
          SizedBox(height: 10.0),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

// Card(
//   elevation: 3.0,
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(
//         Radius.circular(5.0),
//       ),
//     ),
//     child: TextField(
//       style: TextStyle(
//         fontSize: 15.0,
//         color: Colors.black,
//       ),
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.all(10.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5.0),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//         hintText: "Username",
//         prefixIcon: Icon(
//           Icons.perm_identity,
//           color: Colors.black,
//         ),
//         hintStyle: TextStyle(
//           fontSize: 15.0,
//           color: Colors.black,
//         ),
//       ),
//       maxLines: 1,
//       controller: _usernameControl,
//     ),
//   ),
// ),
// SizedBox(height: 10.0),

//  Center(
//             child: Container(
//               width: MediaQuery.of(context).size.width/2,
//               child: Row(
//                 children: <Widget>[
//                   RawMaterialButton(
//                     onPressed: (){},
//                     fillColor: Colors.blue[800],
//                     shape: CircleBorder(),
//                     elevation: 4.0,
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Icon(
//                         FontAwesomeIcons.facebookF,
//                         color: Colors.white,
// //              size: 24.0,
//                       ),
//                     ),
//                   ),

//                   RawMaterialButton(
//                     onPressed: (){},
//                     fillColor: Colors.white,
//                     shape: CircleBorder(),
//                     elevation: 4.0,
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Icon(
//                         FontAwesomeIcons.google,
//                         color: Colors.blue[800],
// //              size: 24.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
