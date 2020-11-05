import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id;
  String userName;
  String email;
  String profilePhoto;
  String fullName;
  String phone;
  String address;
  String gender;
  String dateOfBirth;

  Users({
    this.id,
    this.userName,
    this.email,
    this.profilePhoto,
    this.fullName,
    this.phone,
    this.address,
    this.gender,
    this.dateOfBirth,
  });

  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User> getCurrentUser() async {
    User currentUser1;
    currentUser1 = _auth.currentUser;
    return currentUser1;
  }

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['id'] = user.id;
    data['userName'] = user.userName;
    data['email'] = user.email;
    data['profilePhoto'] = user.profilePhoto;
    return data;
  }

  Users.fromMap(DocumentSnapshot doc) {
    Map getDoc = doc.data();
    this.id = getDoc['id'];
    this.userName = getDoc['userName'];
    this.email = getDoc['email'];
    this.profilePhoto = getDoc['profilePhoto'];
    this.fullName = getDoc['fullName'];
    this.phone = getDoc['phone'];
    this.address = getDoc['address'];
    this.gender = getDoc['gender'];
    this.dateOfBirth = getDoc['dateOfBirth'];
  }

  Future<void> addDatatoCloud(User currentUser) async {
    User currentUser = await getCurrentUser();
    var user = Users(
      id: currentUser.uid,
      email: currentUser.email,
      userName: 'not added yet',
      profilePhoto: 'not added yet',
      fullName: 'fullName',
      phone: 'phone',
      address: 'address',
      gender: 'gender',
      dateOfBirth: 'dateOfBirth',
    );

    await firestore.collection('users').doc(currentUser.uid).set({
      'id': currentUser.uid,
      'email': currentUser.email,
      'userName': user.userName,
      'profilePhoto': user.profilePhoto,
      'fullName': user.fullName,
      'phone': user.phone,
      'address': user.address,
      'gender': user.gender,
      'dateOfBirth': user.dateOfBirth,
    });
  }

  Future<void> getDatafromCloud(firebaseUser) async {
    final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
    final user = Users.fromMap(doc);
    return user;
  }
}
