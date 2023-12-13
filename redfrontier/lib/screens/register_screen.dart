import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:redfrontier/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            // color: const Color.fromARGB(255, 164, 14, 4),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter Your Details',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.black, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'assets/images/astronautpng2.png',
                    height: 120,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter New Password',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Re-Enter New Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  NeoPopTiltedButton(
                    color: const Color.fromRGBO(255, 235, 52, 1),
                    onTapUp: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 12,
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
