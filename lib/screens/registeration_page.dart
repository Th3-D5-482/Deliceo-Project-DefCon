import 'package:defcon/database/usersdb.dart';
import 'package:defcon/screens/login_page.dart';
import 'package:flutter/material.dart';

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  late TextEditingController emailID = TextEditingController();
  late TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailID = TextEditingController(text: 'Th3_D5_482@gmail.com');
    password = TextEditingController(text: '12345678');
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
                            'Sign Up',
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
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
                                signUp(emailID.text, password.text, context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Register',
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
                          height: 230,
                        ),
                        Text(
                          'Already have an account?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginPage(
                                    emailID: emailID.text,
                                    password: password.text,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Text('Sign In'),
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
