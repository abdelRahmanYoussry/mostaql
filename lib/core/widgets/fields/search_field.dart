import 'package:flutter/material.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../utils/get_asset_path.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.confirm,
    this.onChange,
    this.label,
    this.fillColor,
    this.onFilter,
    this.onTap,
    this.filter = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.onControllerClear,
    this.prefixIcon,
    this.onTextIsClear,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? confirm;
  final ValueChanged<String>? onChange;
  final VoidCallback? onControllerClear;
  final VoidCallback? onFilter;
  final VoidCallback? onTap;
  final VoidCallback? onTextIsClear;
  final String? label;
  final bool filter;
  final Color? fillColor;
  final bool? readOnly;
  final bool? autoFocus;
  final Widget? prefixIcon;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final ValueNotifier<bool> searchSuffixIcon = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(changeSearchIcon);
  }

  @override
  void dispose() {
    widget.controller.removeListener(changeSearchIcon);
    super.dispose();
  }

  changeSearchIcon() {
    if (widget.controller.text.isNotEmpty) {
      searchSuffixIcon.value = true;
    } else {
      searchSuffixIcon.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0.h,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: widget.autoFocus!,
              onTap: widget.onTap,
              readOnly: widget.readOnly!,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onFieldSubmitted: widget.confirm,
              onChanged: widget.onChange,
              textInputAction: widget.confirm == null ? TextInputAction.next : TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                border: InputBorder.none,
                fillColor: widget.fillColor ?? lightGrey,
                filled: true,
                suffixIcon: ValueListenableBuilder(
                  valueListenable: searchSuffixIcon,
                  builder: (context, value, child) => GestureDetector(
                      onTap: widget.onControllerClear,
                      child: Icon(
                        !searchSuffixIcon.value ? Icons.search_rounded : Icons.clear,
                        color: grey80,
                      )),
                ),
                prefixIcon: widget.prefixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  borderSide: const BorderSide(
                    color: lightGrey,
                  ),
                ),
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: lightGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: lightGrey,
                  ),
                ),
                hintText: widget.label ?? Loc.searchHintText(),
                hintStyle: TextStyle(color: greyMedium, fontSize: 12.sp),
              ),
            ),
          ),
          if (widget.filter)
            IconButton.filled(
              onPressed: () {
                widget.onFilter?.call();
              },
              // style: IconButton.styleFrom(),
              icon: Picture(
                getAssetIcon('filter_icon.svg'),
                height: 15.h,
              ),
            ),
        ],
      ),
    );
  }
}
