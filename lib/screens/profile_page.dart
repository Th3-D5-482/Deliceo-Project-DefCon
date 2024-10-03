import 'package:defcon/constants/app_name.dart';
import 'package:defcon/database/usersdb.dart';
import 'package:defcon/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController emailID = TextEditingController();
  late TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailID = TextEditingController();
    password = TextEditingController();
    initializeEmailAndPassword();
  }

  void initializeEmailAndPassword() async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    String? loggedEmail = sharePref.getString('loggedInEmailID');
    String? loggedPassword = sharePref.getString('loggedInPassword');
    setState(() {
      emailID.text = loggedEmail ?? '';
      password.text = loggedPassword ?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailID.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppName(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset('assets/images/bg_image.png'),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person_pin_rounded,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'EmailID',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: emailID,
                                      decoration: InputDecoration(
                                        border: Theme.of(context)
                                            .inputDecorationTheme
                                            .focusedBorder,
                                        fillColor: const Color.fromRGBO(
                                            228, 228, 228, 1),
                                        filled: true,
                                      ),
                                      enabled: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextField(
                                      controller: password,
                                      decoration: InputDecoration(
                                        enabledBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .enabledBorder,
                                        focusedBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .focusedBorder,
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                      obscureText: true,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (password.text.length < 8) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter a password that is at least 8 characters long'),
                                      ),
                                    );
                                  } else {
                                    updateProfile(
                                      emailID.text,
                                      password.text,
                                      context,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: Text(
                                  'Update profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return LoginPage(
                                        emailID: emailID.text,
                                        password: password.text,
                                      );
                                    },
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: Text(
                                  'Logout',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
