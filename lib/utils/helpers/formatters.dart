part of helper;

class _Formatters {
  const _Formatters._();
  static const _Formatters instance = _Formatters._();

  Future<void> init() async {}

  FormattedLengthDuration formatLengthDuration(
    Duration current,
    Duration total,
  ) {
    return FormattedLengthDuration._(current, total);
  }
}

class FormattedLengthDuration {
  const FormattedLengthDuration._(this.duration, this.total);

  final Duration duration;
  final Duration total;
  String get start => _format(duration);
  String get end => _format(total);
  bool get _shouldIncludHour => total >= const Duration(hours: 1);
  String _format(Duration duration) {
    String ret = '';
    // start with minutes
    ret += '${duration.inMinutes % 60}:';
    // seconds
    ret += (duration.inSeconds % 60).toString();
    // include hours if needed
    if (_shouldIncludHour) {
      ret = '${duration.inHours}:$ret';
    }
    return ret;
  }
}
