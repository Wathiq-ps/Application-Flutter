import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_icon_label_trigger.dart';

class OwnerFormInputCard extends StatefulWidget {
  const OwnerFormInputCard({
    super.key,
    required this.label,
    required this.value,
    required this.widthScale,
    this.actionIcon,
    this.actionLabel,
    this.switchIconText = true,
    this.onEdit,
    this.valueMaxLines = 1,
    this.suffixText,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconWidth = 12,
    this.suffixIconHeight = 12,
    this.actionIconWidth = 12,
    this.actionIconHeight = 12,
    // Label typography controls.
    this.labelFontSize = 12,
    this.labelFontWeight = FontWeight.w700,
    this.labelColor,
    // Value typography controls.
    this.valueFontSize = 16,
    this.valueFontWeight = FontWeight.w500,
    this.valueColor,
    // Inline value editing.
    this.isEditable = false,
    this.onValueChanged,
    this.keyboardType,
    this.inputFormatters,
    this.editHintText,
  });

  final String label;
  final String value;
  final double widthScale;

  // Top Action Parameters
  final String? actionIcon;
  final String? actionLabel;
  final bool switchIconText;
  final VoidCallback? onEdit;
  final double actionIconWidth;
  final double actionIconHeight;

  // Second Row Parameters
  final int valueMaxLines;
  final String? suffixText;
  final String? suffixIcon;
  final Widget? suffixWidget;
  final double suffixIconWidth;
  final double suffixIconHeight;

  // Label typography.
  final double labelFontSize;
  final FontWeight labelFontWeight;
  final Color? labelColor;

  // Value typography.
  final double valueFontSize;
  final FontWeight valueFontWeight;
  final Color? valueColor;

  /// When true, tapping the value switches it into an editable text field.
  /// Editing is committed via [onValueChanged] on submit or on losing focus.
  final bool isEditable;
  final ValueChanged<String>? onValueChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? editHintText;

  @override
  State<OwnerFormInputCard> createState() => _OwnerFormInputCardState();
}

class _OwnerFormInputCardState extends State<OwnerFormInputCard> {
  bool _isEditing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant OwnerFormInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _commitEdit();
    }
  }

  void _startEditing() {
    if (!widget.isEditable) return;
    setState(() {
      _isEditing = true;
      _controller.text = widget.value;
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _commitEdit() {
    if (!_isEditing) return;
    final String newValue = _controller.text.trim();
    setState(() => _isEditing = false);
    if (newValue.isNotEmpty && newValue != widget.value) {
      widget.onValueChanged?.call(newValue);
    } else {
      _controller.text = widget.value;
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _controller.text = widget.value;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final double ws = widget.widthScale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15 * ws),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16 * ws),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Label & AppLabelIconTrigger
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.labelColor ?? AppColors.primary,
                  fontSize: widget.labelFontSize * ws,
                  fontWeight: widget.labelFontWeight,
                  height: 16 / 12,
                  letterSpacing: 0.24,
                ),
              ),
              if (widget.onEdit != null && widget.actionIcon != null)
                AppLabelIconTrigger(
                  widthScale: ws,
                  label: widget.actionLabel ?? AppStrings.editAction,
                  icon: widget.actionIcon!,
                  onTap: widget.onEdit,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  iconColor: AppColors.primary,
                  iconWidth: widget.actionIconWidth,
                  iconHeight: widget.actionIconHeight,
                  switchIconText: widget.switchIconText,
                ),
            ],
          ),

          SizedBox(height: 10 * ws),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.isEditable ? _startEditing : null,
                  behavior: HitTestBehavior.opaque,
                  child: _isEditing
                      ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLines: widget.valueMaxLines,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    style: TextStyle(
                      color: widget.valueColor ?? AppColors.primary,
                      fontSize: widget.valueFontSize * ws,
                      fontWeight: widget.valueFontWeight,
                      height: 24 / 16,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: widget.editHintText,
                    ),
                    onSubmitted: (_) => _commitEdit(),
                    onTapOutside: (_) => _commitEdit(),
                  )
                      : Text(
                    widget.value,
                    maxLines: widget.valueMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.valueColor ?? AppColors.primary,
                      fontSize: widget.valueFontSize * ws,
                      fontWeight: widget.valueFontWeight,
                      height: 24 / 16,
                    ),
                  ),
                ),
              ),

              if (_isEditing) ...[
                SizedBox(width: 8 * ws),
                GestureDetector(
                  onTap: _commitEdit,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.check_rounded,
                    size: 18 * ws,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(width: 6 * ws),
                GestureDetector(
                  onTap: _cancelEdit,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close_rounded,
                    size: 18 * ws,
                    color: AppColors.error,
                  ),
                ),
              ] else ...[
                if (widget.suffixWidget != null) ...[
                  SizedBox(width: 8 * ws),
                  widget.suffixWidget!,
                ] else if (widget.suffixIcon != null) ...[
                  SizedBox(width: 8 * ws),
                  SvgPicture.asset(
                    widget.suffixIcon!,
                    width: widget.suffixIconWidth * ws,
                    height: widget.suffixIconHeight * ws,
                  ),
                ] else if (widget.suffixText != null) ...[
                  SizedBox(width: 8 * ws),
                  Text(
                    widget.suffixText!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14 * ws,
                      fontWeight: FontWeight.w700,
                      height: 20 / 14,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}