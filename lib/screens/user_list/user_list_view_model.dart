import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/models/unserinfo.dart';
import 'package:sample_terminal_app/utils/db_helper.dart';
import 'package:sample_terminal_app/widgets/common_methods.dart';
import 'package:stacked/stacked.dart';

class UserListViewModel extends BaseViewModel {
  final dbHelper = DatabaseHelper.instance;
  List<UserInfo> savedUserList = [];
  bool isSelectMode = false;
  int? selectedGroupValue;
  UserInfo? selectedUserInfo;

  void init(bool isSelectModeOrNot) async {
    isSelectMode = isSelectModeOrNot;
    await fetchUsersSaved();
  }

  Future<void> fetchUsersSaved() async {
    setBusy(true);
    try {
      final maps = await dbHelper.queryAllRows();
      if (maps != null) {
        savedUserList = List.generate(maps.length, (i) {
          return UserInfo(
            id: maps[i]['id'],
            uname: maps[i]['uname'],
            hostname: maps[i]['hostname'],
          );
        });
      }
      setBusy(false);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setBusy(false);
      notifyListeners();
    }
  }

  void onItemSelected(UserInfo userInfo, int index) {
    selectedUserInfo = userInfo;
    selectedGroupValue = index;
    notifyListeners();
  }

  void selectUser() {
    if (selectedUserInfo != null) {
      Map<String, dynamic> data = {};
      data['selected_user'] = selectedUserInfo;
      Get.back(result: data);
    } else {
      showValidationToast("Please select at-least one to continue");
    }
  }

  void deleteSavedItem(UserInfo userInfo) async {
    try {
      final obj = await dbHelper.deleteItem(userInfo.id!);
      if (obj != -1) {
        fetchUsersSaved();
      } else {
        showValidationToast("Unable to process your request");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
