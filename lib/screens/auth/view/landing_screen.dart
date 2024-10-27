import 'package:flutter/material.dart';
import 'package:uhuru/screens/auth/view/number_input_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../menu/screens/privacy_policy.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLogin(BuildContext context) {
    // Navigator.pushNamed(context, LoginScreen.routeName);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/U1.png"),
                  width: 100,
                ),
                Text(
                  'Uhuru',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Easiest way to connect with others',
                  // AppLocalizations.of(context)!.signinwithuhuru,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Column(
              children: [
                Text(
                  'Tap "Agree and continue" to accept the',
                  // AppLocalizations.of(context)!.signinwithuhuru,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy(),
                      ),
                    );
                  },
                  child: Text(
                    'Uhuru privacy & policy',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.cyan,
                          fontSize: 15,
                        ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // navigateToLogin(context),
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              backgroundColor: Colors.grey,
                              content: IntrinsicHeight(
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('It is important that you understand what information our app collects and uses'),
                                      SizedBox(height: 15),
                                      Text('1. Phone number'),
                                      Text('App uses phone number for account creation'),
                                      SizedBox(height: 10),
                                      Text('2. Contacts'),
                                      Text('App uses your contacts to find out \n which ones already have an account\n with us, enabling you to communicate \n more quickly and easily.'),
                                      SizedBox(height: 30),
                                      Text('By continuing you agree to our Privacy and Terms of service'),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(
                                                'Decline',
                                                style: TextStyle(color: const Color.fromARGB(255, 119, 210, 222)),
                                              )),
                                          TextButton(
                                            onPressed: () => navigateToLogin(context),
                                            child: Text(
                                              'Agree',
                                              style: TextStyle(color: const Color.fromARGB(255, 119, 210, 222)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.cyan),
                    )
                    // AppLocalizations.of(context)!.signIn)
                    )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
