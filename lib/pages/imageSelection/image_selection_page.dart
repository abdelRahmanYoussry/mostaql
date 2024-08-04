import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/pages/imageSelection/widgets/empty_profile_gallery_widget.dart';
import 'package:mostaql/pages/imageSelection/widgets/profile_pics_grid.dart';
import 'package:mostaql/pages/settings/cubit/settings_cubit.dart';
import 'package:mostaql/pages/settings/cubit/settings_state.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/consts.dart';
import '../../core/theme/styles_manager.dart';
import '../../models/recently_profile_photos_model.dart';

class ImageSelectionPage extends StatelessWidget {
  const ImageSelectionPage({super.key, required this.onImageClicked, required this.onPickUpImageFromPhone});

  final VoidCallback onPickUpImageFromPhone;
  final ValueChanged<RecentlyPhotoData>? onImageClicked;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SettingsPageCubit>()..getHistoricalImage(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20.h),
                color: Colors.white,
                height: highAppBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, size: 20.s),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      Loc.selectImage(),
                      style: getHeavyBlack18Style(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        // Handle the trailing icon press
                        onPickUpImageFromPhone.call();
                      },
                    ),
                  ],
                ),
              ),
              BlocSelector<SettingsPageCubit, SettingsPageState, PickUpImageState>(
                selector: (state) => state.pickUpImageState,
                builder: (context, state) {
                  return Expanded(
                    child: (state.loadingState.loading)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : (state.recentlyPhotoData != null && state.recentlyPhotoData!.isNotEmpty)
                            ? ProfilePicsGrid(
                                onImageClicked: (value) {
                                  onImageClicked!.call(value);
                                },
                                recentlyPhotoData: state.recentlyPhotoData!,
                              )
                            : const EmptyProfileGalleryWidget(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
