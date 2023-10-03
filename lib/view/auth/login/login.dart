import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.phone,
    required this.password,
    super.key,
  });

  final String? phone;
  final String? password;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with FormControls<LoginScreen> {
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    controllers[S.current.password]!.text = widget.password ?? '';
    controllers[S.current.phone_number]!.text = widget.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 109),
                    const Image(
                      width: 96.46,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        S.of(context).log_in_to_your_account,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TextFormField(
                              controller:
                                  controllers[S.of(context).phone_number],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: phoneValidator,
                              autocorrect: true,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone_outlined),
                                labelText: S.of(context).phone_number,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ValueListenableBuilder<bool>(
                              valueListenable: _passwordVisible,
                              builder: (BuildContext context, bool visible, _) {
                                return TextFormField(
                                  controller:
                                      controllers[S.of(context).password],
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: passwordValidator,
                                  obscureText: visible,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Iconsax.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        visible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        _passwordVisible.value = !visible;
                                      },
                                    ),
                                    labelText: S.of(context).password,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'forgot_password',
                                  arguments: <String, dynamic>{
                                    'phone':
                                        controllers[S.of(context).phone_number]!
                                            .text,
                                  },
                                );
                              },
                              child: Text(
                                S.of(context).forgot_password,
                                style: const TextStyle(
                                  color: Color(0xff89909A),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 48.28),
                            Hero(
                              transitionOnUserGestures: true,
                              tag: 'sign_in_with_server',
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    'enable_location',
                                  );
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
                                  S.of(context).sign_in_with_ +
                                      S.of(context).google,
                                  style: const TextStyle(
                                    color: Color(0xff4B4B4B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  'signup',
                  arguments: <String, dynamic>{
                    'phone': controllers[S.of(context).phone_number]!.text,
                    'password': controllers[S.of(context).password]!.text,
                  },
                );
              },
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: S.of(context).dont_have_an_account,
                    ),
                    TextSpan(
                      text: S.of(context).sign_up,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                style: const TextStyle(
                  color: Color(0xff89909A),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
