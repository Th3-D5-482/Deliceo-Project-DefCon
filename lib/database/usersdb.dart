import 'package:defcon/screens/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DatabaseReference dbRefUsers = FirebaseDatabase.instance.ref('Users');

Future signUp(
  String emailID,
  String password,
  BuildContext context,
) async {
  DatabaseEvent event =
      await dbRefUsers.orderByChild('emailID').equalTo(emailID).once();
  if (event.snapshot.value != null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account  already exists, please login'),
      ),
    );
  } else {
    String sanitizedEmailID = emailID.replaceAll('.', ',');
    await dbRefUsers.child(sanitizedEmailID).set({
      'emailID': emailID,
      'password': password,
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SignUp sucessfully'),
      ),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return LoginPage(
          emailID: emailID,
          password: password,
        );
      },
    ));
  }
}

Future<List<Map<String, dynamic>>> login(
  String emailID,
  String password,
  BuildContext context,
) async {
  DatabaseEvent event =
      await dbRefUsers.orderByChild('emailID').equalTo(emailID).once();
  if (event.snapshot.value == null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account doesn't exist, please signup"),
      ),
    );
    return [];
  } else {
    final DataSnapshot snapshot = event.snapshot;
    final List<Map<String, dynamic>> exisitingLogin = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> values =
          event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        exisitingLogin.add({
          'emailID': value['emailID'],
          'password': value['password'],
        });
      });
    }
    return exisitingLogin;
  }
}

Future updateProfile(
  String emailID,
  String password,
  BuildContext context,
) async {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String santiziedEmailID = email.toString().replaceAll('.', ',');
  DatabaseEvent event = await dbRefUsers.child(santiziedEmailID).once();
  DataSnapshot snapshot = event.snapshot;
  if (snapshot.exists) {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    String currentPassword = values['password'];
    if (currentPassword == password) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is the same, please change the password'),
        ),
      );
    } else {
      String newPassword = password;
      await dbRefUsers.child(santiziedEmailID).update({
        'password': newPassword,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated sucessfully'),
        ),
      );
    }
  }
}
