import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    required this.phone,
    super.key,
  });

  final String phone;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with FormControls<OTPScreen> {
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
                  S.of(context).enter_the_code_sent_to_you,
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
                  '${S.of(context).phone_number} : ${widget.phone}',
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Pinput(
                        controller: controllers['otp'],
                        autofocus: true,
                        validator: otpValidator,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        onCompleted: (String str) => _checkOtp(),
                      ),
                      const SizedBox(height: 48.28),
                      Hero(
                        transitionOnUserGestures: true,
                        tag: 'sign_in_with_server',
                        child: ElevatedButton(
                          onPressed: _checkOtp,
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

  void _checkOtp() {
    if (formKey.currentState!.validate()) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'reset_password',
        (Route<dynamic> route) => false,
        arguments: <String, dynamic>{
          'phone': widget.phone,
        },
      );
    }
  }
}
