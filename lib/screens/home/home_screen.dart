import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/screens/home/home_screen_view_model.dart';
import 'package:sample_terminal_app/screens/user_list/user_list_screen.dart';
import 'package:sample_terminal_app/utils/color_res.dart';
import 'package:sample_terminal_app/utils/styles.dart';
import 'package:sample_terminal_app/widgets/common_button.dart';
import 'package:sample_terminal_app/widgets/common_text_form_field.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize:
            Get.width < 600 ? const Size(1080, 2220) : const Size(2148, 1636),
        minTextAdapt: true,
        builder: (_, c) {
          return ViewModelBuilder<HomeScreenViewModel>.reactive(
            onModelReady: (model) async {
              model.init();
            },
            viewModelBuilder: () => HomeScreenViewModel(),
            builder: (context, model, child) {
              return WillPopScope(
                onWillPop: model.willPop,
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Colors.black12.withOpacity(0.3),
                    appBar: PreferredSize(
                      preferredSize: const Size(0, 0),
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                    body: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.blue,
                            width: Get.width,
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                            alignment: FractionalOffset.centerLeft,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "MTS SSH Authentication",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (!model.isBusy) ...[
                                  IconButton(
                                    iconSize: 25,
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Get.to(() => const UserListScreen(
                                          isSelectMode: false));
                                    },
                                  )
                                ],
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      _buildInputSection(model),
                                      _buildSubmitButtons(model)
                                    ],
                                  ),
                                ),
                                _buildPostApiLoader(model)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _buildSubmitButtons(HomeScreenViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: Get.width,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: CommonButton(
            buttonText: "Connect With Password",
            bgColorReceived: ColorRes.primaryColor,
            borderColorReceived: ColorRes.primaryColor,
            textColorReceived: ColorRes.white,
            buttonHandler: () async {
              model.connectWithPassword();
            },
            borderRadiusReceived: 10,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          width: Get.width,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: CommonButton(
            buttonText: "Connect With Key",
            bgColorReceived: ColorRes.primaryColor,
            borderColorReceived: ColorRes.primaryColor,
            textColorReceived: ColorRes.white,
            buttonHandler: () async {
              model.connectWithKey();
            },
            borderRadiusReceived: 10,
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  _buildPostApiLoader(HomeScreenViewModel model) {
    if (model.isBusy) {
      return Container(
        height: Get.height,
        width: Get.width,
        color: Colors.black12.withOpacity(0.3),
        child: const Center(
          child: CupertinoActivityIndicator(color: ColorRes.primaryColor),
        ),
      );
    }
    return Container();
  }

  _buildInputSection(HomeScreenViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            model.selectSavedUserCredential();
          },
          child: Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: ColorRes.textFieldBorder),
            ),
            child: Row(
              children: const [
                Expanded(
                  child: Text("Choose Saved Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildUserNameAndPasswordSection(model),
        const SizedBox(height: 15),
        Container(
          alignment: FractionalOffset.center,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: const Text("OR",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start),
        ),
        SizedBox(height: 15.h),
        if (model.filePicked != null) ...[
          Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: const Text("Selected Key File",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start),
          )
        ],
        InkWell(
          onTap: () async {
            debugPrint("clicked");
            model.chooseKeyFile();
          },
          child: Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: ColorRes.textFieldBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: model.filePicked == null
                        ? Text("Choose Private Key",
                            style: CustomStyles.poppinsLight15
                                .copyWith(color: Colors.black))
                        : Text("${model.filePicked?.path}",
                            style: CustomStyles.poppinsLight15
                                .copyWith(color: Colors.black))),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  model.filePicked == null
                      ? Icons.arrow_forward_ios
                      : Icons.edit_note,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildUserNameAndPasswordSection(HomeScreenViewModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: Text("Host Name",
                style:
                    CustomStyles.poppinsLight15.copyWith(color: Colors.black)),
          ),
          SizedBox(
            height: 10.h,
          ),
          CommonTextFormField(
              hintText: "Host",
              maxLinesReceived: 2,
              maxLengthReceived: 150,
              minLinesReceived: 1,
              isEmail: false,
              isReadOnly: false,
              borderRadiusReceived: 10,
              textColorReceived: ColorRes.black,
              fillColorReceived: ColorRes.background,
              hintColorReceived: Colors.grey,
              borderColorReceived: ColorRes.textFieldBorder,
              controller: model.hostNameController),
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text("User Name",
                style:
                    CustomStyles.poppinsLight15.copyWith(color: Colors.black)),
          ),
          const SizedBox(
            height: 15,
          ),
          CommonTextFormField(
              hintText: "username",
              maxLinesReceived: 1,
              maxLengthReceived: 80,
              isEmail: false,
              isReadOnly: false,
              borderRadiusReceived: 10,
              textColorReceived: ColorRes.black,
              fillColorReceived: ColorRes.background,
              hintColorReceived: Colors.grey,
              borderColorReceived: ColorRes.textFieldBorder,
              controller: model.userNameController),
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: FractionalOffset.centerLeft,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text("Password",
                style:
                    CustomStyles.poppinsLight15.copyWith(color: Colors.black)),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonTextFormField(
              hintText: "Password",
              maxLinesReceived: 1,
              maxLengthReceived: 50,
              isPassword: true,
              isReadOnly: false,
              obscureText: model.obs,
              borderRadiusReceived: 10,
              textColorReceived: ColorRes.black,
              fillColorReceived: ColorRes.background,
              hintColorReceived: Colors.grey,
              borderColorReceived: ColorRes.textFieldBorder,
              controller: model.passwordController,
              passwordWidget: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12.0),
                child: InkWell(
                  onTap: model.togglePasswordVisibility,
                  child: model.obs
                      ? const Icon(
                          Icons.visibility_off,
                          color: ColorRes.grey,
                          size: 20,
                        )
                      : const Icon(
                          Icons.remove_red_eye,
                          color: ColorRes.primaryColor,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
