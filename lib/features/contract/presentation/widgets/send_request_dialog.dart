import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_icons.dart';
import '../../../../core/extensions/media_query_extensions.dart';

class SendRequestResult {
  final String note;
  final String? termStart;
  final String? termEnd;

  const SendRequestResult({
    required this.note,
    this.termStart,
    this.termEnd,
  });
}

class SendRequestDialog extends StatefulWidget {
  const SendRequestDialog({
    super.key,
    this.onSend,
    this.isRent = false,
  });

  final Future<void> Function(
    String note,
    String? termStart,
    String? termEnd,
  )? onSend;
  final bool isRent;

  static Future<SendRequestResult?> show(
    BuildContext context, {
    bool isRent = false,
    Future<void> Function(
      String note,
      String? termStart,
      String? termEnd,
    )? onSend,
  }) {
    return showDialog<SendRequestResult>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0xA100113A),
      builder: (_) => SendRequestDialog(
        isRent: isRent,
        onSend: onSend,
      ),
    );
  }

  @override
  State<SendRequestDialog> createState() => _SendRequestDialogState();
}

class _SendRequestDialogState extends State<SendRequestDialog> {
  late final TextEditingController _noteController;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _dateError;
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

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00113A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF00113A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _dateError = null;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final now = DateTime.now();
    final firstAllowed = _startDate ?? now;
    final initial = _endDate ?? (_startDate?.add(const Duration(days: 30)) ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstAllowed) ? firstAllowed : initial,
      firstDate: firstAllowed,
      lastDate: now.add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00113A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF00113A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _dateError = null;
      });
    }
  }

  Widget _buildDatePickerCard({
    required String label,
    required String dateText,
    required bool isSelected,
    required VoidCallback onTap,
    required double widthScale,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF8C95A6),
                  fontSize: 13 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10 * widthScale,
              vertical: 10 * widthScale,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14 * widthScale),
              border: Border.all(
                color: _dateError != null && !isSelected
                    ? Colors.red.shade400
                    : const Color(0xFFCBD5E1),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dateText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF00113A)
                              : const Color(0xFF8C95A6),
                          fontSize: 13 * widthScale,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 15 * widthScale,
                      color: const Color(0xFF00113A),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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

              // ── Rental Duration (Rent Only) ──
              if (widget.isRent) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Rental Duration',
                    style: TextStyle(
                      color: const Color(0xFF00113A),
                      fontSize: 13 * widthScale,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 8 * widthScale),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerCard(
                        label: 'Term Start',
                        dateText: _startDate != null
                            ? _formatDate(_startDate!)
                            : 'Start date',
                        isSelected: _startDate != null,
                        onTap: () => _pickStartDate(context),
                        widthScale: widthScale,
                      ),
                    ),
                    SizedBox(width: 10 * widthScale),
                    Expanded(
                      child: _buildDatePickerCard(
                        label: 'Term End',
                        dateText: _endDate != null
                            ? _formatDate(_endDate!)
                            : 'End date',
                        isSelected: _endDate != null,
                        onTap: () => _pickEndDate(context),
                        widthScale: widthScale,
                      ),
                    ),
                  ],
                ),
                if (_dateError != null) ...[
                  SizedBox(height: 6 * widthScale),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _dateError!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 11 * widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 14 * widthScale),
              ],

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
                  "Don't write more than 100 characters",
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
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00113A),
                          side: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16 * widthScale),
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
                                if (widget.isRent) {
                                  if (_startDate == null || _endDate == null) {
                                    setState(() {
                                      _dateError =
                                          'Please select both start and end dates';
                                    });
                                    return;
                                  }
                                  if (_endDate!.isBefore(_startDate!)) {
                                    setState(() {
                                      _dateError =
                                          'End date must be after start date';
                                    });
                                    return;
                                  }
                                }

                                final navigator = Navigator.of(context);
                                final note = _noteController.text.trim();
                                final termStart = _startDate != null
                                    ? _formatDate(_startDate!)
                                    : null;
                                final termEnd = _endDate != null
                                    ? _formatDate(_endDate!)
                                    : null;

                                final result = SendRequestResult(
                                  note: note,
                                  termStart: termStart,
                                  termEnd: termEnd,
                                );

                                if (widget.onSend != null) {
                                  setState(() => _isLoading = true);
                                  try {
                                    await widget.onSend!(
                                      note,
                                      termStart,
                                      termEnd,
                                    );
                                    if (mounted) navigator.pop(result);
                                  } catch (_) {
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                } else {
                                  navigator.pop(result);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00113A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16 * widthScale),
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
      ),
    );
  }
}
