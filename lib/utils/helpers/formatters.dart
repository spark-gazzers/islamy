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

/// Formatter for audio length and position.
///
/// The reason behind the class is to have identic format properties
/// for both the position and the length.
class FormattedLengthDuration {
  const FormattedLengthDuration._(this.duration, this.total);
  static final intl.NumberFormat format = intl.NumberFormat('00');

  /// The current position of theplayer in the audio.
  final Duration duration;

  /// The total length of the audio file.
  final Duration total;

  /// The [duration] formatted text.
  String get start => _format(duration);

  /// The [total] formatted text.
  String get end => _format(total);
  bool get _shouldIncludHour => total >= const Duration(hours: 1);
  String _format(Duration duration) {
    String ret = '';
    // start with minutes
    ret += '${format.format(duration.inMinutes % 60)}:';
    // seconds
    ret += format.format(duration.inSeconds % 60);
    // include hours if needed
    if (_shouldIncludHour) {
      ret = '${format.format(duration.inHours)}:$ret';
    }
    return ret;
  }
}
