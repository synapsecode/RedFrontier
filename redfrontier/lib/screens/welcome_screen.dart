import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:redfrontier/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RED FRONTIER',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          const Spacer(),
          SizedBox(
              height: 330, child: Image.asset('assets/images/welcomepng.png')),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Welcome to Mars!',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const Spacer(),
          NeoPopTiltedButton(
            isFloating: true,
            onTapUp: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            decoration: const NeoPopTiltedButtonDecoration(
              color: Color.fromRGBO(255, 235, 52, 1),
              plunkColor: Color.fromRGBO(255, 235, 52, 1),
              shadowColor: Color.fromRGBO(36, 36, 36, 1),
              showShimmer: true,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 70.0,
                vertical: 15,
              ),
              child: Text(
                'Login ->',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer()
        ]),
      ),
    );
  }
}
