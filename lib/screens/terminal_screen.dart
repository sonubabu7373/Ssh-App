import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xterm/xterm.dart';

class TerminalScreen extends StatefulWidget {
  final SSHClient sshClient;

  const TerminalScreen({Key? key, required this.sshClient}) : super(key: key);

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late final terminal = Terminal();
  var title = "Terminal";

  @override
  void initState() {
    super.initState();
    initTerminal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 0),
        child: Container(
          color: Colors.blue,
        ),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              height: 50,
              padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              child: Row(
                children: [
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.black,
            ),
            Expanded(
              child: TerminalView(terminal),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initTerminal() async {
    terminal.write('Connecting...\r\n');

    final session = await widget.sshClient.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    terminal.write('Connected\r\n');

    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);

    terminal.onTitleChange = (title) {
      setState(() => this.title = title);
    };

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(utf8.encode(data) as Uint8List);
    };

    session.stdout
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .listen(terminal.write);
  }
}
