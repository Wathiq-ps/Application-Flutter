import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

Future<Uint8List?> showDrawSignatureDialog(BuildContext context) {
  return showDialog<Uint8List?>(
    context: context,
    barrierColor: const Color(0xA1001B4D),
    builder: (_) => const _DrawSignatureDialog(),
  );
}

class _DrawSignatureDialog extends StatefulWidget {
  const _DrawSignatureDialog();

  @override
  State<_DrawSignatureDialog> createState() => _DrawSignatureDialogState();
}

class _DrawSignatureDialogState extends State<_DrawSignatureDialog> {
  final List<Offset?> _points = <Offset?>[];
  final GlobalKey _boundaryKey = GlobalKey();

  void _clear() {
    setState(() {
      _points.clear();
    });
  }

  Future<void> _save() async {
    final hasSignature = _points.any((point) => point != null);

    if (!hasSignature) {
      Navigator.of(context).pop(null);
      return;
    }

    final renderObject = _boundaryKey.currentContext?.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      Navigator.of(context).pop(null);
      return;
    }

    try {
      final image = await renderObject.toImage(
        pixelRatio: 2.0,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      if (!mounted) {
        return;
      }

      if (byteData == null) {
        Navigator.of(context).pop(null);
        return;
      }

      Navigator.of(context).pop(
        byteData.buffer.asUint8List(),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthScale =
        context.screenWidth / 393.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20 * widthScale,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: const Color(
                0xB3C5C6CF,
              ), // rgba(197, 198, 207, 0.7)
              strokeWidth: 1,
              dashPattern: const [6, 4],
              radius: Radius.circular(
                8 * widthScale,
              ),
              padding: EdgeInsets.zero,
            ),
            child: Container(
              width: 354 * widthScale,
              height: 202 * widthScale,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  8 * widthScale,
                ),
              ),
              child: Stack(
                children: [
                  // Drawing Area
                  Positioned.fill(
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8 * widthScale,
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            setState(() {
                              _points.add(
                                details.localPosition,
                              );
                            });
                          },
                          onPanEnd: (_) {
                            setState(() {
                              _points.add(null);
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: CustomPaint(
                              painter: _SignaturePainter(_points),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Clear Action
                  Positioned(
                    left: 12 * widthScale,
                    bottom: 8 * widthScale,
                    child: GestureDetector(
                      onTap: _clear,
                      child: Padding(
                        padding: EdgeInsets.all(
                          4 * widthScale,
                        ),
                        child: Text(
                          AppStrings.clearSignature,
                          style: TextStyle(
                            color: const Color(0xFFBE1510),
                            fontSize: 9 * widthScale,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Alexandria',
                            letterSpacing: 0.24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Save Action
                  Positioned(
                    right: 12 * widthScale,
                    bottom: 8 * widthScale,
                    child: GestureDetector(
                      onTap: _save,
                      child: Padding(
                        padding: EdgeInsets.all(
                          4 * widthScale,
                        ),
                        child: Text(
                          AppStrings.editSignature,
                          style: TextStyle(
                            color: const Color(0xFF0A1F44),
                            fontSize: 9 * widthScale,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Alexandria',
                            letterSpacing: 0.24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    final Paint paint = Paint()
      ..color = const Color(0xFF00081E)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final Offset? start = points[i];
      final Offset? end = points[i + 1];

      if (start != null && end != null) {
        canvas.drawLine(
          start,
          end,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant _SignaturePainter oldDelegate,
      ) {
    return true;
  }
}