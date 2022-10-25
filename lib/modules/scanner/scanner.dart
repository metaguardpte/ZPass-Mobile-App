import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpass/modules/scanner/switch_flash.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zxing2/qrcode.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerMode extends StatefulWidget {
  const ScannerMode({Key? key}) : super(key: key);

  @override
  _ScannerModeState createState() => _ScannerModeState();
}

class _ScannerModeState extends State<ScannerMode> {
  // MobileScannerController cameraController = MobileScannerController();
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      NavigatorUtils.goBack(context);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('no Permission')),
      // );
    }
  }

  final ImagePicker picker = ImagePicker();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;

  _handelClose() {
    BackToParentPage(null);
  }

  _checkIOSPhotosPermission() async {
    if (Device.isAndroid) return true;
    final status = await Permission.photos.request();
    if (status == PermissionStatus.granted) return true;
    Toast.showMiddleToast(
      'No Photos Permission , Please go to the system settings to open the permission',
      height: 180,
      type: ToastType.error,
    );
    return false;
  }
  _handelPickImage() async{
    bool isGranted = await _checkIOSPhotosPermission();
    if (!isGranted) return;
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery,
        maxHeight: 2000,
        maxWidth: 1000
    );
    if(xfile == null) return ;
    var image = img.decodeImage(File(xfile.path).readAsBytesSync())!;
    print(image.width);
    print(image.height);
    print('-----------------------------image');
    LuminanceSource source = RGBLuminanceSource(
        image.width,
        image.height,
        image.getBytes(format: img.Format.abgr).buffer.asInt32List()
    );
    var bitmap = BinaryBitmap(HybridBinarizer(source));
    print(bitmap);
    var reader = QRCodeReader();
    try {
      var result = reader.decode(bitmap);
      BackToParentPage(result.text);
    } catch (e) {
      print('no QR');
    }
  }
  void BackToParentPage(data) {
    controller?.stopCamera();
    controller?.dispose();
    if (data == null) {
      NavigatorUtils.goBack(context);
      return;
    }
    NavigatorUtils.goBackWithParams(context, {"data": data});
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    if (Device.isAndroid) {
      await controller.resumeCamera();
    }
    controller.scannedDataStream.listen((Barcode? scanData) {
      if (scanData?.code != null) {
        BackToParentPage(scanData?.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Colors.black,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 2,
                cutOutSize: 260,
                cutOutBottomOffset: 100),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
        ),
        GestureDetector(
          onTap: _handelClose,
          child: Container(
            // color: Colors.red,
            margin: const EdgeInsets.fromLTRB(25.5, 25, 0, 0),
            width: 40,
            height: 40,
            child:
                const Icon(ZPassIcons.icClose,color: Colors.white,size: 24,),
          ),
        ),
        Positioned(
            right: 100,
            bottom: 70,
            child: GestureDetector(
              onTap: _handelPickImage,
              child: Container(
                alignment: Alignment.topRight,
                width: 30,
                height: 30,
                child: const LoadAssetImage('signin/album@2x',
                    width: 26, height: 26),
              ),
            )),
        Positioned(
            left: 100,
            bottom: 70,
            child:SwitchFlash(
              switchFlash: (type){
                controller?.toggleFlash();
              },
            )
        ),
      ],
    ));
  }
}
