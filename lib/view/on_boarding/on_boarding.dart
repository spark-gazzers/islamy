import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';

/// The first timer welcoming scrreen that explains the essence of the app.
class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 109),
                const Image(
                  height: 252.96,
                  image: AssetImage('assets/images/on_boarding.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    S.of(context).manage_your_daily_islamic_habits,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 69.5),
                  child: Text(
                    S
                        .of(context)
                        // ignore: lines_longer_than_80_chars
                        .islamy_lets_you_manage_your_daily_islamic_habits_with_ease,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'sign_in_with_server',
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: Text(
                        S.of(context).sign_in_with_ +
                            S.of(context).phone_number,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'sign_in_with_google',
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.white,
                      ),
                      onPressed: () {},
                      icon: const Image(
                        image: AssetImage('assets/images/google.png'),
                        width: 21,
                      ),
                      label: Text(
                        S.of(context).sign_in_with_ + S.of(context).google,
                        style: const TextStyle(
                          color: Color(0xff4B4B4B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
