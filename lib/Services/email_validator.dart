class EmailValidator {
  static bool validate(String email) {
    // Regular expression pattern to match a valid email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
