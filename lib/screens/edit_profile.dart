import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/models/auth_service.dart';
import 'package:restaurant_ui_kit/models/users.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:restaurant_ui_kit/screens/profile.dart';
import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';

class EditProfile extends StatefulWidget {
  final auth;

  EditProfile({this.auth});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Users users = Users();
  final TextEditingController _fullNameControl = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  Future<User> getCurrentUser() async {
    User currentUser1;
    setState(() {
      currentUser1 = widget.auth.currentUser;
      _isLoading = true;
    });
    return currentUser1;
  }

  getUser() async {
    User currentUser = await getCurrentUser();
    final doc = await firestore.collection('users').doc(currentUser.uid).get();
    setState(() {
      _isLoading = true;
      users = Users.fromMap(doc);
    });
    setState(() {
      _isLoading = false;
    });
    return users;
  }

  Future<void> _saveAndUpdate() async {
    setState(() {
      _isLoading = true;
    });
    User currentUser = await getCurrentUser();
    if (_fullNameControl.text.trim().isNotEmpty &&
        _phone.text.trim().isNotEmpty &&
        _address.text.trim().isNotEmpty &&
        _gender.text.trim().isNotEmpty &&
        _dateOfBirth.text.trim().isNotEmpty) {
      final doc =
          await firestore.collection('users').doc(currentUser.uid).update({
        'id': currentUser.uid,
        'email': currentUser.email,
        'fullName': _fullNameControl.text.trim(),
        'phone': _phone.text.trim(),
        'address': _address.text.trim(),
        'gender': _gender.text.trim(),
        'dateOfBirth': _dateOfBirth.text.trim()
      });
    } else {
      return;
    }
    await getUser();
  }

  @override
  void initState() {
    getCurrentUser();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService(widget.auth);
    showAlerttDialog(message) {
      showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                  title: Text('An error Occured'),
                  content: Text(message),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Confirm')),
                  ]));
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.asset(
                    "assets/cm4.jpeg",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _isLoading
                              ? Center(
                                  child: CupertinoActivityIndicator(
                                      animating: true),
                                )
                              : Text(
                                  '${users.fullName}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     _isLoading
                      //         ? Center(
                      //             child: CupertinoActivityIndicator(
                      //                 animating: true),
                      //           )
                      //         : Text(
                      //             users.email,
                      //             style: TextStyle(
                      //               fontSize: 14.0,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //   ],
                      // ),
                      SizedBox(height: 20.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     InkWell(
                      //       onTap: () {
                      //         _authService.signOut();
                      //         Navigator.of(context).push(
                      //           MaterialPageRoute(
                      //             builder: (BuildContext context) {
                      //               return SplashScreen();
                      //             },
                      //           ),
                      //         );
                      //       },
                      //       child: Text(
                      //         "Logout",
                      //         style: TextStyle(
                      //           fontSize: 13.0,
                      //           fontWeight: FontWeight.w400,
                      //           color: Theme.of(context).accentColor,
                      //         ),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),
            Divider(),
            Container(height: 15.0),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Account Information".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter your Fullname';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
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
                          hintText: "${users.fullName}",
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        maxLines: 1,
                        controller: _fullNameControl,
                      ),
                    ),
            ),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Text(
                      users.email,
                    ),
            ),
            ListTile(
              title: Text(
                "Phone",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter your Phone number';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
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
                          hintText: "${users.phone}",
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        maxLines: 1,
                        controller: _phone,
                      ),
                    ),
            ),
            ListTile(
              title: Text(
                "Address",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter your Address';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
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
                          hintText: "${users.address}",
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        maxLines: 1,
                        controller: _address,
                      ),
                    ),
            ),
            ListTile(
              title: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter your Gender';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
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
                          hintText: "${users.gender}",
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        maxLines: 1,
                        controller: _gender,
                      ),
                    ),
            ),
            ListTile(
              title: Text(
                "Date of Birth",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(animating: true),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter your BirthDate';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
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
                          hintText: "${users.dateOfBirth}",
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        maxLines: 1,
                        controller: _dateOfBirth,
                      ),
                    ),
            ),
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? SizedBox()
                : ListTile(
                    title: Text(
                      "Dark Theme",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Switch(
                      value: Provider.of<AppProvider>(context).theme ==
                              Constants.lightTheme
                          ? false
                          : true,
                      onChanged: (v) async {
                        if (v) {
                          Provider.of<AppProvider>(context, listen: false)
                              .setTheme(Constants.darkTheme, "dark");
                        } else {
                          Provider.of<AppProvider>(context, listen: false)
                              .setTheme(Constants.lightTheme, "light");
                        }
                      },
                      activeColor: Theme.of(context).accentColor,
                    ),
                  ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isLoading
                    ? Center(
                        child: CupertinoActivityIndicator(
                        animating: true,
                      ))
                    : InkWell(
                        onTap: () {
                          if (_fullNameControl.text.trim().isNotEmpty &&
                              _phone.text.trim().isNotEmpty &&
                              _address.text.trim().isNotEmpty &&
                              _gender.text.trim().isNotEmpty &&
                              _dateOfBirth.text.trim().isNotEmpty) {
                            _saveAndUpdate();
                            Timer(Duration(milliseconds: 150), () {
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return Profile(
                                      auth: widget.auth,
                                    );
                                  },
                                ),
                              );
                            });
                          } else {
                            return showAlerttDialog('Please Enter Valid Data');
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).accentColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
