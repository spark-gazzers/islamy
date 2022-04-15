import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';

class SignupScreen extends StatefulWidget {
  final String? phone;
  final String? password;
  const SignupScreen({
    Key? key,
    required this.phone,
    required this.password,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with FormControls {
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
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 109),
                    const Image(
                      width: 96.46,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        S.of(context).create_a_new_account,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: controllers[S.of(context).full_name],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: nameValidator,
                              autocorrect: true,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.person_outline_outlined),
                                labelText: S.of(context).full_name,
                              ),
                            ),
                            const SizedBox(height: 24.0),
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
                            const SizedBox(height: 24.0),
                            ValueListenableBuilder<bool>(
                                valueListenable: _passwordVisible,
                                builder: (context, visible, _) {
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
                                        icon: Icon(visible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          _passwordVisible.value = !visible;
                                        },
                                      ),
                                      labelText: S.of(context).password,
                                    ),
                                  );
                                }),
                            const SizedBox(height: 48.28),
                            Hero(
                              transitionOnUserGestures: true,
                              tag: 'sign_in_with_server',
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                },
                                child: Text(
                                  S.of(context).sign_up_with_ +
                                      S.of(context).phone_number,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.5),
                              child: Text(
                                S.of(context).or_continue_with,
                                style: const TextStyle(
                                  color: Color(0xff89909A),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Hero(
                              transitionOnUserGestures: true,
                              tag: 'sign_in_with_google',
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Colors.white,
                                ),
                                onPressed: () {},
                                icon: const Image(
                                  image: AssetImage('assets/images/google.png'),
                                  width: 21.0,
                                ),
                                label: Text(
                                  S.of(context).sign_up_with_ +
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
                  'login',
                  arguments: {
                    'phone': controllers[S.of(context).phone_number]!.text,
                    'password': controllers[S.of(context).password]!.text,
                  },
                );
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).already_have_account,
                    ),
                    TextSpan(
                      text: S.of(context).sign_in,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                style: const TextStyle(
                  color: Color(0xff89909A),
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
