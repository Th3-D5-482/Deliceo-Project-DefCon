import 'package:defcon/screens/splash/splash2.dart';
import 'package:flutter/material.dart';

class Splash1 extends StatelessWidget {
  const Splash1({super.key});

  final currentIndexPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/splash/splash1.png',
                width: 380,
                height: 355,
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                'Savor the Moment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'A Symphony of Flavors Awaits',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 108,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: currentIndexPage == currentIndexPage
                            ? const Color.fromRGBO(221, 137, 130, 1)
                            : const Color.fromRGBO(255, 215, 212, 1),
                        size: 30,
                      ),
                      Icon(
                        Icons.circle,
                        color: currentIndexPage != currentIndexPage
                            ? const Color.fromRGBO(221, 137, 130, 1)
                            : const Color.fromRGBO(255, 215, 212, 1),
                        size: 30,
                      ),
                      Icon(
                        Icons.circle,
                        color: currentIndexPage != currentIndexPage
                            ? const Color.fromRGBO(221, 137, 130, 1)
                            : const Color.fromRGBO(255, 215, 212, 1),
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const Splash2();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 24,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
