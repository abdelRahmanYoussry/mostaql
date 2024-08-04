import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:size_config/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/colors.dart';
import '../../../models/chat_ai_model.dart';

class ChatBubble extends StatelessWidget {
  final String? text;
  final bool isSender;
  final List<AiContact>? contactsList;

  const ChatBubble({super.key, this.text, required this.isSender, this.contactsList});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isSender)
            ClipOval(
              child: Picture(
                height: 30.h,
                width: 30.w,
                di<AuthRepo>().user?.avatar_url ?? getAssetIcon('person-tie.svg'),
              ),
            ),
          Gap(
            10.w,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 1.3,
              minHeight: MediaQuery.of(context).size.height / 10,
            ),
            decoration: BoxDecoration(
              color: isSender ? senderYellowColor : receiverBlueColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomLeft: isSender ? const Radius.circular(22.0) : Radius.zero,
                bottomRight: isSender ? Radius.zero : const Radius.circular(22.0),
              ),
            ),
            child: isSender
                ? Text(
                    text ?? Loc.messageIsEmpty(),
                    style: getRegularGray16Style(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: contactsList!
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name,
                                  style: getRegularGray16Style(),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '${Loc.phoneNumber()} : ',
                                    style: getRegularGray16Style(),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: e.phone,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _makePhoneCall(e.phone);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          if (!isSender)
            Padding(
              padding: EdgeInsets.only(
                right: 5.w,
              ),
              child: ClipOval(
                child: Picture(
                  height: 30.h,
                  width: 30.w,
                  getAssetImage('chatbot.png'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw '${Loc.errorIn()} $launchUri';
    }
  }
}
