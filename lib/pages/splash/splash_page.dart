import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/core/di/di.dart';
import 'package:mostaql/core/navigation/nav.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:mostaql/pages/splash/bloc/splash_bloc.dart';
import 'package:mostaql/pages/splash/bloc/splash_state.dart';
import 'package:size_config/size_config.dart';

import '../../core/utils/get_asset_path.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => di<SplashBloc>()..checkUser(),
      lazy: false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashBloc, SplashState>(
            listenWhen: (previous, current) => previous.hasUser != current.hasUser,
            listener: (context, state) {
              if (state.hasUser == true) {
                // handle after Auth with token to check if got to home or login
                Nav.mainLayoutScreens(context);
                return;
              }
              if (state.isOnBoardingSkipped == true) {
                //check if skip button is clicked go to login

                Timer(const Duration(seconds: 1), () {
                  Nav.mainLayoutScreens(context);
                });
              } else {
                Timer(const Duration(seconds: 1), () {
                  Nav.onBoard(context);
                });
              }

              // Nav.onBoard(context);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Container(
                      width: double.maxFinite,
                      alignment: AlignmentDirectional.center,
                      child: Picture(
                        getAssetIcon('logoNew.svg'),
                        width: 127.w,
                        height: 165.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
