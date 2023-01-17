import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';

class KTextFormField extends StatelessWidget {
  final String? labelText, hintText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLen;
  final Function(String)? onChanged;

  const KTextFormField({
    Key? key,
    this.readOnly = false,
    this.labelText,
    this.hintText,
    this.validator,
    this.controller,
    this.textInputAction,
    this.enabled = true,
    this.maxLen,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLength: maxLen,
      onChanged: onChanged,
      style: AppTextTheme.bodyText16,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 70),
        isDense: true,
        enabled: enabled,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppTextTheme.bodyText18,
        fillColor: primaryColor.withOpacity(0.2),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }
}
