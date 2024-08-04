import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/navigation/nav.dart';
import 'package:mostaql/models/contract_model.dart';
import 'package:mostaql/pages/updateContact/bloc/update_contact_bloc.dart';
import 'package:mostaql/pages/updateContact/bloc/update_contact_state.dart';
import 'package:size_config/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/di.dart';
import '../../../../core/localization/loc_keys.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/consts.dart';
import '../../../../core/theme/styles_manager.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/all_Contacts_card_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/fields/search_field.dart';
import '../../../../core/widgets/no_search_result.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../../parameters/filter_paramaters.dart';
import '../../../../repos/contract_repo.dart';
import '../../../filter/filter_bottom_sheet.dart';

class UpdateAllContactsPage extends StatefulWidget {
  const UpdateAllContactsPage({super.key});

  @override
  State<UpdateAllContactsPage> createState() => _UpdateAllContactsPageState();
}

class _UpdateAllContactsPageState extends State<UpdateAllContactsPage> {
  final contactSearchTextController = TextEditingController();
  final ValueNotifier<List<ContactData>> isContactSelected = ValueNotifier([]);
  final ValueNotifier<bool?> isDeleteAll = ValueNotifier(null);
  final ScrollController _scrollController = ScrollController();
  FilterParameters filterParameters = FilterParameters();
  List<int> contactsId = [];
  final searchTextController = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
        isPagination: true,
        filterParameters: filterParameters,
      );
    }
  }

  @override
  void dispose() {
    contactSearchTextController.dispose();
    isContactSelected.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateContactBloc, UpdateContactState>(
          listenWhen: (previous, current) =>
              previous.getUserContactsFromDataBase != current.getUserContactsFromDataBase,
          listener: (context, state) {},
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: lowAppBarHeight,
          title: Row(
            children: [
              Gap(
                10.w,
              ),
              Text(
                Loc.updateContactsFromPhone(),
                style: getHeavyBlack18Style(),
              ),
              const Spacer(),
              BlocSelector<UpdateContactBloc, UpdateContactState, GetUsersContactsFromDataBase>(
                selector: (state) => state.getUserContactsFromDataBase,
                builder: (context, state) {
                  return Container(
                    width: 60.w,
                    height: 35.h,
                    margin: EdgeInsets.only(
                      left: 10.w,
                    ),
                    decoration: const BoxDecoration(
                      color: darkBlueColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          16,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        di<ContractRepo>().userContactsModel!.meta.total.toString(),
                        style: getMediumBlack16Style(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: BlocSelector<UpdateContactBloc, UpdateContactState, GetUsersContactsFromDataBase>(
            selector: (state) => state.getUserContactsFromDataBase,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SearchField(
                      controller: searchTextController,
                      fillColor: Colors.white,
                      onFilter: () {
                        Nav.filterBottomSheet(
                          context,
                          FilterBottomSheet(
                            clearFilter: (filterParameters) {
                              filterParameters.clearFilter();
                              BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                                filterParameters: this.filterParameters,
                                isPagination: false,
                              );
                            },
                            filterByCategory: (value) {
                              filterParameters.categoryId = value;
                              BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                                isPagination: false,
                                filterParameters: filterParameters,
                              );
                            },
                            filterByCity: (value) {
                              filterParameters.stateId = value;
                              BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                                isPagination: false,
                                filterParameters: filterParameters,
                              );
                            },
                            filterParameters: filterParameters,
                          ),
                        );
                      },
                      filter: true,
                      readOnly: false,
                      onTap: () {
                        if (checkIfSearchIsEmpty(state)) {
                          BlocProvider.of<UpdateContactBloc>(context)
                              .getAllUserContactsFromBe(isPagination: false, filterParameters: filterParameters);
                        }
                      },
                      onControllerClear: () {
                        filterParameters.term = null;
                        searchTextController.clear();
                        BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                          filterParameters: filterParameters,
                          isPagination: false,
                        );
                      },
                      onChange: (value) {
                        _debouncer.runLazy(() {
                          if (value.isEmpty) {
                            filterParameters.term = null;
                            BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                              filterParameters: filterParameters,
                              isPagination: false,
                            );
                          } else if (value.length > 2) {
                            filterParameters.term = value;
                            BlocProvider.of<UpdateContactBloc>(context).getAllUserContactsFromBe(
                              filterParameters: filterParameters,
                              isPagination: false,
                            );
                          }
                        }, 1000);
                      },
                    ),
                  ),
                  Visibility(
                    visible: state.contactsList != null && state.contactsList!.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 30.0.h,
                        left: 18.w,
                        right: 18.w,
                        bottom: 10.h,
                      ),
                      child: Row(
                        children: [
                          ValueListenableBuilder<bool?>(
                            valueListenable: isDeleteAll,
                            builder: (context, value, child) => SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: Radio<bool>(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                groupValue: isDeleteAll.value,
                                toggleable: true,
                                value: true,
                                activeColor: primary,
                                onChanged: (newValue) {
                                  isDeleteAll.value = newValue;
                                  debugPrint(isDeleteAll.value.toString());
                                  if (isDeleteAll.value == true) {
                                    isContactSelected.value = [];
                                    isContactSelected.value = List.from(di<ContractRepo>().paginationList);
                                  } else {
                                    isContactSelected.value = [];
                                  }
                                },
                                fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return primary;
                                    }
                                    return Colors.grey.withOpacity(0.5); // Unselected color
                                  },
                                ),
                              ),
                            ),
                          ),
                          Gap(
                            5.w,
                          ),
                          Text(
                            Loc.deleteAll(),
                            style: getMediumBlack14Style(),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (state.loadingState.loading)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 50.h,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (state.contactsList == null)
                    const SizedBox()
                  else
                    ValueListenableBuilder<List<ContactData>>(
                      valueListenable: isContactSelected,
                      builder: (context, isContactSelectedValue, child) => state.contactsList!.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final contact = state.contactsList![index];
                                  final isSelected = isContactSelected.value.contains(contact);
                                  return AllContactCardWidget(
                                    onEdit: () {
                                      Nav.updateContactScreen(context, contact);
                                    },
                                    onChangeValue: (isChecked) {
                                      List<ContactData> updatedList = List.from(isContactSelected.value);
                                      if (isChecked) {
                                        if (!updatedList.contains(contact)) {
                                          updatedList.add(contact);
                                        }
                                      } else {
                                        updatedList.remove(contact);
                                      }

                                      isContactSelected.value = updatedList;
                                    },
                                    onRadioButtonChecked: isSelected,
                                    onClicked: () {
                                      _makePhoneCall(contact.phone);
                                    },
                                    personName: contact.name,
                                    phoneNumber: contact.phone,
                                    onDelete: () {
                                      Nav.deleteBottomSheet(
                                        context: context,
                                        onDelete: () {
                                          BlocProvider.of<UpdateContactBloc>(context).deleteContract(
                                            id: contact.id,
                                            isUnCompleteContact: false,
                                            filterParameters: filterParameters,
                                          );
                                        },
                                      );
                                      isDeleteAll.value = false;
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const CustomDivider(),
                                itemCount: state.contactsList!.length,
                              ),
                            )
                          : const NoSearchResultWidget(),
                    ),
                  if (state.loadingState.reloading)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.w,
                      ),
                      child: LinearProgressIndicator(
                        minHeight: 5.h,
                      ),
                    ),
                  Visibility(
                    visible: state.contactsList != null && state.contactsList!.isNotEmpty,
                    child: ValueListenableBuilder(
                      valueListenable: isDeleteAll,
                      builder: (context, value, child) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0.h),
                            child: GestureDetector(
                              onTap: () {
                                contactsId = isContactSelected.value.map((e) => e.id).toList();
                                for (var element in contactsId) {
                                  debugPrint(element.toString());
                                }
                                if (isContactSelected.value.isNotEmpty) {
                                  Nav.deleteBottomSheet(
                                      context: context,
                                      onDelete: () {
                                        BlocProvider.of<UpdateContactBloc>(context).deleteManyContacts(
                                          contactsList: contactsId,
                                          filterParameters: filterParameters,
                                        );
                                        isContactSelected.value.clear();
                                        isDeleteAll.value = false;
                                        filterParameters.clearFilter();
                                      });
                                } else {
                                  SnackBarBuilder.showFeedBackMessage(context, Loc.deleteWarninigMassage(),
                                      isSuccess: false);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 13.h,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 50.w,
                                ),
                                decoration: const BoxDecoration(
                                  color: lightRedColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
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
                                      Loc.deleteAll(),
                                      style: getMeduimRed18Style(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to clear the selection
  void clearSelection() {
    isContactSelected.value = [];
  }

  bool checkIfSearchIsEmpty(GetUsersContactsFromDataBase state) {
    if ((state.contactsList == null) && !state.loadingState.reloading || (state.clearSearch != null)) {
      return true;
    } else {
      return false;
    }
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
