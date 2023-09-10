import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    super.key,
    this.initialValue,
    this.autoFillHints,
    this.controller,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  /// A value to initialize the field to.
  final String? initialValue;

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            autocorrect: autocorrect,
            readOnly: readOnly,
            autofillHints: autoFillHints,
            cursorColor: AppColors.darkAqua,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              fillColor: AppColors.blueberryDark,
              focusColor: AppColors.blueberryDark,
              hintText: hintText,
              errorText: errorText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              border: InputBorder.none,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
            ),
            onChanged: onChanged,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class CurvedTextField extends StatelessWidget {
  const CurvedTextField({
    super.key,
    this.margin,
    this.hintText,
    this.fillColor,
    this.borderColor,
    this.suffix,
    this.prefix,
    this.enabled,
    this.textInputType,
    this.labelTextStyle,
    this.hintTextStyle,
    this.onChanged,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.onSubmitted,
    this.labelText,
    this.autoFocus,
    this.style,
    this.textAlign,
    this.errorTextStyle,
  });

  final bool? enabled;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController? controller;
  final EdgeInsets? margin;
  final ValueSetter<String>? onSubmitted;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final TextStyle? hintTextStyle;
  final Color? fillColor;
  final Color? borderColor;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool? autoFocus;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextStyle? errorTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Padding(
            padding: margin ?? EdgeInsets.zero,
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: AppColors.kiwi.withOpacity(0.5),
                  cursorColor: AppColors.kiwi,
                  selectionHandleColor: AppColors.kiwi,
                ),
              ),
              child: TextFormField(
                inputFormatters: inputFormatters,
                style: style ??
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.flashWhite,
                        ),
                enabled: enabled ?? true,
                cursorColor: AppColors.kiwi,
                keyboardType: textInputType,
                onChanged: (value) => onChanged!(value),
                validator: validator,
                controller: controller,
                autofocus: autoFocus ?? false,
                onFieldSubmitted: (value) => onSubmitted,
                textAlign: textAlign ?? TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor,
                  suffixIconConstraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    width: 38,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.redWine),
                  ),
                  suffixIcon: suffix,
                  prefixIcon: prefix,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: fillColor ?? AppColors.blueberryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: fillColor ?? AppColors.grey),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: fillColor ?? AppColors.blueberryDark),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: fillColor ?? AppColors.blueberryDark),
                  ),
                  hintText: hintText,
                  labelText: labelText,
                  labelStyle: labelTextStyle ??
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                  errorStyle: errorTextStyle ??
                      context.textTheme.bodyLarge?.copyWith(
                        fontSize: 2,
                      ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintStyle: hintTextStyle ??
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.flashWhite,
                          ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
