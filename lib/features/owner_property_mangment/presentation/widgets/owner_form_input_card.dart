import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/core/widget/app_dropdown_option_tile.dart';

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
    this.labelFontSize = 12,
    this.labelFontWeight = FontWeight.w700,
    this.labelColor,
    this.valueFontSize = 16,
    this.valueFontWeight = FontWeight.w500,
    this.valueColor,
    this.isEditable = false,
    this.onValueChanged,
    this.keyboardType,
    this.inputFormatters,
    this.editHintText,
    this.dropdownOptions,
    this.onDropdownSelected,
    this.otherOptionLabel,
    this.enableOtherCustomInput = true,
    this.dropdownSheetTitle,
  }) : assert(
  !(isEditable && dropdownOptions != null),
  'A field cannot be both free-text editable and a dropdown at the same time.',
  );
  final String label;
  final String value;
  final double widthScale;
  final String? actionIcon;
  final String? actionLabel;
  final bool switchIconText;
  final VoidCallback? onEdit;
  final double actionIconWidth;
  final double actionIconHeight;
  final int valueMaxLines;
  final String? suffixText;
  final String? suffixIcon;
  final Widget? suffixWidget;
  final double suffixIconWidth;
  final double suffixIconHeight;
  final double labelFontSize;
  final FontWeight labelFontWeight;
  final Color? labelColor;
  final double valueFontSize;
  final FontWeight valueFontWeight;
  final Color? valueColor;
  final bool isEditable;
  final ValueChanged<String>? onValueChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? editHintText;
  final List<String>? dropdownOptions;
  final ValueChanged<String>? onDropdownSelected;
  final String? otherOptionLabel;
  final bool enableOtherCustomInput;
  final String? dropdownSheetTitle;
  bool get _isDropdown => dropdownOptions != null && dropdownOptions!.isNotEmpty;

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

  void _handleActionTap() {
    widget.onEdit?.call();
    if (widget._isDropdown) {
      _openDropdownPicker();
    } else if (widget.isEditable) {
      _startEditing();
    }
  }

  void _handleValueTap() {
    if (widget._isDropdown) {
      _openDropdownPicker();
    } else if (widget.isEditable) {
      _startEditing();
    }
  }

  Future<void> _openDropdownPicker() async {
    final double ws = widget.widthScale;
    final String otherLabel = widget.otherOptionLabel ?? AppStrings.propertyOther;
    final List<String> baseOptions = widget.dropdownOptions ?? const [];

    final bool valueIsCustom =
        widget.value.trim().isNotEmpty && !baseOptions.contains(widget.value);

    String? selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        final TextEditingController otherController = TextEditingController(
          text: valueIsCustom ? widget.value : '',
        );
        bool showOtherField = valueIsCustom;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22 * ws),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  20 * ws,
                  12 * ws,
                  20 * ws,
                  20 * ws,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36 * ws,
                        height: 4 * ws,
                        margin: EdgeInsets.only(bottom: 12 * ws),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Text(
                      widget.dropdownSheetTitle ?? widget.label,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16 * ws,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.24,
                      ),
                    ),
                    SizedBox(height: 12 * ws),

                    ...baseOptions.map((option) {
                      final bool isSelected =
                          !showOtherField && option == widget.value;
                      return AppDropdownOptionTile(
                        widthScale: ws,
                        label: option,
                        isSelected: isSelected,
                        onTap: () => Navigator.of(sheetContext).pop(option),
                      );
                    }),

                    if (widget.enableOtherCustomInput) ...[
                      AppDropdownOptionTile(
                        widthScale: ws,
                        label: otherLabel,
                        isSelected: showOtherField,
                        onTap: () =>
                            setSheetState(() => showOtherField = true),
                      ),
                      if (showOtherField) ...[
                        SizedBox(height: 8 * ws),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: otherController,
                                autofocus: true,
                                style: TextStyle(
                                  fontSize: 14 * ws,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: otherLabel,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12 * ws,
                                    vertical: 12 * ws,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10 * ws),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                ),
                                onSubmitted: (text) {
                                  final String trimmed = text.trim();
                                  if (trimmed.isNotEmpty) {
                                    Navigator.of(sheetContext).pop(trimmed);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8 * ws),
                            GestureDetector(
                              onTap: () {
                                final String trimmed =
                                otherController.text.trim();
                                if (trimmed.isNotEmpty) {
                                  Navigator.of(sheetContext).pop(trimmed);
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: EdgeInsets.all(10 * ws),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 16 * ws,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null && selected.trim().isNotEmpty) {
      widget.onDropdownSelected?.call(selected.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double ws = widget.widthScale;
    final bool isInteractiveValue = widget.isEditable || widget._isDropdown;

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
              if (widget.actionIcon != null)
                AppLabelIconTrigger(
                  widthScale: ws,
                  label: widget.actionLabel ?? AppStrings.editAction,
                  icon: widget.actionIcon!,
                  onTap: _handleActionTap,
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
                  onTap: isInteractiveValue ? _handleValueTap : null,
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
                  GestureDetector(
                    onTap: widget._isDropdown ? _openDropdownPicker : null,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      widget.suffixIcon!,
                      width: widget.suffixIconWidth * ws,
                      height: widget.suffixIconHeight * ws,
                    ),
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

