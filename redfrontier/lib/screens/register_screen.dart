import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/screens/login_screen.dart';
import 'package:redfrontier/services/auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  performRegister() {
    final email = emailC.value.text;
    final pwd = passwordC.value.text;
    final cpwd = confirmPasswordC.value.text;
    if (email.isEmpty || pwd.isEmpty) return;
    if (cpwd != pwd) {
      return CustomDialogs.showDefaultAlertDialog(context,
          contentText: 'passwords do not match',
          contentTitle: 'Register Error');
    }
    FirebaseAuthService.signInWithEmail(
      email,
      pwd,
    );
  }

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
            color: const Color.fromARGB(40, 255, 255, 255),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter Your Details',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.white, fontSize: 25),
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
                    controller: emailC,
                    decoration: InputDecoration(
                      hintText: 'email',
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    controller: passwordC,
                    decoration: InputDecoration(
                      hintText: 'enter new password',
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordC,
                    decoration: InputDecoration(
                      hintText: 'confirm password',
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NeoPopTiltedButton(
                    color: const Color.fromRGBO(255, 235, 52, 1),
                    onTapUp: performRegister,
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
