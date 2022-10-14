import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/scanner/switch_flash.dart';
import 'package:zpass/routers/fluro_navigator.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  final ImagePicker picker = ImagePicker();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;

  _handelClose() {
    BackToParentPage(null);
  }
  _handelPickImage() async{
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
    await controller.resumeCamera();
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
          color: Colors.cyan,
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
            margin: const EdgeInsets.fromLTRB(25.5, 11.5, 0, 0),
            width: 30,
            height: 30,
            child:
                const LoadAssetImage('signin/close@2x', width: 26, height: 26),
          ),
        ),
        Positioned(
            right: 105.5,
            top: 710,
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
            left: 105.5,
            top: 710,
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
