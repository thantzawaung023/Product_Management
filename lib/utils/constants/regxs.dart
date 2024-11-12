class Regxs {
  static String emailRegx =
      r'^[a-z0-9]+([._%+-]?[a-z0-9]+)*@[a-z0-9-]+(\.[a-z]{2,})+$';
  static String passwordRegx =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Address name regex: allows letters, spaces, commas, hyphens, and periods
  static String addressNameRegx = r"^[a-zA-Z0-9\s,.'\-]{3,100}$";

  // Latitude and Longitude regex: validates decimal format and range
  static String latitudeRegx =
      r'^-?([1-8]?[0-9](\.\d+)?|90(\.0+)?)$'; // Latitude range: -90 to 90
  static String longitudeRegx =
      r'^-?((1[0-7][0-9]|[1-9]?[0-9])(\.\d+)?|180(\.0+)?)$'; // Longitude range: -180 to 180

  // Validate email format
  static bool validateEmail(String email) {
    return RegExp(emailRegx).hasMatch(email);
  }

  // Validate password format
  static bool validatePassword(String password) {
    return RegExp(passwordRegx).hasMatch(password);
  }

  // Validate address name format
  static bool validateAddressName(String addressName) {
    return RegExp(addressNameRegx).hasMatch(addressName);
  }

  // Validate address location format
  static bool validateAddressLocation(String addressLocation) {
    final location = addressLocation.split(',');
    if (location.length != 2) {
      return false; // Ensure there are two parts (lat, lng)
    }
    final latitude = location[0].trim();
    final longitude = location[1].trim();

    bool isValidLatitude = validateLatitude(latitude);
    bool isValidLongitude = validateLongitude(longitude);

    return isValidLatitude && isValidLongitude;
  }

  // Validate latitude format
  static bool validateLatitude(String latitude) {
    return RegExp(latitudeRegx).hasMatch(latitude);
  }

  // Validate longitude format
  static bool validateLongitude(String longitude) {
    return RegExp(longitudeRegx).hasMatch(longitude);
  }
}
