import 'package:flutter/material.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

class CustomElevatedButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final void Function()? onTap;
  final IconData? icon;
  final AssetImage? image;
  final Color? buttonColor;
  final String buttonName;
  final bool? condition;
  final bool? removeShadow;
  final TextStyle? buttonTextStyle;
  final BuildContext context;

  const CustomElevatedButton({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.icon,
    this.image,
    required this.onTap,
    required this.buttonName,
    this.buttonColor,
    required this.context,
    this.condition = true,
    this.removeShadow = false,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 60.h,
        child: condition == true
            ? ElevatedButton(
                style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor: MaterialStateProperty.all(
                    buttonColor ?? primary,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius ?? 30),
                    ),
                  ),
                ),
                onPressed: onTap,
                child: Text(
                  buttonName,
                  style: buttonTextStyle ?? getW700White16Style(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ))
            : const Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ));
  }
}
