import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/all_Contacts_card_widget.dart';
import '../../../core/widgets/no_search_result.dart';
import '../../updateContact/bloc/update_contact_state.dart';

class BuildAllContactsList extends StatelessWidget {
  const BuildAllContactsList({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onUpdate,
    required this.onDelete,
  });

  final GetUsersContactsFromDataBase state;
  final ScrollController scrollController;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: state.contactsList!.isNotEmpty
          ? ListView.separated(
              controller: scrollController,
              itemBuilder: (context, index) => AllContactCardWidget(
                phoneNumber: state.contactsList![index].phone,
                onRadioButtonChecked: false,
                onChangeValue: (p0) {},
                onClicked: () async {
                  _makePhoneCall(state.contactsList![index].phone);
                },
                personName: state.contactsList![index].name,
                onDelete: onDelete,
                onEdit: onUpdate,
              ),
              itemCount: state.contactsList!.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: checkBoxBorderColor,
              ),
            )
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
