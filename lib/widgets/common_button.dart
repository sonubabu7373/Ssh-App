import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/utils/styles.dart';

class CommonButton extends StatelessWidget {
  final String? buttonText;
  final Function? buttonHandler;
  final Color? textColorReceived;
  final Color? bgColorReceived;
  final Color? borderColorReceived;
  final double? borderRadiusReceived;

  const CommonButton(
      {super.key,
      required this.buttonText,
      required this.textColorReceived,
      required this.bgColorReceived,
      required this.borderColorReceived,
      required this.borderRadiusReceived,
      this.buttonHandler});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived!),
        ),
        backgroundColor: bgColorReceived,
        elevation: 0.0,
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
        side: BorderSide(
          width: 1.0.w,
          color: borderColorReceived!,
        ),
      ),
      onPressed: () {
        buttonHandler!();
      },
      child: Text(
        "$buttonText",
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: CustomStyles.poppinsLight14.copyWith(color: textColorReceived),
      ),
    );
  }
}
