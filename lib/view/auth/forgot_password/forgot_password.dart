import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
    required this.phone,
  }) : super(key: key);

  final String? phone;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with FormControls<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    controllers[S.current.phone_number]!.text = widget.phone ?? '';
  }

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
            children: <Widget>[
              const SizedBox(height: 109),
              const Image(
                width: 96.46,
                image: AssetImage('assets/images/logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  S.of(context).enter_your_phone_number,
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
                  horizontal: 46,
                ),
                child: Text(
                  S
                      .of(context)
                      // ignore: lines_longer_than_80_chars
                      .we_will_send_you_a_verification_code_to_reset_your_password,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6E6E6E),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFormField(
                        controller: controllers[S.of(context).phone_number],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: phoneValidator,
                        autocorrect: true,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone_outlined),
                          labelText: S.of(context).phone_number,
                        ),
                      ),
                      const SizedBox(height: 48.28),
                      Hero(
                        transitionOnUserGestures: true,
                        tag: 'sign_in_with_server',
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'otp',
                              arguments: <String, dynamic>{
                                'phone':
                                    controllers[S.of(context).phone_number]!
                                        .text,
                              },
                            );
                          },
                          child: Text(S.of(context).send_otp),
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
