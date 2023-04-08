import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/models/unserinfo.dart';
import 'package:sample_terminal_app/screens/add_new_user_info/add_new_user_info.dart';
import 'package:sample_terminal_app/utils/color_res.dart';
import 'package:sample_terminal_app/utils/styles.dart';
import 'package:sample_terminal_app/widgets/common_button.dart';
import 'package:stacked/stacked.dart';

import 'user_list_view_model.dart';

class UserListScreen extends StatelessWidget {
  final bool isSelectMode;

  const UserListScreen({Key? key, this.isSelectMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserListViewModel>.reactive(
      onModelReady: (model) async {
        model.init(isSelectMode);
      },
      viewModelBuilder: () => UserListViewModel(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () {
            Get.back();
            return Future.value(true);
          },
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
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      alignment: FractionalOffset.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 25,
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "Saved List",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          _buildUsersList(model),
                          _buildSubmitButton(model),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                visible: model.selectedUserInfo != null ? false : true,
                child: FloatingActionButton.extended(
                  focusColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  label: Row(
                    children: const [
                      Icon(
                        Icons.add,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add New',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onPressed: () async {
                    bool? isDataUpdated = await Get.to(
                        () => const AddNewUserHostInfo(),
                        opaque: false,
                        fullscreenDialog: true);
                    if (isDataUpdated != null) {
                      if (isDataUpdated) {
                        model.fetchUsersSaved();
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildUsersList(UserListViewModel model) {
    if (model.isBusy) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        alignment: FractionalOffset.center,
        child: const CupertinoActivityIndicator(
          color: ColorRes.black,
        ),
      );
    }
    if (model.savedUserList.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: model.savedUserList.length,
        itemBuilder: (context, index) {
          UserInfo userInfo = model.savedUserList[index];
          if (model.isSelectMode) {
            return eachSavedItemInSelectMode(userInfo, model, index);
          } else {
            return eachSavedItem(userInfo, model);
          }
        },
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 65),
      );
    } else {
      return const Center(
        child: Text(
          "No Results Found",
          style: TextStyle(color: ColorRes.black, fontSize: 14),
        ),
      );
    }
  }

  eachSavedItem(UserInfo userInfo, UserListViewModel model) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: ColorRes.textFieldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: FractionalOffset.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Text(
                    "Host Info",
                    style: CustomStyles.poppinsLight15
                        .copyWith(color: Colors.black),
                  ),
                ),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Text(
                    "${userInfo.hostname}",
                    style: CustomStyles.poppinsLight15
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Text("User name",
                      style: CustomStyles.poppinsLight15
                          .copyWith(color: Colors.black)),
                ),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    "${userInfo.uname}",
                    style: CustomStyles.poppinsLight15
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {
              model.deleteSavedItem(userInfo);
            },
          ),
        ],
      ),
    );
  }

  eachSavedItemInSelectMode(
      UserInfo userInfo, UserListViewModel model, int index) {
    return Container(
      color: index % 2 == 0
          ? ColorRes.profileDetailPageItemBg02
          : ColorRes.profileDetailPageItemBg01,
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: RadioListTile(
        value: index,
        dense: Get.width < 600 ? false : true,
        groupValue: model.selectedGroupValue,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (value) {
          model.onItemSelected(model.savedUserList[index], index);
        },
        title: Container(
          padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: FractionalOffset.centerLeft,
                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                child: Row(
                  children: [
                    Text(
                      "Host: ",
                      textAlign: TextAlign.left,
                      style: CustomStyles.poppinsLight15
                          .copyWith(color: ColorRes.black),
                    ),
                    Expanded(
                      child: Text(
                        "${userInfo.hostname}",
                        textAlign: TextAlign.left,
                        style: CustomStyles.poppinsLight15.copyWith(
                            color: ColorRes.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: FractionalOffset.centerLeft,
                padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
                child: Row(
                  children: [
                    Text(
                      "Username: ",
                      textAlign: TextAlign.left,
                      style: CustomStyles.poppinsLight15
                          .copyWith(color: ColorRes.black),
                    ),
                    Expanded(
                      child: Text(
                        "${userInfo.uname}",
                        textAlign: TextAlign.left,
                        style: CustomStyles.poppinsLight15.copyWith(
                            color: ColorRes.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSubmitButton(UserListViewModel model) {
    if (model.selectedUserInfo != null && !model.isBusy) {
      return Positioned(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 45,
            width: Get.width,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: CommonButton(
              buttonText: "Select",
              bgColorReceived: ColorRes.primaryColor,
              borderColorReceived: ColorRes.primaryColor,
              textColorReceived: ColorRes.white,
              buttonHandler: () {
                if (!model.isBusy) {
                  model.selectUser();
                }
              },
              borderRadiusReceived: 10,
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
