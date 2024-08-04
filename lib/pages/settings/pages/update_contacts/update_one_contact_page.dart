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

import '../../../../core/di/di.dart';
import '../../../../core/localization/loc_keys.dart';
import '../../../../core/navigation/nav.dart';
import '../../../../core/theme/consts.dart';
import '../../../../core/theme/styles_manager.dart';
import '../../../../core/widgets/fields/name_field.dart';
import '../../../../core/widgets/fields/name_of_work_field.dart';
import '../../../../core/widgets/fields/person_note_field.dart';
import '../../../../core/widgets/fields/phone_field.dart';
import '../../../../core/widgets/fields/place_of_birth_field.dart';
import '../../../../core/widgets/fields/place_of_work_field.dart';
import '../../../../core/widgets/fields/words_communicate_with_field.dart';
import '../../../../core/widgets/gender_widet.dart';
import '../../../../core/widgets/words_communicate_widget.dart';
import '../../../placeOfBirth/place_of_birth_bottom_sheet.dart';
import '../../../updateContact/bloc/update_contact_bloc.dart';
import '../../../updateContact/bloc/update_contact_state.dart';

class UpdateContactPage extends StatefulWidget {
  const UpdateContactPage({super.key, required this.contactData});

  final ContactData contactData;

  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
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
    isLastIndex.dispose();
    _currentIndex.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    debugPrint(widget.contactData.toJson().toString());
    pageController.addListener(() {
      _currentIndex.value = pageController.page?.round() ?? 0;
    });
    initialContactData();

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
            listenWhen: (previous, current) =>
                previous.updatePersonState != current.updatePersonState ||
                previous.deletePersonState != current.deletePersonState,
            listener: (context, state) {
              _handleNavAfterSuccess(state: state, contextN: context);
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        Text("${_currentIndex.value + 1} / ${1}"),
                      ],
                    ),
                    Gap(15.h),
                    LinearProgressIndicator(
                      value: (_currentIndex.value.toDouble() + 1),
                      backgroundColor: Colors.grey[300],
                      minHeight: 10.h,
                      borderRadius: BorderRadius.circular(5),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
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
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    onPageChanged: (value) {},
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListView(
                        padding: const EdgeInsets.only(top: 14),
                        children: [
                          // UpdateContactsCardWidget(
                          //   phoneNumber: widget.contactData.phone,
                          //   personName: widget.contactData.name,
                          // ),
                          NameField(
                            controller: nameTextController,
                            label: Loc.personName(),
                            onValidated: (v) {},
                            autoFocus: false,
                            confirm: (value) {
                              updatePersonParameters.name = value;
                            },
                            onChange: (value) {
                              updatePersonParameters.name = value;
                            },
                          ),
                          Gap(14.h),
                          PhoneField(
                            controller: phoneTextController,
                            isAddPersonPage: true,
                            getChosenPhoneCode: (phoneCode) {
                              updatePersonParameters.phoneCode = phoneCode;
                            },
                            showHint: true,
                            onChange: (value) {
                              updatePersonParameters.phone = value;
                            },
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
                            selector: (state) => state.tagsState.success != null && state.tagsState.success!,
                            builder: (context, state) {
                              return BlocProvider.of<UpdateContactBloc>(context).tagsList.isNotEmpty
                                  // check if list is Empty add Size Box
                                  ? SizedBox(
                                      height: 40.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: BlocProvider.of<UpdateContactBloc>(context).tagsList.length,
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
                                            word: BlocProvider.of<UpdateContactBloc>(context).tagsList[index],
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
                                    child: CustomElevatedButton(
                                      condition: !state.loadingState.reloading,
                                      onTap: () {
                                        if (_addPersonKey.currentState!.validate()) {
                                          _submitUpdateContacts(
                                            contactData: widget.contactData,
                                            contextN: context,
                                            isSaveJustCurrent: true,
                                          );
                                        }
                                      },
                                      buttonName: Loc.save(),
                                      buttonColor: primary,
                                      buttonTextStyle: const TextStyle(color: Colors.white),
                                      context: context,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ],
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
    if (state.deletePersonState.success != null) {
      Nav.updateAllContactsPage(context);
    }
    if (state.updatePersonState.error != null) {
      SnackBarBuilder.showFeedBackMessage(
        context,
        state.updatePersonState.error.toString(),
        isSuccess: false,
      );
    }
    if (state.updatePersonState.success != null && state.updatePersonState.success!) {
      // check if save just current button clicked
      if (state.updatePersonState.isSaveJustCurrent == true) {
        Nav.mainLayoutScreens(context);
      }
    }
  }

  _submitUpdateContacts(
      {required ContactData contactData, required BuildContext contextN, required bool isSaveJustCurrent}) {
    updatePersonParameters.tags = BlocProvider.of<UpdateContactBloc>(contextN).getTags();
    updatePersonParameters.id = contactData.id;
    updatePersonParameters.name = updatePersonParameters.name ?? contactData.name;
    updatePersonParameters.phone = updatePersonParameters.phone ?? contactData.phone;
    BlocProvider.of<UpdateContactBloc>(contextN).updateContract(
      addPersonParameters: updatePersonParameters,
      isSaveJustCurrent: isSaveJustCurrent,
    );
  }

  void initialContactData() {
    updatePersonParameters = ContactParameters(
      gender: widget.contactData.gender,
      name: widget.contactData.name,
      phone: widget.contactData.phone,
      id: widget.contactData.id,
      job: widget.contactData.job,
      notes: widget.contactData.notes,
    );
    nameTextController.text = widget.contactData.name;
    phoneTextController.text = removeLeadingTwo(widget.contactData.phone);
    updatePersonParameters.phone = removeLeadingTwo(widget.contactData.phone);
    if (widget.contactData.placeOfBirth != null) {
      updatePersonParameters.placeOfBirth = widget.contactData.placeOfBirth!.id;
      placeOfBirthTextController.text = widget.contactData.placeOfBirth!.name!;
    }
    if (widget.contactData.gender != null && widget.contactData.gender!.isNotEmpty) {
      debugPrint(widget.contactData.gender.toString());
      if (widget.contactData.gender == 'male') {
        isMaleSelected.value = true;
      } else {
        isMaleSelected.value = false;
      }
    }
    if (widget.contactData.placeOfWork != null) {
      updatePersonParameters.placeOfWork = widget.contactData.placeOfWork!.id;
      placeOfWorkTextController.text = widget.contactData.placeOfWork!.title!;
    }
    if (widget.contactData.job != null) {
      jobTextController.text = widget.contactData.job!;
    }
    if (widget.contactData.notes != null) {
      noteTextController.text = widget.contactData.notes!;
    }
    if (widget.contactData.tags != null) {
      tagsTextController.text = widget.contactData.tags!;
    }
  }
}

String removeLeadingTwo(String input) {
  if (input.startsWith('2')) {
    return input.substring(1);
  }
  return input;
}
