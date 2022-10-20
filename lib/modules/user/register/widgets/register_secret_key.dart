import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/user/register/register_provider.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/toast_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RegisterSecretKey extends StatefulWidget {
  RegisterSecretKey({Key? key, required this.provider}) : super(key: key);
  RegisterProvider provider;

  @override
  State<RegisterSecretKey> createState() => _RegisterSecretKeyState();
}

class _RegisterSecretKeyState extends ProviderState<RegisterSecretKey, RegisterProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildMessage(),
            _buildKey(),
            Gaps.vGap10,
            _buildActionItem(S.current.registerSecretKeyCopy, ZPassIcons.icCopy, _onCopySecretKeyTap),
            Gaps.vGap15,
            _buildActionItem(S.current.registerSecretKeySave, ZPassIcons.icDownload, _onSaveSecretKeyTap),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.registerSecretKeyTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF16181A),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            S.current.registerSecretKeyMessage,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF16181A),
              height: 1.3
            ),
          ),
        )
      ],
    );
  }

  Widget _buildKey() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFFF6F6F6),
      ),
      child: SelectableText(
        provider.secretKey,
        style: const TextStyle(
            color: Color(0xFFFF7019), fontSize: 16, fontWeight: FontWeight.w500,
          height: 1.6
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon, GestureTapCallback event) {
    return GestureDetector(
      onTap: event,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4954FF)),
          borderRadius: BorderRadius.circular(7.5)
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF16181A),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 20, color: const Color(0xFF4954FF),),
            )
          ],
        ),
      ),
    );
  }

  /// 构建pdf布局样式
  _buildPDFWidget(pw.Image logo) {
    PdfColor color = const PdfColor.fromInt(0xFF4342FF);
    PdfColor subColor = const PdfColor.fromInt(0xFF5273FE);
    return pw.Column(
      children: [
        /// logo
        pw.Container(
          width: double.infinity,
          alignment: pw.Alignment.centerLeft,
          child: pw.SizedBox(
              width: 152,
              height: 62,
            child: logo
          ),
        ),
        /// title
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 20),
          child: pw.Text(S.current.registerSecretKeyPDFTitle, style: const pw.TextStyle(color: PdfColor.fromInt(0xFFFF0000), fontSize: 18)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(20),
            color: const PdfColor.fromInt(0xFFFAF7F7)
          ),
          child: pw.Column(
            children: [
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.symmetric(vertical: 15),
                child: pw.Text(
                    S.current.registerSecretKeyPDFAccountDetail,
                    style: pw.TextStyle(color: color, fontSize: 18),
                ),
              ),
              pw.SizedBox(height: 10),
              /// email
              pw.Row(children: [
                pw.Text("${S.current.email}:", style: pw.TextStyle(color: subColor, fontSize: 15)),
                pw.SizedBox(width: 10),
                pw.Expanded(child: pw.Text(provider.email, style: pw.TextStyle(color: color, fontSize: 15))),
              ]),
              pw.SizedBox(height: 10),
              /// secret key
              pw.Row(
                children: [
                  pw.Text("${S.current.registerSecretKeyPDFKey}:", style: pw.TextStyle(color: subColor, fontSize: 15)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: pw.Text(provider.secretKey, style: pw.TextStyle(color: color, fontSize: 15))),
                ],
              ),
            ],
          )
        ),
        pw.Container(
            padding: const pw.EdgeInsets.all(18),
            margin: const pw.EdgeInsets.only(top: 50),
            decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(20),
                color: const PdfColor.fromInt(0xFFFAF7F7)
            ),
            child: pw.Column(
                children: [
                  pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.only(bottom: 15),
                    child: pw.Text(S.current.registerSecretKeyPDFQuickLoginCode, style: pw.TextStyle(color: color, fontSize: 18)),
                  ),
                  /// qrcode
                  pw.Row(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          color: const PdfColor.fromInt(0xFFFFFFFF),
                          child: pw.BarcodeWidget(data: provider.buildQRCodeUrl, width: 90.0, height: 90.0, barcode: pw.Barcode.qrCode()),
                        ),
                        pw.Expanded(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 15),
                            child: pw.Text(S.current.registerSecretKeyPDFScanCodeTips, style: pw.TextStyle(color: subColor, fontSize: 15)),
                          ),
                        ),
                      ]
                  ),
                ]
            )
        ),
        pw.Spacer(),
        /// zpass邮箱和官网
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(AppConfig.zpassWebsite, style: pw.TextStyle(fontSize: 13, color: color)),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text("${S.current.registerSecretKeyPDFContact}: ${AppConfig.zpassEmail}", style: pw.TextStyle(fontSize: 13, color: color)),
        ),
      ]
    );
  }

  _onCopySecretKeyTap() {
    Clipboard.setData(ClipboardData(text: provider.secretKey));
    Toast.show(S.current.registerSecretKeyCopyTips);
  }

  _onSaveSecretKeyTap() async {
    final pdf = await _createPDF();
    final file = await _getTempFile();
    await file?.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file!.path)]);
    file.delete();
  }

  Future<pw.Document> _createPDF() async {
    final pdf = pw.Document();
    final logoFile = await rootBundle.load("assets/images/logo_pdf.png");
    final logo = pw.Image(pw.MemoryImage(logoFile.buffer.asUint8List()));
    final page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return _buildPDFWidget(logo);
      }
    );
    pdf.addPage(page);
    return pdf;
  }

  Future<File?> _getTempFile() async {
    final output = await getTemporaryDirectory();
    return Future.value(File("${output.path}/zpass-secret-key.pdf"));
  }

  @override
  RegisterProvider prepareProvider() {
    return widget.provider;
  }
}
