import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Platform;

class QrcodeScanScreen extends StatefulWidget {
  const QrcodeScanScreen({Key? key}) : super(key: key);

  @override
  State<QrcodeScanScreen> createState() => _QrcodeScanScreenState();
}

class _QrcodeScanScreenState extends State<QrcodeScanScreen> {


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? barcode;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await qrViewController!.pauseCamera();
    }
    qrViewController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildQRView(context),
          _buildControlButtons(),
          _buildResultMessage()
        ],
      ),
    );
  }


  Widget _buildResultMessage() => Positioned(
    bottom: 22,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white24
      ),
      child: Text(
        barcode != null ? '${barcode?.code}' : "Escaneie o código!",
        maxLines: 3,
      ),
    ) ,
  );

  Widget _buildControlButtons() => Positioned(
      top : 32,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white24
        ),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: () async {
            await qrViewController?.toggleFlash();
            setState((){});
          }, icon: FutureBuilder(
            future: qrViewController?.getFlashStatus(),
            builder: (context, snapshot) {
              if(snapshot.hasData != null){
                return Icon(snapshot.data == true ? Icons.flash_off : Icons.flash_on);
              }else{
                return Container();
              }
            }
          )),
          IconButton(
            onPressed: () async {
              await qrViewController?.flipCamera();
              setState((){});
            },
            icon: FutureBuilder(
                      future: qrViewController?.  getCameraInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData != null) {
                          return Icon(Icons.switch_camera);
                        } else {
                          return Container();
                        }
                      }
          )),
        ],
      )
    ),
  );

  Widget _buildQRView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
        borderColor: Colors.amberAccent, borderRadius: 8, borderWidth: 8),
  );

  void onQRViewCreated(QRViewController qrViewController) {
    setState(() => this.qrViewController = qrViewController);

    qrViewController.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
    qrViewController.pauseCamera();
    qrViewController.resumeCamera();
  }

}
