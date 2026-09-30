import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';


Future<Uint8List?> showDrawSignatureDialog(BuildContext context) {
  return showDialog<Uint8List?>(
    context: context,
    barrierColor: const Color(0xA1001B4D), // rgba(0,17,58,0.63)
    builder: (_) => const _DrawSignatureDialog(),
  );
}

class _DrawSignatureDialog extends StatefulWidget {
  const _DrawSignatureDialog();

  @override
  State<_DrawSignatureDialog> createState() => _DrawSignatureDialogState();
}

class _DrawSignatureDialogState extends State<_DrawSignatureDialog> {
  final List<Offset?> _points = [];
  final GlobalKey _boundaryKey = GlobalKey();

  void _clear() => setState(_points.clear);

  Future<void> _save() async {
    if (_points.where((p) => p != null).isEmpty) {
      Navigator.of(context).pop(null);
      return;
    }
    final boundary =
    _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    Navigator.of(context).pop(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    final double widthScale = MediaQuery.sizeOf(context).width / 393.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: _boundaryKey,
            child: Container(
              width: 354 * widthScale,
              height: 202 * widthScale,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: const Color(0xB3C5C6CF)),
                borderRadius: BorderRadius.circular(8 * widthScale),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox?;
                  final local = box?.globalToLocal(details.globalPosition);
                  setState(() => _points.add(local));
                },
                onPanEnd: (_) => setState(() => _points.add(null)),
                child: CustomPaint(
                  painter: _SignaturePainter(_points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          SizedBox(height: 12 * widthScale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _clear,
                child: Text(
                  AppStrings.clearSignature,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 9 * widthScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: _save,
                child: Text(
                  AppStrings.editSignature,
                  style: TextStyle(
                    color: const Color(0xFF0A1F44),
                    fontSize: 9 * widthScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter(this.points);
  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00081E)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}