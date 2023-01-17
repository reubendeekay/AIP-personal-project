import 'package:flutter/material.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';

class KDropdownButtonFormField<T> extends StatelessWidget {
  final String? labelText, hintText;
  final String? Function(T?)? validator;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final bool enabled;
  final T? value;

  const KDropdownButtonFormField({
    Key? key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: AppTextTheme.bodyText18,
      validator: validator,
      items: !enabled ? null : items,
      onChanged: onChanged,
      value: value,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 70),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        labelText: labelText,
        labelStyle: AppTextTheme.bodyText18,
        enabled: enabled,
        hintText: hintText,
        hintStyle: AppTextTheme.bodyText18,
        fillColor: primaryColor.withOpacity(0.2),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }
}
