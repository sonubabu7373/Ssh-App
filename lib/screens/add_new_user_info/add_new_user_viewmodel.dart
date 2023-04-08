import 'package:flutter/material.dart';
import 'package:sample_terminal_app/utils/db_helper.dart';
import 'package:sample_terminal_app/widgets/common_methods.dart';
import 'package:stacked/stacked.dart';

class AddNewUserViewModel extends BaseViewModel {
  final dbHelper = DatabaseHelper.instance;
  TextEditingController hostNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  bool isNewDataAdded = false;

  void init() {}

  void createUserInfo() async {
    setBusy(true);
    notifyListeners();
    try {
      Map<String, dynamic> row = {
        DatabaseHelper.columnHost: hostNameController.text.trim(),
        DatabaseHelper.columnUname: userNameController.text.trim()
      };
      final id = await dbHelper.insert(row);
      showValidationToast("Added Successfully");
      isNewDataAdded = true;
      debugPrint('inserted row id: $id');
      hostNameController.text = "";
      userNameController.text = "";
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setBusy(false);
      notifyListeners();
      debugPrint(e.toString());
    }
  }
}
