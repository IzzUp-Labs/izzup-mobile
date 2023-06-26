class Extra {
  String email;
  String password;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  String address;

  Extra(this.email, this.password, this.dateOfBirth,
      {this.lastName = '', this.firstName = '', this.address = ''});

  static Extra basic = Extra('', '', DateTime.now());
}
