import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//ignore_for_file:public_member_api_docs

/// snack bar extension
extension ContextExt on BuildContext {
  ///showSnackBar
  void showSnackBar({required String message}) {
    final screenSize = MediaQuery.sizeOf(this);

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          dismissDirection: DismissDirection.up,
          margin: const EdgeInsets.all(12)
              .copyWith(bottom: screenSize.height - 100),
        ),
      );
  }

  void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  void push(Widget widget) {
    Navigator.of(this).push(
      MaterialPageRoute<Widget>(builder: (_) => widget),
    );
  }

  void pushReplacement(Widget widget) {
    Navigator.of(this).pushReplacement(
      MaterialPageRoute<Widget>(builder: (_) => widget),
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }

  void pushNamed(Widget widget, String routeName) {
    Navigator.push(
      this,
      MaterialPageRoute<Widget>(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        ),
      ),
    );
  }

  void pushNamedReplacement(Widget widget, String routeName) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute<Widget>(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        ),
      ),
    );
  }
}

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }
}
