import 'package:flutter/material.dart';
import 'package:size_config/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/widgets/no_search_result.dart';
import '../../../core/widgets/search_Contact_card_widget.dart';
import '../bloc/home_state.dart';

class BuildSearchContactsList extends StatelessWidget {
  const BuildSearchContactsList({super.key, required this.state, required this.scrollController});
  final SearchInDataBaseContactsState state;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: state.contactsList!.isNotEmpty
          ? ListView.separated(
              controller: scrollController,
              itemBuilder: (context, index) => SearchPersonCardWidget(
                    phoneNumber: state.contactsList![index].phone,
                    onClicked: () async {
                      _makePhoneCall(state.contactsList![index].phone);
                    },
                    personName: state.contactsList![index].name,
                    onMarffyClick: () async {
                      _makePhoneCall(state.contactsList![index].user!.phone!);
                    },
                    job: state.contactsList![index].job!,
                    imageUrl: state.contactsList![index].user!.avatar!,
                    placeOfBirth: state.contactsList![index].placeOfBirth?.name,
                    placeOfWork: state.contactsList![index].placeOfWork?.title,
                    user: state.contactsList![index].user!.firstName!,
                  ),
              itemCount: state.contactsList!.length,
              separatorBuilder: (context, index) => Container(
                    height: 5.h,
                    color: Colors.grey.shade300,
                  ))
          : const NoSearchResultWidget(),
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
