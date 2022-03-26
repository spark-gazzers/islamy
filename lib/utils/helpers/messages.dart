part of helper;

class _MessagesHelper {
  const _MessagesHelper._();
  static const _MessagesHelper instance = _MessagesHelper._();

  void showSuccess(BuildContext context, String message) => Flushbar(
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
