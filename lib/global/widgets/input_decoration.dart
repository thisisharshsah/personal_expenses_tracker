import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final bool obscureText;
  final Widget? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    required this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: label,
      onChanged: onChanged,
      onTap: onTap,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon ??
            Icon(
              icon,
              color: Theme.of(context).hintColor,
            ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: EdgeInsets.all(10.sp),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        errorStyle: Theme.of(context).textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(6),
      ]),
    );
  }
}
