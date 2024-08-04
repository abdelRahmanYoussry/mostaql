import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/pages/placeOfBirth/place_of_birth_bloc.dart';
import 'package:mostaql/pages/placeOfBirth/place_of_birth_state.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/styles_manager.dart';
import '../../core/widgets/custom_divider_widget.dart';
import '../../core/widgets/elevated_button.dart';
import '../../core/widgets/fields/search_field.dart';
import '../../models/states_model.dart';

class GetPlaceOfBirthBottomSheet extends StatefulWidget {
  GetPlaceOfBirthBottomSheet({
    super.key,
    required this.getChosenPlaceOfBirth,
    required this.placeOfBirthTextController,
    this.initialValue,
  });

  final ValueChanged<int>? getChosenPlaceOfBirth;
  final TextEditingController placeOfBirthTextController;
  int? initialValue;

  @override
  State<GetPlaceOfBirthBottomSheet> createState() => _GetPlaceOfBirthBottomSheetState();
}

class _GetPlaceOfBirthBottomSheetState extends State<GetPlaceOfBirthBottomSheet> {
  final placeOfBirthSearchTextController = TextEditingController();

  final ValueNotifier<StatesData> isCitySelected = ValueNotifier(
    StatesData(id: 0, name: ''),
  );

  @override
  void dispose() {
    placeOfBirthSearchTextController.dispose();
    isCitySelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceOfBirthBloc>(
      create: (context) => di<PlaceOfBirthBloc>()..getCountries(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PlaceOfBirthBloc, PlaceOfBirthState>(
            listenWhen: (previous, current) => previous.getPlaceOfBirthState != current.getPlaceOfBirthState,
            listener: (context, state) {},
          )
        ],
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(
                30.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                  bottom: 15.h,
                ),
                child: Text(
                  Loc.placeOfBirth(),
                  style: getBoldBlack22Style(),
                ),
              ),
              const CustomDividerWidget(),
              BlocSelector<PlaceOfBirthBloc, PlaceOfBirthState, GetPlaceOfBirthState>(
                selector: (state) => state.getPlaceOfBirthState,
                builder: (context, state) {
                  return state.countriesModel == null
                      ? const Center(child: CircularProgressIndicator())
                      : ExpansionPanelList.radio(
                          initialOpenPanelValue: 1,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (number, value) {
                            if (value) {
                              BlocProvider.of<PlaceOfBirthBloc>(context).getStates(
                                state.countriesModel!,
                                countryId: state.countriesModel!.countriesData[number].id,
                              );
                            }
                          },
                          dividerColor: Colors.white,
                          children: state.countriesModel!.countriesData.map<ExpansionPanelRadio>(
                            (item) {
                              return ExpansionPanelRadio(
                                value: item.id,
                                canTapOnHeader: false,
                                headerBuilder: (context, isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      item.name,
                                      style: getBoldGray18Style(),
                                    ),
                                  );
                                },
                                body: Column(
                                  children: [
                                    const CustomDividerWidget(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                      ),
                                      child: SearchField(
                                        controller: placeOfBirthSearchTextController,
                                        filter: false,
                                        onChange: (value) {
                                          BlocProvider.of<PlaceOfBirthBloc>(context).searchInStates(
                                            statesModel: state.statesModel!,
                                            searchWord: value,
                                            countriesModel: state.countriesModel!,
                                          );
                                        },
                                        onControllerClear: () {
                                          BlocProvider.of<PlaceOfBirthBloc>(context).searchInStates(
                                            statesModel: state.statesModel!,
                                            searchWord: '',
                                            countriesModel: state.countriesModel!,
                                          );
                                          placeOfBirthSearchTextController.clear();
                                        },
                                        label: Loc.writeYourSearchWords(),
                                      ),
                                    ),
                                    const CustomDividerWidget(),
                                    Gap(10.h),
                                    if (state.loadingState.reloading)
                                      SizedBox(
                                        height: 70.h,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        );
                },
              ),
              const Spacer(),
              Center(
                child: CustomElevatedButton(
                    width: 300.w,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    buttonName: Loc.save(),
                    context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to clear the selection
  void clearSelection() {
    isCitySelected.value = StatesData(id: 0, name: '');
    widget.placeOfBirthTextController.clear();
  }
}
