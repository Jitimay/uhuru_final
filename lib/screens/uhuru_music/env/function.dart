class GlobalFunction {
  static String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours) == '00' ? '' : twoDigits(d.inHours)}${twoDigits(d.inHours) == '00' ? "" : ':'}$twoDigitMinutes:$twoDigitSeconds";
  }
}
