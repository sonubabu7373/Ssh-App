import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/utils/color_res.dart';
import 'package:sample_terminal_app/utils/styles.dart';
import 'package:sample_terminal_app/widgets/common_text_form_field.dart';
import 'package:stacked/stacked.dart';

import 'add_new_user_viewmodel.dart';

class AddNewUserHostInfo extends StatelessWidget {
  const AddNewUserHostInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddNewUserViewModel>.reactive(
      onModelReady: (model) async {
        model.init();
      },
      viewModelBuilder: () => AddNewUserViewModel(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () {
            Get.back(result: model.isNewDataAdded);
            return Future.value(true);
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.black12.withOpacity(0.3),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          if (!model.isBusy) {
                            Get.back(result: model.isNewDataAdded);
                          }
                        },
                        child: Container()),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    alignment: FractionalOffset.centerLeft,
                    decoration: const BoxDecoration(
                        color: ColorRes.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            alignment: FractionalOffset.centerLeft,
                            child: const Text(
                              "Add New",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 25,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            Get.back(result: model.isNewDataAdded);
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Host",
                            style: CustomStyles.poppinsLight15
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CommonTextFormField(
                              hintText: "Host",
                              maxLinesReceived: 3,
                              maxLengthReceived: 150,
                              minLinesReceived: 2,
                              isEmail: false,
                              isReadOnly: false,
                              borderRadiusReceived: 10,
                              textColorReceived: ColorRes.black,
                              fillColorReceived: ColorRes.background,
                              hintColorReceived: Colors.grey,
                              borderColorReceived: ColorRes.textFieldBorder,
                              controller: model.hostNameController),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Username",
                            style: CustomStyles.poppinsLight15
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CommonTextFormField(
                              hintText: "username",
                              maxLinesReceived: 1,
                              maxLengthReceived: 80,
                              isEmail: false,
                              isReadOnly: false,
                              borderRadiusReceived: 10.r,
                              textColorReceived: ColorRes.black,
                              fillColorReceived: ColorRes.background,
                              hintColorReceived: Colors.grey,
                              borderColorReceived: ColorRes.textFieldBorder,
                              controller: model.userNameController),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: Container(
                              alignment: FractionalOffset.center,
                              width: double.infinity,
                              color: ColorRes.primaryColor,
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: FractionalOffset.center,
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  if (model.isBusy) ...[
                                    const CupertinoActivityIndicator(
                                        color: Colors.white),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ]
                                ],
                              ),
                            ),
                            onTap: () {
                              if (!model.isBusy) {
                                model.createUserInfo();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
