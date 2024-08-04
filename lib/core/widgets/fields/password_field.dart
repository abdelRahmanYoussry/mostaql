import 'package:flutter/material.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.confirm,
    this.onValidated,
    this.label,
    this.confirmedPassword,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? confirm;
  final ValueChanged<bool>? onValidated;
  final String? label;
  final String? confirmedPassword;

  @override
  Widget build(BuildContext context) {
    bool obscurePass = true;
    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        textDirection: TextDirection.ltr,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onFieldSubmitted: confirm,
        obscureText: obscurePass,
        textAlign: TextAlign.center,
        textInputAction: confirm == null ? TextInputAction.next : TextInputAction.done,
        autofillHints: const [
          AutofillHints.password,
          AutofillHints.newPassword,
        ],
        validator: (value) {
          final result = validate(value);
          onValidated?.call(result == null);
          return result;
        },
        decoration: InputDecoration(
          labelText: label ?? Loc.password(),
          errorMaxLines: 3,
          suffixIcon: ExcludeFocus(
            child: IconButton(
              onPressed: () => setState.call(() => obscurePass = !obscurePass),
              icon: Icon(
                obscurePass ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                color: greyA9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validate(String? value) {
    if (!validString(value)) {
      // return Loc.invalid_password();
      return '';
    }
    if (validString(confirmedPassword)) {
      if (value != confirmedPassword) {
        // return Loc.password_mismatch();
        return '';
      }
    } else {
      if (value != null && !validPassword(value)) {
        return Loc.password_weak();
      }
      if (value != null && !validatePassword(value)) {
        return Loc.password_must_contain();
      }
    }
    return null;
  }
}
