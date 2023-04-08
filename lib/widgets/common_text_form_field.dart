import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/utils/styles.dart';

class CommonTextFormField extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool isPassword;
  final bool isEmail;
  final bool isDigitsOnly;
  final Color? textColorReceived;
  final Color? hintColorReceived;
  final Color? fillColorReceived;
  final Color borderColorReceived;
  final int maxLinesReceived;
  final int? maxLengthReceived;
  final double borderRadiusReceived;
  final int minLinesReceived;
  final TextEditingController? controller;
  final bool isFullCapsNeeded;
  final bool isReadOnly;
  final bool obscureText;
  final Widget? passwordWidget;
  final double borderWidthReceived;
  final bool enableAutoFocus;

  CommonTextFormField(
      {super.key,
      this.hintText,
      this.validator,
      this.onChanged,
      this.isPassword = false,
      this.isEmail = false,
      this.isDigitsOnly = false,
      this.enableAutoFocus = false,
      this.textColorReceived,
      this.hintColorReceived,
      this.fillColorReceived,
      this.borderColorReceived = Colors.transparent,
      this.maxLinesReceived = 1,
      this.maxLengthReceived,
      this.borderRadiusReceived = 0.0,
      this.minLinesReceived = 1,
      this.controller,
      this.isFullCapsNeeded = false,
      this.isReadOnly = false,
      this.obscureText = false,
      this.passwordWidget,
      this.borderWidthReceived = 1.0});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword ? obscureText : false,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: isReadOnly,
      autofocus: enableAutoFocus,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPassword
              ? TextInputType.visiblePassword
              : (isDigitsOnly ? TextInputType.number : TextInputType.multiline),
      maxLines: maxLinesReceived,
      maxLength: maxLengthReceived,
      minLines: minLinesReceived,
      textCapitalization: isPassword
          ? TextCapitalization.words
          : (isFullCapsNeeded
              ? TextCapitalization.characters
              : TextCapitalization.sentences),
      style: CustomStyles.poppinsLight13
              .copyWith(color: textColorReceived, height: 1.8),
      decoration: InputDecoration(
        fillColor: fillColorReceived,
        suffixIcon: isPassword ? passwordWidget : null,
        filled: true,
        hintText: hintText,
        hintStyle: CustomStyles.poppinsLight13.copyWith(color: hintColorReceived),
        counterText: "",
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 15, 8, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(
              color: borderColorReceived, width: borderWidthReceived.w),
        ),
      ),
    );
  }
}
