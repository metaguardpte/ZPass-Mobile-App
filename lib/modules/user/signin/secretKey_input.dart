import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/scanner/scanner.dart';
import 'package:zpass/routers/fluro_navigator.dart';

import '../../../util/callback_funcation.dart';
import '../../../widgets/load_image.dart';

class SecretKey extends StatefulWidget {
  const SecretKey({Key? key,this.onChange}) : super(key: key);
  final FunctionCallback<String>? onChange;
  @override
  State<SecretKey> createState() => _SecretKeyState();
}

class _SecretKeyState extends State<SecretKey> {
  getQRcode() {
    if (kDebugMode) {
      print('get QrCode ');
    }
    NavigatorUtils.pushResult(context, RouterScanner.scanner, (p0){
      print('p0');
      print(p0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged:(value) {
        widget.onChange?.call(value);
      },
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixIcon: IconButton(
              onPressed: getQRcode,
              alignment: Alignment.centerRight,
              icon: const LoadAssetImage(
                'signin/qrcode@2x',
                width: 20,
                height: 20,
              )),
          icon: const LoadAssetImage(
            'signin/safe@2x',
            width: 20,
            height: 20,
          ),
          hintText: 'Secret Key',
          hintStyle:const TextStyle(color: Color.fromRGBO(147, 151, 157, 1)),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          )),
    );
  }
}
