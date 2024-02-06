class AccountDataValidator {
  static bool validatePassword(String password) {
    bool isValidPassword =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$()&*])(?=.*[0-9])(?=.*[a-z]).{8}$')
            .hasMatch(password);

    return isValidPassword;
  }

  static bool validateEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool validateCarRegistration(String registration) {
    final RegExp registrationRegex = RegExp(
      r'^[A-Z]{2,3}\s?\d{5}$',
    );
    return registrationRegex.hasMatch(registration);
  }
}
