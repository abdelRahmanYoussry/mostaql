import 'package:flutter/material.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    this.focusNode,
    this.confirm,
    this.onValidated,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? confirm;
  final ValueChanged<bool>? onValidated;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textDirection: TextDirection.ltr,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onFieldSubmitted: confirm,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      textInputAction: confirm == null ? TextInputAction.next : TextInputAction.done,
      autofillHints: const [
        AutofillHints.email,
      ],
      validator: (value) {
        final result = validate(value);
        onValidated?.call(result == null);
        return result;
      },
      decoration: InputDecoration(
        labelText: Loc.email(),
      ),
    );
  }

  String? validate(String? value) {
    if (!validString(
      value,
    )) {
      return '';
    }
    if (value != null &&
        !validEmail(
          value,
        )) {
      // return Loc.invalid_email();
      return '';
    }
    return null;
  }
}
