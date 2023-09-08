// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void hideKeyBoard(BuildContext context) {
  FocusScope.of(context).unfocus();
  SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
}

void getBack(BuildContext context) {
  Navigator.of(context).pop();
}

void navigateTo(
  BuildContext context,
  Widget widget,
  String routeName, {
  bool isReplacment = false,
}) {
  if (isReplacment) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        ),
      ),
    );
  }
}
