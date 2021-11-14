import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fqreader/fqreader.dart';
import 'package:flustars/flustars.dart';
import 'package:open_file/open_file.dart';
import 'package:med_cert/services/pdf_certificate_service.dart';
import 'package:med_cert/util/encryptioin.dart';

class QrReaderScreen extends StatefulWidget {
  const QrReaderScreen({Key? key}) : super(key: key);

  @override
  _QrReaderScreenState createState() => _QrReaderScreenState();
}

class _QrReaderScreenState extends State<QrReaderScreen> {
  late GlobalKey<ScanViewState> scanView;

  @override
  void initState() {
    super.initState();
    scanView = GlobalKey<ScanViewState>();
  }

  Future<void> _openFileFrom(String path) async {
    final _result =
        await OpenFile.open(path); //.then((value) => deleteFile(path));
  }

  Future<File> _localFile(String newPath) async {
    File newFile = File(newPath);
    return newFile;
  }

  Future<int> deleteFile(String newPath) async {
    try {
      final file = await _localFile(newPath);
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance();
    Size pictureSize = Size(
        ScreenUtil.getScreenW(context),
        ScreenUtil.getScreenH(context) -
            ScreenUtil.getStatusBarH(context) -
            75);

    Size scanSize = Size(ScreenUtil.getScreenW(context) * 0.8,
        ScreenUtil.getScreenW(context) * 0.8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Lee el QR del otro dispositivo",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Center(
                child: ScanView(
                  key: scanView,
                  scanAilgn: Alignment.center,
                  scanSize: pictureSize,
                  viewSize: scanSize,
                  maskColor: Colors.white,
                  devicePixelRatio: ScreenUtil.getScreenDensity(context),
                  onScan: (result) async {
                    String decrypted = EncryptionUtil.shared
                        .getDecryptedStringFrom(text: result.data);
                    final progress = ProgressHUD.of(context);
                    progress!.show();
                    String? pdfPath = await VaccinePDFService.shared
                        .getPDFVaccinationData(token: decrypted);
                    if (pdfPath != null) {
                      progress.dismiss();
                      setState(() {
                        _openFileFrom(pdfPath);
                      });
                    }
                    return false;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}