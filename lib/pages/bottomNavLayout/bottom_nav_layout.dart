import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/pages/addPerson/add_person_page.dart';
import 'package:mostaql/pages/home/bloc/home_bloc.dart';
import 'package:mostaql/pages/home/home_page.dart';
import 'package:mostaql/pages/settings/pages/settings_page.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/consts.dart';
import '../../core/widgets/picture.dart';
import '../chat/pages/chat_page.dart';
import '../settings/cubit/settings_cubit.dart';

class BottomNavPage extends StatelessWidget {
  BottomNavPage({super.key});

  final List<Widget> bottomNavScreens = [
    BlocProvider(
      create: (context) => di<HomeBloc>()..getAllUserContacts(),
      child: const HomePage(),
    ),
    const ChatPage(),
    const AddPersonPage(),
    const SettingsPage()
  ];
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsPageCubit>(
          lazy: false,
          create: (context) => di<SettingsPageCubit>()
            ..getProfileData(
              getNewData: true,
            ),
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, value, child) {
          return Scaffold(
            body: bottomNavScreens[_currentIndex.value],
            bottomNavigationBar: LayoutBuilder(
              builder: (context, constraints) {
                // indicator to bottom Nav bar
                // 4 is total tabs count
                //  8 is total tabs count *2
                // listen to lang if it's ar Position should be right and left if en
                final indicatorPosition =
                    constraints.maxWidth / 4 * (_currentIndex.value) + (constraints.maxWidth / 8) - 40;
                return Stack(
                  children: [
                    BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      selectedLabelStyle: TextStyle(
                        fontSize: 14.sp,
                      ),
                      items: [
                        BottomNavigationBarItem(
                            icon: Picture(
                              paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                              color: Colors.grey,
                              width: iconsWidth,
                              height: iconsHeight,
                              getAssetIcon(
                                'home_icon.svg',
                              ),
                            ),
                            label: Loc.home(),
                            activeIcon: Picture(
                              paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                              width: iconsWidth,
                              height: iconsHeight,
                              getAssetIcon(
                                'home_icon.svg',
                              ),
                            )),
                        BottomNavigationBarItem(
                            icon: Picture(
                              paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                              width: iconsWidth,
                              height: iconsHeight,
                              color: Colors.grey,
                              getAssetIcon(
                                'chat_icon.svg',
                              ),
                            ),
                            label: Loc.chat(),
                            activeIcon: Picture(
                              paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                              width: iconsWidth,
                              height: iconsHeight,
                              color: primary,
                              getAssetIcon(
                                'chat_icon.svg',
                              ),
                            )),
                        BottomNavigationBarItem(
                          icon: Picture(
                            paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                            width: iconsWidth,
                            height: iconsHeight,
                            color: Colors.grey,
                            getAssetIcon(
                              'add_person_icon.svg',
                            ),
                          ),
                          activeIcon: Picture(
                            paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                            width: iconsWidth,
                            height: iconsHeight,
                            color: primary,
                            getAssetIcon(
                              'add_person_icon.svg',
                            ),
                          ),
                          label: Loc.addPerson(),
                        ),
                        BottomNavigationBarItem(
                          icon: Picture(
                            paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                            width: iconsWidth,
                            height: iconsHeight,
                            color: Colors.grey,
                            getAssetIcon(
                              'settings_icon.svg',
                            ),
                          ),
                          activeIcon: Picture(
                            paddingEdgeInsets: const EdgeInsets.symmetric(vertical: 6),
                            width: iconsWidth,
                            height: iconsHeight,
                            color: primary,
                            getAssetIcon(
                              'settings_icon.svg',
                            ),
                          ),
                          label: Loc.mySettings(),
                        ),
                      ],
                      currentIndex: _currentIndex.value,
                      elevation: 4,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Colors.grey,
                      onTap: (index) {
                        // di<CacheHelper>().clear(kUserOnBoardIsSkipped);
                        _currentIndex.value = index;
                      },
                    ),
                    Positioned(
                      right: context.locale.languageCode == 'ar' ? indicatorPosition : null,
                      left: context.locale.languageCode == 'en' ? indicatorPosition : null,
                      child: Container(
                        width: 80.w,
                        height: 2,
                        decoration: const BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
