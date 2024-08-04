import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/utils/media_query_values.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:size_config/size_config.dart';

import '../../localization/loc_keys.dart';
import '../../theme/consts.dart';
import '../../utils/get_asset_path.dart';
import '../picture.dart';

class PhoneField extends StatelessWidget {
  PhoneField({
    super.key,
    required this.controller,
    this.showHint = false,
    this.autoFocus = false,
    this.isAddPersonPage = false,
    this.focusNode,
    this.confirm,
    this.onValidated,
    this.getChosenPhoneCode,
    this.addPenIcon,
    this.onChange,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? confirm;
  final ValueChanged<String>? getChosenPhoneCode;
  final ValueChanged<bool>? onValidated;
  final ValueChanged<String>? onChange;

  final bool showHint;
  final bool autoFocus;
  final bool isAddPersonPage;
  final bool? addPenIcon;

  //get initial country by getInitialCountry
  // get chosen phone code variable

  final ValueNotifier<Country> _country = ValueNotifier(getInitialCountry);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textDirection: TextDirection.ltr,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onFieldSubmitted: confirm,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.phone,
      autofocus: autoFocus,
      onChanged: onChange,
      textInputAction: confirm == null ? TextInputAction.next : TextInputAction.done,
      autofillHints: const [
        AutofillHints.telephoneNumber,
        AutofillHints.telephoneNumberLocal,
        AutofillHints.telephoneNumberNational,
        AutofillHints.telephoneNumberDevice,
      ],
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        final result = validate(value);
        onValidated?.call(result == null);
        return result;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,

        suffixIcon: Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: ValueListenableBuilder<Country>(
            valueListenable: _country,
            builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    onSelect: (d) {
                      _country.value = d;
                      getChosenPhoneCode!(
                        d.phoneCode,
                      );
                    },
                    useSafeArea: true,
                    // showPhoneCode: true,
                    countryListTheme: CountryListThemeData(
                      inputDecoration: InputDecoration(
                        label: Row(
                          children: [
                            const Icon(Icons.search),
                            const Expanded(child: SizedBox()),
                            Text(Loc.searchInCountries()),
                          ],
                        ),
                        // icon: Icon(Icons.search),
                      ),
                      bottomSheetHeight: context.height - 100.h,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(
                          20,
                        ),
                        topLeft: Radius.circular(
                          20,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: showHint
                        ? Colors.transparent
                        : const Color.fromRGBO(
                            246,
                            246,
                            246,
                            1.0,
                          ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _country.value.phoneCode,
                        style: getRegularBlack14Style(),
                      ),
                      Gap(
                        5.w,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        // backgroundImage: MemoryImage(_country.value.flagEmoji),
                        radius: 15,
                        child: Text(_country.value.flagEmoji),
                      ),
                      if (addPenIcon != null && addPenIcon == true)
                        Gap(
                          5.w,
                        ),
                      if (addPenIcon != null && addPenIcon == true)
                        SizedBox(
                          // width and height make no effect, to be fixed
                          width: 15.w,
                          height: 15.h,
                          child: Picture(
                            getAssetIcon('pen.svg'),
                            // width: 10,
                            // height: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        label: showHint ? Text(Loc.phoneNumber()) : null,
        labelStyle: getRegularGrey14Style(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        // labelText: Loc.phone(),
      ),
    );
  }

  String? validate(String? value) {
    if (!validString(value)) {
      return Loc.emptyPhoneNumber();
    } else if (!isPhoneNumberValid(value, _country.value.phoneCode)) {
      if (_country.value.phoneCode == '20') {
        return Loc.egyptUnvaildPhoneNumber();
      } else {
        return Loc.generalUnvaildPhoneNumber();
      }
    }
    return null;
  }
}
