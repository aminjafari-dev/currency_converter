import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/widgets/currency_flag.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_text.dart';

/// Single currency row used on the Home list.
///
/// Every row shows an editable amount. Tapping the row focuses the field so
/// the keyboard opens immediately; other currencies realign via local conversion.
///
/// Example:
/// ```dart
/// CurrencyRow(
///   code: 'EUR',
///   name: 'Euro',
///   amountText: '1,142.30',
///   onAmountChanged: (value) {},
/// );
/// ```
class CurrencyRow extends StatefulWidget {
  final String code;
  final String name;
  final String amountText;
  final VoidCallback? onLongPress;
  final ValueChanged<String>? onAmountChanged;

  const CurrencyRow({
    super.key,
    required this.code,
    required this.name,
    required this.amountText,
    this.onLongPress,
    this.onAmountChanged,
  });

  @override
  State<CurrencyRow> createState() => _CurrencyRowState();
}

class _CurrencyRowState extends State<CurrencyRow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /// Tracks focus so we can highlight the active row and avoid overwriting
  /// the user's in-progress keystrokes when other amounts update.
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amountText);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    // Rebuild borders when focus changes; useful so the active input stands out.
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }
  }

  @override
  void didUpdateWidget(covariant CurrencyRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller from BLoC only when this field is not being typed into —
    // otherwise rebuilding after converting siblings would fight the keyboard.
    if (!_focusNode.hasFocus &&
        widget.amountText != oldWidget.amountText &&
        _controller.text != widget.amountText) {
      _controller.text = widget.amountText;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Green border only while this row's amount field is focused.
    // Useful so tapping EUR clears the highlight from USD immediately.
    final isHighlighted = _hasFocus;

    return Material(
      color: isHighlighted
          ? AppColors.surfaceContainer
          : AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: BorderSide(
          color: isHighlighted
              ? AppColors.primaryFixed
              : AppColors.surfaceContainerHighest,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        onTap: () {
          // Tap anywhere on the row opens the amount keyboard immediately.
          _focusNode.requestFocus();
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        },
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CurrencyFlag(code: widget.code, size: 48),
              GGap.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GText(
                      widget.code,
                      style: AppTextStyles.headlineMd(),
                    ),
                    GText(
                      widget.name.toUpperCase(),
                      style: AppTextStyles.labelSm(
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.right,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: AppTextStyles.numeralXl(
                    color: isHighlighted
                        ? AppColors.primaryFixed
                        : AppColors.onSurfaceVariant,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                  onChanged: widget.onAmountChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
