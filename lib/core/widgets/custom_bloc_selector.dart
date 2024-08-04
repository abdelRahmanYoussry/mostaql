import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReusableBlocSelector<B extends Cubit<S>, S, T> extends StatelessWidget {
  final T Function(S) selector;
  final Widget Function(BuildContext, T) builder;

  const ReusableBlocSelector({
    Key? key,
    required this.selector,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, T>(
      selector: selector,
      builder: builder,
    );
  }
}