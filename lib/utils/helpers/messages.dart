part of helper;

class _Messages {
  const _Messages._();
  static const _Messages instance = _Messages._();

  void showSuccess(BuildContext context, String message) => Flushbar<void>(
        message: message,
        icon: Icon(
          Icons.check_circle,
          color: Colors.green[300],
        ),
        leftBarIndicatorColor: Colors.green[300],
        duration: const Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
}
