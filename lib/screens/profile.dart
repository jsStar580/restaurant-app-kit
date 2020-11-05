import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/models/auth_service.dart';
import 'package:restaurant_ui_kit/models/users.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:restaurant_ui_kit/screens/edit_profile.dart';
import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';

class Profile extends StatefulWidget {
  final auth;

  Profile({this.auth});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Users users = Users();
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

  @override
  void initState() {
    getCurrentUser();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService(widget.auth);
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
                                  users.email,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _authService.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return SplashScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).accentColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
              title: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                      animating: true,
                    ))
                  : Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              subtitle: Text(
                "${users.fullName}",
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditProfile(
                        auth: widget.auth,
                      ),
                    ),
                  );
                },
                tooltip: "Edit",
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
              subtitle: Text(
                "${users.phone}",
              ),
            ),
            ListTile(
              title: _isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                      animating: true,
                    ))
                  : Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              subtitle: Text(
                "${users.address}",
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
                      child: CupertinoActivityIndicator(
                      animating: true,
                    ))
                  : Text(
                      "${users.gender}",
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
                      child: CupertinoActivityIndicator(
                      animating: true,
                    ))
                  : Text(
                      "${users.dateOfBirth}",
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
          ],
        ),
      ),
    );
  }
}
