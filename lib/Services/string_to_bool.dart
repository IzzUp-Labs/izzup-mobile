extension StringBoolean on String {
  bool? toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0")
            ? false
            : null;
  }
}
