import 'package:defcon/database/usersdb.dart';
import 'package:defcon/screens/home_page.dart';
import 'package:defcon/screens/registeration_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String emailID;
  final String password;

  const LoginPage({
    super.key,
    required this.emailID,
    required this.password,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailID = TextEditingController();
  late TextEditingController password = TextEditingController();

  late List<Map<String, dynamic>> loginList;

  @override
  void initState() {
    super.initState();
    emailID = TextEditingController(text: widget.emailID);
    password = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    super.dispose();
    emailID.dispose();
    password.dispose();
  }

  void loginFunction(
    String emailID,
    String password,
    BuildContext context,
  ) async {
    loginList = await login(emailID, password, context);
    bool isLoggedIn = false;
    for (var value in loginList) {
      if (value['emailID'] == emailID && value['password'] == password) {
        isLoggedIn = true;
        break;
      }
    }
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login sucessful'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ));
      SharedPreferences sharePref = await SharedPreferences.getInstance();
      await sharePref.setString('loggedInEmailID', emailID);
      await sharePref.setString('loggedInPassword', password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 175,
              color: const Color.fromRGBO(53, 182, 255, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_icon.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Déliceo',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Image.asset('assets/images/bg_image.png'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        TextField(
                          controller: emailID,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Email ID: ',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: password,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Password: ',
                            fillColor: Color.fromRGBO(228, 228, 228, 1),
                            filled: true,
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Forgot Password ?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (emailID.text.isEmpty ||
                                  password.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please Enter the emailID and Password'),
                                  ),
                                );
                              } else if (password.text.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password must be at least 8 characters long'),
                                  ),
                                );
                              } else {
                                loginFunction(
                                  emailID.text,
                                  password.text,
                                  context,
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 190,
                        ),
                        Text(
                          'No account yet?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const RegisterationPage();
                                },
                              ),
                            );
                          },
                          child: const Text('Sign Up Now'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
