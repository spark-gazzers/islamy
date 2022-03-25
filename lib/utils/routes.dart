import 'package:flutter/cupertino.dart';
import 'package:islamy/view/auth/enable_location/enable_location.dart';
import 'package:islamy/view/auth/forgot_password/forgot_password.dart';
import 'package:islamy/view/auth/forgot_password/otp.dart';
import 'package:islamy/view/auth/forgot_password/reset_password.dart';
import 'package:islamy/view/auth/login/login.dart';
import 'package:islamy/view/auth/signup/signup.dart';
import 'package:islamy/view/on_boarding/on_boarding.dart';
import 'package:islamy/view/splash/splash.dart';

class Routes {
  const Routes._();
  static Route onGenerateRoute(RouteSettings settings) {
    WidgetBuilder? builder;
    Map<String, dynamic> args = <String, dynamic>{};
    try {
      args.addAll(
          settings.arguments as Map<String, dynamic>? ?? <String, dynamic>{});
    } finally {}
    switch (settings.name) {
      case 'login':
        builder = (context) => LoginScreen(
              password: args['password'],
              phone: args['phone'],
            );
        break;
      case 'signup':
        builder = (context) => SignupScreen(
              password: args['password'],
              phone: args['phone'],
            );
        break;

      case 'forgot_password':
        builder = (context) => ForgotPasswordScreen(
              phone: args['phone'],
            );
        break;

      case 'reset_password':
        builder = (context) => ResetPasswordScreen(
              phone: args['phone'],
            );
        break;

      case 'otp':
        builder = (context) => OTPScreen(
              phone: args['phone'],
            );
        break;
      default:
    }
    return _buildRoute(settings, builder);
  }

  static Route _buildRoute(RouteSettings settings, [WidgetBuilder? builder]) =>
      CupertinoPageRoute(
        builder: builder ?? _routes[settings.name]!,
        settings: settings,
      );
  // static Route
  static Map<String, WidgetBuilder> get _routes => <String, WidgetBuilder>{
        'splash': (_) => const SplashScreen(),
        'on_boarding': (_) => const OnBoarding(),
        "enable_location": (_) => const EnableLocation(),
      };
}
