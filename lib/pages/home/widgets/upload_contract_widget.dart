import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/widgets/fields/search_field.dart';
import 'package:mostaql/pages/home/bloc/home_bloc.dart';
import 'package:mostaql/pages/home/bloc/home_state.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/theme/styles_manager.dart';
import '../../../core/widgets/custom_divider_widget.dart';
import '../../../core/widgets/elevated_button.dart';
import '../../../parameters/filter_paramaters.dart';
import 'build_search_contacts_List.dart';

class UploadContactDialog extends StatefulWidget {
  const UploadContactDialog({
    super.key,
  });

  @override
  State<UploadContactDialog> createState() => _UploadContactDialogState();
}

class _UploadContactDialogState extends State<UploadContactDialog> {
  final contactSearchTextController = TextEditingController();

  final ValueNotifier<Contact?> isContactSelected = ValueNotifier(null);

  final ScrollController _scrollController = ScrollController();
  FilterParameters filterParameters = FilterParameters();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      BlocProvider.of<HomeBloc>(context)
          .searchInUserContractsDataBase(isPagination: true, filterParameters: filterParameters);
    }
  }

  @override
  void dispose() {
    contactSearchTextController.dispose();
    isContactSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.uploadContractsState != current.uploadContractsState,
          listener: (context, state) {},
        )
      ],
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
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
                ),
                child: Text(
                  Loc.uploadContracts(),
                  style: getBoldBlack22Style(),
                ),
              ),
              const CustomDividerWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SearchField(
                  controller: contactSearchTextController,
                  onControllerClear: () {
                    contactSearchTextController.clear();
                  },
                ),
              ),
              Gap(10.h),
              BlocSelector<HomeBloc, HomeState, SearchInDataBaseContactsState>(
                selector: (state) => state.searchInDataBaseContactsState,
                builder: (context, state) {
                  if (state.loadingState.reloading) {
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (state.contactsList == null) {
                    return const SizedBox();
                  }
                  return ValueListenableBuilder(
                    valueListenable: isContactSelected,
                    builder: (context, value, child) {
                      return BuildSearchContactsList(
                        state: state,
                        scrollController: _scrollController,
                      );
                    },
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
    isContactSelected.value = null;
  }
}
