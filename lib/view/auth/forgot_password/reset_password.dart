import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? phone;
  const ResetPasswordScreen({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with FormControls {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscurePasswordConfirmation =
      ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent),
      ),
      child: SafeArea(
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
                  S.of(context).reset_password,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 46.0,
                ),
                child: Text(
                  S.of(context).please_enter_a_new_password,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6E6E6E),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscurePassword,
                        builder: (context, visible, _) {
                          return TextFormField(
                            controller: controllers[S.of(context).password],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: passwordValidator,
                            keyboardType: TextInputType.text,
                            obscureText: visible,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: Icon(
                                visible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              labelText: S.of(context).password,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24.0),
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscurePasswordConfirmation,
                        builder: (context, visible, _) {
                          return TextFormField(
                            controller: controllers[
                                S.of(context).password_confirmation],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (str) => passwordConfirmationValidator(
                              str,
                              controllers[S.of(context).password]!.text,
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: visible,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: Icon(
                                visible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              labelText: S.of(context).password,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48.28),
                      Hero(
                        transitionOnUserGestures: true,
                        tag: 'sign_in_with_server',
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'landing');
                          },
                          child: Text(S.of(context).reset_password),
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
    );
  }
}
