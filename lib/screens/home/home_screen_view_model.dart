import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_terminal_app/models/unserinfo.dart';
import 'package:sample_terminal_app/screens/terminal_screen.dart';
import 'package:sample_terminal_app/screens/user_list/user_list_screen.dart';
import 'package:sample_terminal_app/widgets/common_methods.dart';
import 'package:stacked/stacked.dart';

class HomeScreenViewModel extends BaseViewModel {
  File? filePicked;
  SSHClient? client;
  UserInfo? selectedUserInfo;
  bool obs = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController hostNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  DateTime? currentBackPressTime;

  void init() {}

  void chooseKeyFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        filePicked = File(result.files.single.path!);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("**************");
    }
  }

  void selectSavedUserCredential() async {
    try {
      Map<String, dynamic>? dataReceived =
          await Get.to(() => const UserListScreen(isSelectMode: true));

      if (dataReceived != null) {
        if (dataReceived.containsKey("selected_user")) {
          if (dataReceived["selected_user"] != null) {
            selectedUserInfo = dataReceived["selected_user"];
            hostNameController.text = selectedUserInfo!.hostname!.trim();
            userNameController.text = selectedUserInfo!.uname!.trim();
            passwordController.text = "";
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  togglePasswordVisibility() {
    obs = !obs;
    notifyListeners();
  }

  void connectWithKey() async {
    if (isBusy) {
      return;
    } else if (hostNameController.text.trim().isEmpty) {
      showValidationToast("Hostname can't be empty");
      return;
    } else if (userNameController.text.trim().isEmpty) {
      showValidationToast("Username can't be empty");
      return;
    } else {
      setBusy(true);
      if (filePicked != null) {
        try {
          final socket =
              await SSHSocket.connect(hostNameController.text.trim(), 22);
          client = SSHClient(
            socket,
            username: userNameController.text.trim(),
            //onPasswordRequest: () => password,
            identities: [
              // A single private key file may contain multiple keys.
              ...SSHKeyPair.fromPem(await filePicked!.readAsString())
            ],
          );

          if (client != null) {
            await client!.authenticated.then((value) async {
              debugPrint("${client!.remoteVersion}");
              setBusy(false);
              await Get.to(() => TerminalScreen(sshClient: client!))
                  ?.then((value) {
                client!.close();
              });
            });
          } else {
            debugPrint("Error SSH Client is null");
            showValidationToast(
                "Sorry authentication failed, please verify your credentials");
          }
        } catch (e) {
          debugPrint("SSHAuthAbortError in authentication ${e.toString()}");
          showValidationToast(
              "Sorry authentication failed, please verify your credentials");
        }
      }
      setBusy(false);
      notifyListeners();
    }
  }

  void connectWithPassword() async {
    if (isBusy) {
      return;
    } else if (hostNameController.text.trim().isEmpty) {
      showValidationToast("Hostname can't be empty");
      return;
    } else if (userNameController.text.trim().isEmpty) {
      showValidationToast("Username can't be empty");
      return;
    } else if (passwordController.text.trim().isEmpty) {
      showValidationToast("Password can't be empty");
      return;
    } else {
      setBusy(true);
      try {
        client = SSHClient(
            await SSHSocket.connect(hostNameController.text.trim(), 22),
            username: userNameController.text.trim(),
            onPasswordRequest: () => passwordController.text.trim());

        if (client != null) {
          await client!.authenticated.then((value) async {
            debugPrint("${client!.remoteVersion}");
            setBusy(false);
            await Get.to(() => TerminalScreen(sshClient: client!))
                ?.then((value) {
              client!.close();
            });
          });
        } else {
          setBusy(false);
          debugPrint("Error SSH Client is null");
          showValidationToast(
              "Sorry authentication failed, please verify your credentials");
        }
      } catch (e) {
        debugPrint("SSHAuthAbortError in authentication ${e.toString()}");
        showValidationToast(
            "Sorry authentication failed, please verify your credentials");
      }
      setBusy(false);
      notifyListeners();
    }
  }

  Future<bool> willPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showValidationToast("Please press back again to exit", duration: 1);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
