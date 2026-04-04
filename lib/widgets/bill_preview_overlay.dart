import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/widgets/bill_receipt_widget.dart';
import 'package:share_plus/share_plus.dart';

class BillPreviewOverlay extends StatefulWidget {
  const BillPreviewOverlay({required this.bill, super.key});
  final BillModel bill;

  @override
  State<BillPreviewOverlay> createState() => _BillPreviewOverlayState();
}

class _BillPreviewOverlayState extends State<BillPreviewOverlay> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isCapturing = false;

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final RenderRepaintBoundary boundary =
          _receiptKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final String shareText =
          '${L10n.of(context).get('share_bill')} - ${widget.bill.billNumber}';
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final Directory dir = await getApplicationDocumentsDirectory();
      final String fileName =
          'rent_bill_${widget.bill.billNumber.replaceAll('/', '_')}.png';
      final File file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(files: <XFile>[XFile(file.path)], text: shareText),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${L10n.of(context).get('share_failed')}: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(l10n.get('bill_preview')),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: _isCapturing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share_outlined),
            onPressed: _isCapturing ? null : _captureAndShare,
            tooltip: l10n.get('share'),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: RepaintBoundary(
            key: _receiptKey,
            child: BillReceiptWidget(bill: widget.bill),
          ),
        ),
      ),
    );
  }
}
