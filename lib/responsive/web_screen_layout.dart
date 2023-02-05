import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../Screens/login_screen.dart';
import '../resources/auth_methods.dart';
import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('This is web.'),
            GestureDetector(
              onTap: () async {
                await AuthMethods().signout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Container(
                child: const Text(
                  "Sign out",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: blueColor),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
