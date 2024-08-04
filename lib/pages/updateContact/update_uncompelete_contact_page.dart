import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/widgets/elevated_button.dart';
import 'package:mostaql/core/widgets/snackBar.dart';
import 'package:mostaql/models/contract_model.dart';
import 'package:mostaql/pages/placeOfWork/place_of_work_bottom_sheet.dart';
import 'package:mostaql/parameters/contact_paramaters.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/navigation/nav.dart';
import '../../core/theme/consts.dart';
import '../../core/theme/styles_manager.dart';
import '../../core/widgets/fields/name_of_work_field.dart';
import '../../core/widgets/fields/person_note_field.dart';
import '../../core/widgets/fields/place_of_birth_field.dart';
import '../../core/widgets/fields/place_of_work_field.dart';
import '../../core/widgets/fields/words_communicate_with_field.dart';
import '../../core/widgets/gender_widet.dart';
import '../../core/widgets/update_contacts_card_widget.dart';
import '../../core/widgets/words_communicate_widget.dart';
import '../placeOfBirth/place_of_birth_bottom_sheet.dart';
import 'bloc/update_contact_bloc.dart';
import 'bloc/update_contact_state.dart';

class UpdateUnCompleteContactPage extends StatefulWidget {
  const UpdateUnCompleteContactPage({super.key});

  @override
  State<UpdateUnCompleteContactPage> createState() => _UpdateUnCompleteContactPageState();
}

class _UpdateUnCompleteContactPageState extends State<UpdateUnCompleteContactPage> {
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final placeOfBirthTextController = TextEditingController();
  final placeOfWorkTextController = TextEditingController();
  final jobTextController = TextEditingController();
  final noteTextController = TextEditingController();
  final tagsTextController = TextEditingController();
  final ValueNotifier<bool?> isMaleSelected = ValueNotifier(null);
  final ValueNotifier<bool> isLastIndex = ValueNotifier(false);
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  ContactParameters updatePersonParameters = ContactParameters();

  final _addPersonKey = GlobalKey<FormState>();
  final pageController = PageController();

  @override
  void dispose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    placeOfWorkTextController.dispose();
    placeOfBirthTextController.dispose();
    jobTextController.dispose();
    noteTextController.dispose();
    tagsTextController.dispose();
    isMaleSelected.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pageController.addListener(() {
      _currentIndex.value = pageController.page?.round() ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateContactBloc>(
      create: (context) => di<UpdateContactBloc>()..getUncompletedContacts(),
      lazy: false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<UpdateContactBloc, UpdateContactState>(
            listenWhen: (previous, current) => previous.updatePersonState != current.updatePersonState,
            listener: (context, state) {
              _handleNavAfterSuccess(state: state, contextN: context);
              if (state.updatePersonState.error != null) {
                SnackBarBuilder.showFeedBackMessage(
                  context,
                  state.updatePersonState.error.toString(),
                  isSuccess: false,
                );
              }
            },
          ),
          BlocListener<UpdateContactBloc, UpdateContactState>(
            listenWhen: (previous, current) => previous.deletePersonState != current.deletePersonState,
            listener: (context, state) {
              if (state.deletePersonState.success != null) {
                pageController.jumpToPage(_currentIndex.value);
              }
            },
          )
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 130.h,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: BlocSelector<UpdateContactBloc, UpdateContactState, GetUncompletedContractsState>(
                  selector: (state) => state.getUncompletedContractsState,
                  builder: (context, state) => ValueListenableBuilder(
                    valueListenable: _currentIndex,
                    builder: (context, value, child) {
                      return state.contactsDataList != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Nav.mainLayoutScreens(context);
                                      },
                                      child: const Icon(Icons.arrow_back_ios),
                                    ),
                                    Text("${_currentIndex.value + 1}/${state.contactsDataList!.length}"),
                                  ],
                                ),
                                Gap(15.h),
                                LinearProgressIndicator(
                                  value:
                                      (_currentIndex.value.toDouble() + 1) / state.contactsDataList!.length.toDouble(),
                                  backgroundColor: Colors.grey[300],
                                  minHeight: 10.h,
                                  borderRadius: BorderRadius.circular(5),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ],
                            )
                          : const Center(
                              child: LinearProgressIndicator(),
                            );
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(0, 50.h),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          Loc.contactInfoForProposedPerson(),
                          style: getMediumGrey18Style(),
                        ),
                        Text(
                          Loc.addContactFormExample(),
                          style: getRegularGrey13Style(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: hPadding2),
                child: Form(
                  key: _addPersonKey,
                  child: BlocSelector<UpdateContactBloc, UpdateContactState, GetUncompletedContractsState>(
                    selector: (state) => state.getUncompletedContractsState,
                    builder: (context, state) => state.contactsDataList != null
                        ? PageView(
                            scrollDirection: Axis.horizontal,
                            controller: pageController,
                            onPageChanged: (value) {
                              if (state.contactsDataList!.length == _currentIndex.value + 1) {
                                isLastIndex.value = true;
                              } else {
                                isLastIndex.value = false;
                              }
                              debugPrint(isLastIndex.value.toString());
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            children: state.contactsDataList!
                                .map(
                                  (e) => ListView(
                                    padding: const EdgeInsets.only(top: 14),
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Nav.deleteBottomSheet(
                                            context: context,
                                            onDelete: () => BlocProvider.of<UpdateContactBloc>(context)
                                                .deleteContract(id: e.id, isUnCompleteContact: true),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 13.h),
                                          decoration: const BoxDecoration(
                                            color: lightRedColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25.5),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                Loc.delete(),
                                                style: getMeduimRed18Style(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      UpdateContactsCardWidget(
                                        phoneNumber: e.phone,
                                        personName: e.name,
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      ValueListenableBuilder<bool?>(
                                        valueListenable: isMaleSelected,
                                        builder: (context, value, child) => Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (isMaleSelected.value == true) {
                                                    isMaleSelected.value = null;
                                                    updatePersonParameters.gender = null;
                                                  } else {
                                                    isMaleSelected.value = true;
                                                    updatePersonParameters.gender = 'male';
                                                  }
                                                },
                                                child: GenderWidget(
                                                  genderName: Loc.male(),
                                                  isSelected: value ?? false,
                                                ),
                                              ),
                                            ),
                                            Gap(
                                              15.h,
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (isMaleSelected.value == false) {
                                                    isMaleSelected.value = null;
                                                    updatePersonParameters.gender = null;
                                                  } else {
                                                    isMaleSelected.value = false;
                                                    updatePersonParameters.gender = 'female';
                                                  }
                                                },
                                                child: GenderWidget(
                                                  genderName: Loc.female(),
                                                  isSelected: value != null ? !value : false,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      PlaceOfBirthField(
                                        controller: placeOfBirthTextController,
                                        onValidated: (v) {},
                                        readOnly: true,
                                        onClicked: () {
                                          Nav.placeOfBirthBottomSheet(
                                            context,
                                            GetPlaceOfBirthBottomSheet(
                                              placeOfBirthTextController: placeOfBirthTextController,
                                              initialValue: updatePersonParameters.placeOfBirth,
                                              getChosenPlaceOfBirth: (value) {
                                                updatePersonParameters.placeOfBirth = value;
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      PlaceOfWorkField(
                                        controller: placeOfWorkTextController,
                                        readOnly: true,
                                        onArrowClicked: () {
                                          Nav.placeOfWorkBottomSheet(
                                            context,
                                            GetPlaceOfWorkBottomSheet(
                                              initialPlaceOfWorkId: updatePersonParameters.placeOfWork,
                                              getChosenPlaceOfWork: (value) {
                                                debugPrint('$value place Of Work');
                                                updatePersonParameters.placeOfWork = value;
                                              },
                                              placeOfWorkTextController: placeOfWorkTextController,
                                            ),
                                          );
                                        },
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      JobField(
                                        controller: jobTextController,
                                        onChange: (value) {
                                          updatePersonParameters.job = value;
                                        },
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      PersonNoteField(
                                        controller: noteTextController,
                                        maxLines: 3,
                                        onChange: (value) {
                                          updatePersonParameters.notes = value;
                                        },
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      Text(
                                        Loc.wordsYouCanEasilyCommunicateWith(),
                                        style: getMediumGrey18Style(),
                                      ),
                                      WordsCommunicateWithField(
                                        controller: tagsTextController,
                                        confirm: (value) {
                                          BlocProvider.of<UpdateContactBloc>(context).addTagsToPerson(word: value);
                                        },
                                      ),
                                      Gap(
                                        14.h,
                                      ),
                                      BlocSelector<UpdateContactBloc, UpdateContactState, bool>(
                                        selector: (state) =>
                                            state.tagsState.success != null && state.tagsState.success!,
                                        builder: (context, state) {
                                          return BlocProvider.of<UpdateContactBloc>(context).tagsList.isNotEmpty
                                              // check if list is Empty add Size Box
                                              ? SizedBox(
                                                  height: 40.h,
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount:
                                                        BlocProvider.of<UpdateContactBloc>(context).tagsList.length,
                                                    separatorBuilder: (context, index) {
                                                      return Gap(5.w);
                                                    },
                                                    itemBuilder: (context, index) {
                                                      return WordsCommunicateWithWidget(
                                                        onRemove: () {
                                                          BlocProvider.of<UpdateContactBloc>(context)
                                                              .removeTagsFromPerson(index: index, removeAll: false);
                                                          tagsTextController.clear();
                                                        },
                                                        word:
                                                            BlocProvider.of<UpdateContactBloc>(context).tagsList[index],
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox();
                                        },
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: isLastIndex,
                                        builder: (context, value, child) {
                                          return BlocSelector<UpdateContactBloc, UpdateContactState, UpdatePersonState>(
                                            selector: (state) {
                                              return state.updatePersonState;
                                            },
                                            builder: (context, state) {
                                              !state.loadingState.loading && state.isSaveJustCurrent == false;
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                                child: Column(
                                                  children: [
                                                    if (!value)
                                                      CustomElevatedButton(
                                                        condition: !state.loadingState.loading,
                                                        onTap: () {
                                                          if (_addPersonKey.currentState!.validate()) {
                                                            debugPrint(updatePersonParameters.name);
                                                            _submitUpdateContacts(
                                                              contactData: e,
                                                              contextN: context,
                                                              isSaveJustCurrent: false,
                                                            );
                                                          }
                                                        },
                                                        buttonName: Loc.saveAndUpdateAnotherContact(),
                                                        buttonColor: primary,
                                                        context: context,
                                                      ),
                                                    Gap(20.h),
                                                    if (!value)
                                                      CustomElevatedButton(
                                                        condition: !state.loadingState.reloading,
                                                        onTap: () {
                                                          if (_addPersonKey.currentState!.validate()) {
                                                            _submitUpdateContacts(
                                                              contactData: e,
                                                              contextN: context,
                                                              isSaveJustCurrent: true,
                                                            );
                                                          }
                                                        },
                                                        buttonName: Loc.SaveOnlyTheCurrent(),
                                                        buttonColor: lightGreenColor,
                                                        buttonTextStyle: const TextStyle(color: heavyGreenColor),
                                                        context: context,
                                                      ),
                                                    if (value)
                                                      CustomElevatedButton(
                                                        condition: !state.loadingState.reloading,
                                                        onTap: () {
                                                          if (_addPersonKey.currentState!.validate()) {
                                                            _submitUpdateContacts(
                                                              contactData: e,
                                                              contextN: context,
                                                              isSaveJustCurrent: true,
                                                            );
                                                          }
                                                        },
                                                        buttonName: Loc.save(),
                                                        buttonColor: primary,
                                                        buttonTextStyle: const TextStyle(color: Colors.white),
                                                        context: context,
                                                      )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                                .toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _handleNavAfterSuccess({required UpdateContactState state, required BuildContext contextN}) {
    // check success state
    if (state.updatePersonState.success != null && state.updatePersonState.success!) {
      // check if save just current button clicked
      if (state.updatePersonState.isSaveJustCurrent == true) {
        Nav.mainLayoutScreens(context);
      } else {
        // go to update another contact
        _clearAllControllers(contextN: contextN);
        pageController.jumpToPage(_currentIndex.value + 1);
      }
    }
  }

  _clearAllControllers({required BuildContext contextN}) {
    jobTextController.clear();
    isMaleSelected.value = null;
    placeOfBirthTextController.clear();
    placeOfWorkTextController.clear();
    noteTextController.clear();
    tagsTextController.clear();
    updatePersonParameters.clear();
    BlocProvider.of<UpdateContactBloc>(contextN).removeTagsFromPerson(removeAll: true);
  }

  _submitUpdateContacts(
      {required ContactData contactData, required BuildContext contextN, required bool isSaveJustCurrent}) {
    updatePersonParameters.tags = BlocProvider.of<UpdateContactBloc>(contextN).getTags();
    updatePersonParameters.id = contactData.id;
    updatePersonParameters.name = contactData.name;
    updatePersonParameters.phone = contactData.phone;
    debugPrint(updatePersonParameters.name);
    BlocProvider.of<UpdateContactBloc>(contextN).updateContract(
      addPersonParameters: updatePersonParameters,
      isSaveJustCurrent: isSaveJustCurrent,
    );
  }
}
