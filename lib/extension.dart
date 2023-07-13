import 'package:phone_form_field/phone_form_field.dart';

extension XPhoneNumber on PhoneNumber {
  String get helperText {
    var text = 'Area code + 7 digit #';

    if (isoCode == IsoCode.MX) {
      text = 'Area code + 8 digit # (2 digit area code)';
    }

    return text;
  }
}
