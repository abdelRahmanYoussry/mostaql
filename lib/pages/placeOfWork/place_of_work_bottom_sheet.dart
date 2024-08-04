import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/pages/placeOfWork/place_of_work_bloc.dart';
import 'package:mostaql/pages/placeOfWork/place_of_work_state.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/styles_manager.dart';
import '../../core/widgets/custom_divider_widget.dart';
import '../../core/widgets/custom_radio_button_tile_widget.dart';
import '../../core/widgets/elevated_button.dart';
import '../../core/widgets/fields/search_field.dart';
import '../../models/place_of_work_model.dart';

class GetPlaceOfWorkBottomSheet extends StatefulWidget {
  GetPlaceOfWorkBottomSheet({
    super.key,
    required this.getChosenPlaceOfWork,
    required this.placeOfWorkTextController,
    this.initialPlaceOfWorkId,
  });

  final TextEditingController placeOfWorkTextController;
  final ValueChanged<int>? getChosenPlaceOfWork;
  int? initialPlaceOfWorkId;

  @override
  State<GetPlaceOfWorkBottomSheet> createState() => _GetPlaceOfWorkBottomSheetState();
}

class _GetPlaceOfWorkBottomSheetState extends State<GetPlaceOfWorkBottomSheet> {
  final ValueNotifier<PlaceOfWorkData> isPlaceOfWorkSelected = ValueNotifier(
    PlaceOfWorkData(title: '', id: 0),
  );

  final placeOfWorkSearchTextController = TextEditingController();

  @override
  void dispose() {
    isPlaceOfWorkSelected.dispose();
    placeOfWorkSearchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceOfWorkBloc>(
      create: (context) => di<PlaceOfWorkBloc>()..getPlacesOfWork(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PlaceOfWorkBloc, PlaceOfWorkState>(
            listenWhen: (previous, current) => previous.getPlaceOfWorkState != current.getPlaceOfWorkState,
            listener: (context, state) {},
          )
        ],
        child: BlocSelector<PlaceOfWorkBloc, PlaceOfWorkState, GetPlaceOfWorkState>(
          selector: (state) => state.getPlaceOfWorkState,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      Loc.placeOfWork(),
                      style: getBoldBlack18Style(),
                    ),
                  ),
                  const CustomDividerWidget(),
                  Gap(5.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: SearchField(
                      controller: placeOfWorkSearchTextController,
                      filter: false,
                      label: Loc.writeYourSearchWords(),
                      onChange: (value) {
                        BlocProvider.of<PlaceOfWorkBloc>(context).searchInPlaceOfWork(
                          placeOfWorkModel: state.placeOfWorkModel!,
                          searchWord: value,
                        );
                      },
                      onControllerClear: () {
                        BlocProvider.of<PlaceOfWorkBloc>(context).searchInPlaceOfWork(
                          placeOfWorkModel: state.placeOfWorkModel!,
                          searchWord: '',
                        );
                        placeOfWorkSearchTextController.clear();
                      },
                    ),
                  ),
                  Gap(
                    5.h,
                  ),
                  const CustomDividerWidget(),
                  Gap(
                    15.h,
                  ),
                  ValueListenableBuilder(
                    valueListenable: isPlaceOfWorkSelected,
                    builder: (context, value, child) {
                      if (state.placeOfWorkModel == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        flex: 3,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          itemBuilder: (context, index) {
                            return CustomRadioButtonTile(
                              onChangeValue: (value2) {
                                if (value2) {
                                  isPlaceOfWorkSelected.value = state.searchedPlaceList![index];
                                  widget.initialPlaceOfWorkId = isPlaceOfWorkSelected.value.id;
                                  widget.placeOfWorkTextController.text =
                                      state.placeOfWorkModel!.placeOfWorkDataList[index].title;
                                  widget.getChosenPlaceOfWork!(
                                    isPlaceOfWorkSelected.value.id,
                                  );
                                } else {
                                  clearSelection();
                                }
                              },
                              value: state.searchedPlaceList![index].id == isPlaceOfWorkSelected.value.id ||
                                  (widget.initialPlaceOfWorkId != null &&
                                      state.searchedPlaceList![index].id == widget.initialPlaceOfWorkId),
                              text: state.searchedPlaceList![index].title,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Gap(
                              20.h,
                            );
                          },
                          shrinkWrap: true,
                          itemCount: state.searchedPlaceList!.length,
                        ),
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
            );
          },
        ),
      ),
    );
  }

  // Method to clear the selection
  void clearSelection() {
    isPlaceOfWorkSelected.value = PlaceOfWorkData(id: 0, title: '');
    widget.placeOfWorkTextController.clear();
  }
}
