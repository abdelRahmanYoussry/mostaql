import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/contract_model.dart';
import '../../models/recently_profile_photos_model.dart';
import '../../pages/aboutApp/about_app_page.dart';
import '../../pages/aboutPrivace/about_privacy_page.dart';
import '../../pages/addPerson/add_person_page.dart';
import '../../pages/bottomNavLayout/bottom_nav_layout.dart';
import '../../pages/chat/pages/chat_page.dart';
import '../../pages/home/bloc/home_bloc.dart';
import '../../pages/home/widgets/upload_contract_widget.dart';
import '../../pages/imageSelection/image_selection_page.dart';
import '../../pages/onboard/onboard_page.dart';
import '../../pages/settings/cubit/maarfy_settings_cubit/maarfy_settings_cubit.dart';
import '../../pages/settings/pages/update_contacts/update_all_contacts_page.dart';
import '../../pages/settings/pages/update_contacts/update_one_contact_page.dart';
import '../../pages/settings/widgets/rate_app_unavailable_widget.dart';
import '../../pages/settings/widgets/rate_app_widget.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/updateContact/bloc/update_contact_bloc.dart';
import '../../pages/updateContact/update_uncompelete_contact_page.dart';
import '../../pages/updateContact/widget/update_uncomplete_contacts_bottom_sheet.dart';
import '../../parameters/filter_paramaters.dart';
import '../di/di.dart';
import '../utils/widget_utils.dart';
import '../widgets/delete_bottom_sheet.dart';
import '../widgets/image_cropper.dart';
import '../widgets/share_my_contacts_dailog_widget.dart';
import 'pages_keys.dart';

///don't use Navigator.of(context)
///must use this
abstract class Nav {
  static final mainNavKey = GlobalKey<NavigatorState>();

  static onBoard(BuildContext context) async => await _replaceAll(
        context,
        PageKey.onBoard,
        const OnboardScreen(),
      );

  static mainLayoutScreens(BuildContext context) async => await _replaceAll(
        context,
        PageKey.bottomNav,
        BottomNavPage(),
      );

  static splashScreens(BuildContext context) async => await _replaceAll(
        context,
        PageKey.splash,
        const SplashPage(),
      );

  static aboutAppScreen(
    BuildContext context,
  ) async =>
      await _push(
        context,
        PageKey.aboutApp,
        const AboutAppPage(),
      );

  static addPersonScreen({required BuildContext context, bool? isNameTextFormIsFocused}) async => await _push(
        context,
        PageKey.addPersonPage,
        AddPersonPage(),
      );

  static chatScreen({required BuildContext context, bool? isTextFormFocused}) async => await _push(
        context,
        PageKey.chatPage,
        ChatPage(),
      );

  static updateUnCompleteContactScreen(BuildContext context) async => await _push(
        context,
        PageKey.updateContactPage,
        const UpdateUnCompleteContactPage(),
      );

  static updateContactScreen(BuildContext context, ContactData contactData) async => await _push(
        context,
        PageKey.updateContactPage,
        UpdateContactPage(
          contactData: contactData,
        ),
      );

  static aboutPrivacyScreen(BuildContext context) async => await _push(
        context,
        PageKey.aboutPrivacy,
        AboutPrivacyPage(),
      );

  static shareMyContactsDialog(BuildContext context, MaarfySettingsCubit cubit, String phone) async =>
      await _pushDialog(
          key: PageKey.shareMyContactsDialog,
          context: context,
          page: ShareMyContactsWidget(
            cubit: cubit,
            phoneNumber: phone,
          ),
          barrierDismissible: true);

  static rateAppDialog(BuildContext context) async =>
      await _pushDialog(key: PageKey.rateAppState, context: context, page: RateAppWidget(), barrierDismissible: true);

  static rateUnavailableAppDialog(BuildContext context) async => await _pushDialog(
      key: PageKey.rateAppState, context: context, page: const RateAppUnAvailable(), barrierDismissible: true);

  static uploadContactsDialog(BuildContext context) async => await _pushDialog(
        key: PageKey.uploadContactsDialog,
        context: context,
        page: BlocProvider<HomeBloc>(
          create: (context) => di<HomeBloc>()..getAllUserContacts(),
          child: const UploadContactDialog(),
        ),
        barrierDismissible: false,
      );

  static updateAllContactsPage(BuildContext context) async => await _push(
        context,
        PageKey.updateAllContactsPage,
        BlocProvider<UpdateContactBloc>(
          create: (context) => di<UpdateContactBloc>()
            ..getAllUserContactsFromBe(
              isPagination: false,
              filterParameters: FilterParameters(),
            ),
          child: const UpdateAllContactsPage(),
        ),
      );

  static imageSelectionScreen({
    required BuildContext context,
    required ValueChanged<RecentlyPhotoData>? onImageClicked,
    required VoidCallback onPickUpImage,
  }) async =>
      await _pushBottomSheet(
          context: context,
          key: PageKey.imageSelectionPage,
          page: ImageSelectionPage(
            onImageClicked: (value) {
              onImageClicked!.call(value);
            },
            onPickUpImageFromPhone: () {
              onPickUpImage.call();
            },
          ),
          barrierDismissible: true);

  static updateContactsWarning(BuildContext context) async => await _pushBottomSheet(
      key: PageKey.updateContactBottomSheet,
      context: context,
      page: const UpdateContactsSheet(),
      barrierDismissible: false);

  static filterBottomSheet(BuildContext context, Widget bottomSheetBody) async => await _pushDraggableBottomSheet(
        key: PageKey.bottomSheetFilter,
        context: context,
        page: bottomSheetBody,
        barrierDismissible: true,
      );

  static deleteBottomSheet({required BuildContext context, required VoidCallback onDelete}) async =>
      await _pushBottomSheet(
          key: PageKey.deleteBottomSheet,
          context: context,
          page: DeleteBottomSheet(
            onYesClicked: onDelete,
          ),
          barrierDismissible: true);

  static placeOfWorkBottomSheet(BuildContext context, Widget bottomSheetBody) async => await _pushBottomSheet(
      key: PageKey.placeOfWorkBottomSheet, context: context, page: bottomSheetBody, barrierDismissible: true);

  static placeOfBirthBottomSheet(BuildContext context, Widget bottomSheetBody) async => await _pushBottomSheet(
      key: PageKey.placeOfBirthBottomSheet, context: context, page: bottomSheetBody, barrierDismissible: true);

  static Future<Uint8List?> crop(BuildContext context, Uint8List image) async => await _push(
        context,
        PageKey.crop,
        ImageCropper(image: image),
      );

  static Future<T?> _pushDialog<T>({
    required BuildContext context,
    required PageKey key,
    required Widget page,
    bool barrierDismissible = false,
  }) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.white12,
      routeSettings: RouteSettings(name: key.name),
      builder: (context) => page,
    );
  }

  static Future<T?> _pushBottomSheet<T>({
    required BuildContext context,
    required PageKey key,
    required Widget page,
    double? radius,
    BoxConstraints? constraints,
    bool barrierDismissible = false,
  }) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return showModalBottomSheet<T?>(
      isDismissible: barrierDismissible,
      isScrollControlled: true,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      constraints: constraints,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            radius ?? getBorderRadius(),
          ),
        ),
      ),
      context: context,
      builder: (context) => Container(color: Colors.white, child: page),
    );
  }

  static Future<T?> _pushDraggableBottomSheet<T>({
    required BuildContext context,
    required PageKey key,
    required Widget page,
    double? radius,
    BoxConstraints? constraints,
    bool barrierDismissible = false,
  }) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return showModalBottomSheet<T?>(
      isDismissible: barrierDismissible,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      enableDrag: true,
      context: context,
      builder: (context) => page,
    );
  }

  static Future<T?> _push<T>(BuildContext context, PageKey key, Widget page) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return await Navigator.of(context).push<T>(
      MaterialPageRoute(
        settings: RouteSettings(name: key.name),
        builder: (context) => page,
      ),
    );
  }

  static Future<T?> _replace<T, TO>(BuildContext context, PageKey key, Widget page) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return await Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(
        settings: RouteSettings(name: key.name),
        builder: (context) => page,
      ),
    );
  }

  static Future<T?> _replaceAll<T>(
    BuildContext context,
    PageKey key,
    Widget page,
  ) async {
    await _closeDrawer(context);
    if (!context.mounted) return null;
    return await Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(
        settings: RouteSettings(
          name: key.name,
        ),
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  static Future<void> _closeDrawer(BuildContext context) async {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState?.isDrawerOpen == true) {
      scaffoldState?.closeDrawer();
      await Future.delayed(Durations.medium1);
    }
  }
}
