import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_icons.dart';
import '../../../../core/extensions/media_query_extensions.dart';

class SendRequestDialog extends StatefulWidget {
  const SendRequestDialog({
    super.key,
    this.onSend,
  });

  final Future<void> Function(String note)? onSend;

  static Future<String?> show(
    BuildContext context, {
    Future<void> Function(String note)? onSend,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0xA100113A),
      builder: (_) => SendRequestDialog(onSend: onSend),
    );
  }

  @override
  State<SendRequestDialog> createState() => _SendRequestDialogState();
}

class _SendRequestDialogState extends State<SendRequestDialog> {
  late final TextEditingController _noteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    final double widthScale = context.screenWidth / figmaWidth;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 22 * widthScale,
          vertical: 24 * widthScale,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24 * widthScale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Top Icon Badge ──
            Container(
              width: 58 * widthScale,
              height: 58 * widthScale,
              decoration: const BoxDecoration(
                color: Color(0xFFDCE5FA),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppIcons.send_request,
                width: 24 * widthScale,
                height: 24 * widthScale,
              ),
            ),

            SizedBox(height: 16 * widthScale),

            // ── Title ──
            Text(
              'Send Request',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF00113A),
                fontSize: 20 * widthScale,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),

            SizedBox(height: 8 * widthScale),

            // ── Subtitle ──
            Text(
              'Are you sure you’d like to Send Request?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF00113A),
                fontSize: 14 * widthScale,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 18 * widthScale),

            // ── Note Input Field ──
            Container(
              height: 96 * widthScale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16 * widthScale),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                maxLength: 100,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                buildCounter: (
                  _, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) =>
                    null,
                style: TextStyle(
                  color: const Color(0xFF00113A),
                  fontSize: 15 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Note (op)',
                  hintStyle: TextStyle(
                    color: const Color(0xFF00113A),
                    fontSize: 16 * widthScale,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16 * widthScale,
                    vertical: 14 * widthScale,
                  ),
                ),
              ),
            ),

            SizedBox(height: 6 * widthScale),

            // ── Helper Text ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Don't write more than100 characters",
                style: TextStyle(
                  color: const Color(0xFF8C95A6),
                  fontSize: 11 * widthScale,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 20 * widthScale),

            // ── Actions Row ──
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 50 * widthScale,
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00113A),
                        side: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16 * widthScale),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: const Color(0xFF00113A),
                          fontSize: 16 * widthScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12 * widthScale),

                // Send Button
                Expanded(
                  child: SizedBox(
                    height: 50 * widthScale,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final note = _noteController.text.trim();
                              if (widget.onSend != null) {
                                setState(() => _isLoading = true);
                                try {
                                  await widget.onSend!(note);
                                  if (mounted) navigator.pop(note);
                                } catch (_) {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              } else {
                                navigator.pop(note);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00113A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16 * widthScale),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 22 * widthScale,
                              height: 22 * widthScale,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * widthScale,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
