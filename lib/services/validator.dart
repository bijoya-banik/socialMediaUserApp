abstract class Validators {
  static String? emailValidator(String email) {
    email = email.trim();
    Pattern pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern.toString());
    if (email.isEmpty) {
      return "Email is required";
    } else if (!regExp.hasMatch(email)) {
      return "Invalid Email";
    }

    return null;
  }

  static String? newPasswordValidator(String password) {
    password = password.trim();
    if (password.isEmpty) return "Password is required";
    // if (password.length < 6)
    // toast("Password length should be at least 6 character long");
    return null;
  }

  static String? loginPasswordValidator(String password) {
    if (password.isEmpty) return "Mustn't be empty";
    if (password.length < 6) return "Password is too short";
    return null;
  }

  static String? fieldValidator(String value) {
    if (value.isEmpty) return "Mustn't be empty";
     

    return null;
  }

  static String? dropdownFieldValidator(String value, String defaultValue) {
    if (value.isEmpty || value == defaultValue) return "Mustn't be empty";

    return null;
  }
}
