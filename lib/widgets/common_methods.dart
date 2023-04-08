import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/utils/color_res.dart';

showValidationToast(String message, {int duration = 2}) {
  BotToast.showSimpleNotification(
    title: message,
    duration: Duration(seconds: duration),
    hideCloseButton: true,
    backgroundColor: ColorRes.black,
    titleStyle: TextStyle(
        color: ColorRes.white, fontSize: 13),
    borderRadius: 10,
  );
}
