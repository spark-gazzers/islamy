import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Future<void>.delayed(const Duration(seconds: 2)).then(
      (_) => Navigator.pushReplacementNamed(context, 'on_boarding'),
    );
    return const Material(
      elevation: 0,
      child: Center(
        child: Hero(
          transitionOnUserGestures: true,
          tag: 'logo_hero_tag',
          child: Image(
            height: 150,
            image: AssetImage('assets/images/logo_with_text.png'),
          ),
        ),
      ),
    );
  }
}
