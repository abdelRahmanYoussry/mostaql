import 'package:flutter/material.dart';
import 'package:size_config/size_config.dart';

import '../../core/localization/loc_keys.dart';

class AddPersonPage extends StatelessWidget {
  const AddPersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        centerTitle: false,
        title: Text(
          Loc.addPerson(),
        ),
      ),
      body: Center(
        child: Text(Loc.addPerson()),
      ),
    );
  }
}
