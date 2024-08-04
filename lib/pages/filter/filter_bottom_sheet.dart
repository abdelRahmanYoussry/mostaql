import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/widgets/elevated_button.dart';
import 'package:mostaql/pages/filter/filter_bloc.dart';
import 'package:mostaql/pages/filter/filter_state.dart';
import 'package:mostaql/parameters/filter_paramaters.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/styles_manager.dart';
import '../../core/utils/widget_utils.dart';
import '../../core/widgets/custom_divider_widget.dart';
import '../../core/widgets/custom_radio_button_tile_widget.dart';
import '../../core/widgets/fields/search_field.dart';
import '../../models/countries_model.dart';
import '../../models/place_of_work_model.dart';
import '../../models/states_model.dart';
import '../addPerson/widgets/cutom_expansion_widget.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.filterParameters,
    required this.filterByCategory,
    required this.filterByCity,
    required this.clearFilter,
  });

  final ValueChanged<FilterParameters> clearFilter;
  final FilterParameters filterParameters;
  final ValueChanged<dynamic> filterByCity;
  final ValueChanged<dynamic> filterByCategory;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ValueNotifier<PlaceOfWorkData> isCategoriesSelected = ValueNotifier(
    PlaceOfWorkData(
      id: 0,
      title: '',
    ),
  );
  late ValueNotifier<CountriesData> isCountrySelected = ValueNotifier(
    CountriesData(
      name: '',
      id: 0,
    ),
  );
  late ValueNotifier<StatesData> isCitySelected = ValueNotifier(
    StatesData(id: 0, name: ''),
  );
  final ExpansionTileController categoriesExpansionController = ExpansionTileController();
  final ExpansionTileController countryExpansionController = ExpansionTileController();
  final ExpansionTileController cityExpansionController = ExpansionTileController();
  final countrySearchTextController = TextEditingController();
  final searchCategoryTextController = TextEditingController();

  @override
  void dispose() {
    isCategoriesSelected.dispose();
    isCountrySelected.dispose();
    searchCategoryTextController.dispose();
    isCitySelected.dispose();
    countrySearchTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilterBloc>(
      create: (context) => di<FilterBloc>()..getCategories(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<FilterBloc, FilterState>(
            listenWhen: (previous, current) {
              return
                  // previous.getCountriesState != current.getCountriesState ||
                  previous.getCountryAndCity != current.getCountryAndCity;
            },
            listener: (context, state) {},
          ),
        ],
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          maxChildSize: 1.0,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  getBorderRadius(),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 15.h),
                    child: Text(
                      Loc.filter(),
                      style: getBoldBlack22Style(),
                    ),
                  ),
                  const CustomDividerWidget(),
                  Expanded(
                    flex: 3,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        BlocSelector<FilterBloc, FilterState, GetCategoriesState>(
                          selector: (state) => state.getCategoriesState,
                          builder: (context, state) {
                            return ValueListenableBuilder<PlaceOfWorkData>(
                              valueListenable: isCategoriesSelected,
                              builder: (context, value, child) => CustomExpansionWidget(
                                title: Loc.categories(),
                                controller: categoriesExpansionController,
                                onExpansionChanged: (value) {
                                  BlocProvider.of<FilterBloc>(context).getCategories();
                                  if (categoriesExpansionController.isExpanded) {
                                    if (countryExpansionController.isExpanded) {
                                      countryExpansionController.collapse();
                                      debugPrint('isExpanded');
                                    }
                                  }
                                },
                                children: [
                                  const CustomDividerWidget(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: SearchField(
                                      controller: searchCategoryTextController,
                                      filter: false,
                                      label: Loc.writeYourSearchWords(),
                                      onChange: (value) {
                                        BlocProvider.of<FilterBloc>(context).searchInCategories(
                                          searchWord: value,
                                          placeOfWorkModel: state.placeOfWorkModel!,
                                        );
                                      },
                                      onControllerClear: () {
                                        BlocProvider.of<FilterBloc>(context).searchInCategories(
                                          searchWord: '',
                                          placeOfWorkModel: state.placeOfWorkModel!,
                                        );
                                        searchCategoryTextController.clear();
                                      },
                                    ),
                                  ),
                                  const CustomDividerWidget(),
                                  Gap(
                                    10.h,
                                  ),
                                  if (state.loadingState.loading)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  if (state.placeOfWorkModel != null)
                                    Container(
                                      constraints: BoxConstraints(minHeight: 50.h, maxHeight: 200.h),
                                      child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return CustomRadioButtonTile(
                                            onChangeValue: (value2) {
                                              if (value2) {
                                                isCategoriesSelected.value = state.searchedPlaceOfWorkList![index];
                                                widget.filterParameters.categoryId = isCategoriesSelected.value.id;
                                                widget.filterByCategory(isCategoriesSelected.value.id);
                                              } else {
                                                clearCategorySelection();
                                                widget.filterByCategory(null);
                                              }
                                            },
                                            value: isCategoriesSelected.value.id ==
                                                    state.searchedPlaceOfWorkList![index].id ||
                                                checkChosenCategoryId() &&
                                                    widget.filterParameters.categoryId ==
                                                        state.searchedPlaceOfWorkList![index].id,
                                            text: state.searchedPlaceOfWorkList![index].title,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Gap(18.h);
                                        },
                                        shrinkWrap: true,
                                        itemCount: state.searchedPlaceOfWorkList!.length,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const CustomDividerWidget(),
                        BlocSelector<FilterBloc, FilterState, GetCountryAndCity>(
                          selector: (state) => state.getCountryAndCity,
                          builder: (context, state) {
                            return ValueListenableBuilder<CountriesData>(
                              valueListenable: isCountrySelected,
                              builder: (context, value, child) {
                                return CustomExpansionWidget(
                                  title: Loc.countryLabel(),
                                  controller: countryExpansionController,
                                  onExpansionChanged: (value) {
                                    BlocProvider.of<FilterBloc>(context).getCountries();
                                    clearCountrySelection();
                                    if (countryExpansionController.isExpanded) {
                                      if (categoriesExpansionController.isExpanded) {
                                        categoriesExpansionController.collapse();
                                        debugPrint('isExpanded');
                                      }
                                    }
                                  },
                                  children: [
                                    const CustomDividerWidget(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: SearchField(
                                        controller: countrySearchTextController,
                                        filter: false,
                                        label: Loc.writeYourSearchWords(),
                                        onChange: (value) {
                                          BlocProvider.of<FilterBloc>(context).searchInCountries(
                                            searchWord: value,
                                            countriesModel: state.countriesModel!,
                                          );
                                        },
                                        onControllerClear: () {
                                          BlocProvider.of<FilterBloc>(context).searchInCountries(
                                            searchWord: '',
                                            countriesModel: state.countriesModel!,
                                          );
                                          countrySearchTextController.clear();
                                        },
                                      ),
                                    ),
                                    const CustomDividerWidget(),
                                    Gap(10.h),
                                    if (state.loadingState.loading)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    if (state.countriesModel != null)
                                      Container(
                                        constraints: BoxConstraints(minHeight: 50.h, maxHeight: 200.h),
                                        child: ListView.separated(
                                            itemBuilder: (context, index) {
                                              return CustomRadioButtonTile(
                                                onChangeValue: (value2) {
                                                  if (value2) {
                                                    isCountrySelected.value =
                                                        state.countriesModel!.countriesData[index];
                                                    BlocProvider.of<FilterBloc>(context).getStates(
                                                      state.countriesModel!,
                                                      countryId: isCountrySelected.value.id,
                                                    );
                                                  } else {
                                                    clearCountrySelection();
                                                  }
                                                },
                                                value: isCountrySelected.value.id == state.countriesList![index].id,
                                                text: state.countriesList![index].name,
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Gap(18.h);
                                            },
                                            shrinkWrap: true,
                                            itemCount: state.countriesList!.length),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        BlocSelector<FilterBloc, FilterState, GetCountryAndCity>(
                          selector: (state) => state.getCountryAndCity,
                          builder: (context, state) {
                            if (state.loadingState.reloading) {
                              return const Center(
                                child: LinearProgressIndicator(),
                              );
                            }
                            if (state.statesModel == null) {
                              return const SizedBox();
                            }
                            return ValueListenableBuilder(
                              valueListenable: isCitySelected,
                              builder: (context, value, child) {
                                return CustomExpansionWidget(
                                  title: Loc.city(),
                                  initiallyExpanded: true,
                                  controller: cityExpansionController,
                                  onExpansionChanged: (p0) {},
                                  children: state.statesModel!.statesData.map(
                                    (e) {
                                      return CustomRadioButtonTile(
                                        onChangeValue: (value2) {
                                          if (value2) {
                                            isCitySelected.value = e;
                                            widget.filterParameters.stateId = e.id;
                                            widget.filterByCity(e.id);
                                          } else {
                                            clearCitySelection();
                                            widget.filterByCity(null);
                                          }
                                        },
                                        value: isCitySelected.value == e ||
                                            checkChosenSateId() && e.id == widget.filterParameters.stateId,
                                        text: e.name,
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: CustomElevatedButton(
                      width: 300.w,
                      onTap: () {
                        // widget.applyFilter.call(widget.filterParameters);
                        Navigator.pop(context);
                      },
                      buttonName: Loc.apply(),
                      buttonTextStyle: getMediumWhite20Style(),
                      context: context,
                    ),
                  ),
                  Gap(
                    20.h,
                  ),
                  Center(
                    child: CustomElevatedButton(
                      width: 300.w,
                      context: context,
                      removeShadow: true,
                      buttonColor: Colors.grey.shade200,
                      buttonTextStyle: getMediumBlack20Style(),
                      onTap: () {
                        Navigator.pop(context);
                        widget.clearFilter.call(widget.filterParameters);
                      },
                      buttonName: Loc.resetFilter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to clear the country Selection
  void clearCountrySelection() {
    isCountrySelected.value = CountriesData(id: 0, name: '');
    countrySearchTextController.clear();
  }

  // Method to clear the city selection
  void clearCitySelection() {
    isCitySelected.value = StatesData(id: 0, name: '');
    widget.filterParameters.stateId = null;
  }

  void clearCategorySelection() {
    isCategoriesSelected.value = PlaceOfWorkData(id: 0, title: '');
    widget.filterParameters.categoryId = null;
  }

  bool checkChosenSateId() {
    if (widget.filterParameters.stateId == null) {
      return false;
    } else {
      return true;
    }
  }

  bool checkChosenCategoryId() {
    if (widget.filterParameters.categoryId == null) {
      return false;
    } else {
      return true;
    }
  }
}
