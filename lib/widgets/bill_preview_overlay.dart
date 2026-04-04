import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/widgets/bill_receipt_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class BillPreviewOverlay extends StatefulWidget {
  final BillModel bill;
  const BillPreviewOverlay({super.key, required this.bill});

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
      final boundary =
          _receiptKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'rent_bill_${widget.bill.billNumber.replaceAll('/', '_')}.png';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Rent Bill - ${widget.bill.billNumber}',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Bill Preview'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: _isCapturing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share_outlined),
            onPressed: _isCapturing ? null : _captureAndShare,
            tooltip: 'Share',
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
