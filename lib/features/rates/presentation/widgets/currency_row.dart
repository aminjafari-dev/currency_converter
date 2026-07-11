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
  /// Max width reserved for the amount field on each currency row.
  static const double _amountFieldWidth = 160;

  /// Preferred numeral size while the value still fits (matches [AppTextStyles.numeralXl]).
  static const double _maxAmountFontSize = 40;

  /// Floor size so very large amounts remain readable instead of vanishing.
  static const double _minAmountFontSize = 14;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /// Tracks focus so we can highlight the active row and avoid overwriting
  /// the user's in-progress keystrokes when other amounts update.
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amountText);
    // Rebuild on every keystroke so the amount font can shrink/grow with length.
    // Useful when typing 1000000 — the numeral stays inside [_amountFieldWidth].
    _controller.addListener(_onAmountTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  /// Triggers a rebuild whenever the amount text changes (typing or BLoC sync).
  /// Example: user appends a digit → font size is recalculated in [build].
  void _onAmountTextChanged() {
    if (mounted) setState(() {});
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
      // Detach listener while assigning so we do not call setState during
      // didUpdateWidget; the upcoming build already reads the new text.
      _controller.removeListener(_onAmountTextChanged);
      _controller.text = widget.amountText;
      _controller.addListener(_onAmountTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onAmountTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Picks the largest font size that still fits [text] inside [maxWidth].
  ///
  /// Starts at [_maxAmountFontSize] and steps down until the measured width
  /// fits, or until [_minAmountFontSize]. Empty fields use a placeholder "0"
  /// so the caret row keeps a stable height.
  ///
  /// Example: `"1,240.00"` → 40; `"12,345,678.90"` → ~22; huge values → 14.
  double _adaptiveAmountFontSize(String text, Color color) {
    final measureText = text.isEmpty ? '0' : text;
    var fontSize = _maxAmountFontSize;

    // Shrink one point at a time until the mono numeral fits the field width.
    // Useful for long converted amounts that would otherwise clip or overflow.
    while (fontSize > _minAmountFontSize) {
      final style = AppTextStyles.numeralXl(color: color).copyWith(
        fontSize: fontSize,
        height: 1.2,
        letterSpacing: -0.04 * fontSize,
      );
      final painter = TextPainter(
        text: TextSpan(text: measureText, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      if (painter.width <= _amountFieldWidth) {
        return fontSize;
      }
      fontSize -= 1;
    }

    return _minAmountFontSize;
  }

  @override
  Widget build(BuildContext context) {
    // Green border only while this row's amount field is focused.
    // Useful so tapping EUR clears the highlight from USD immediately.
    final isHighlighted = _hasFocus;
    final amountColor = isHighlighted
        ? AppColors.primaryFixed
        : AppColors.onSurfaceVariant;
    final amountFontSize =
        _adaptiveAmountFontSize(_controller.text, amountColor);

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
                width: _amountFieldWidth,
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
                  // Scale numeralXl down when the typed/converted value no longer
                  // fits at 40px — keeps short amounts bold and long ones readable.
                  style: AppTextStyles.numeralXl(color: amountColor).copyWith(
                    fontSize: amountFontSize,
                    height: 1.2,
                    letterSpacing: -0.04 * amountFontSize,
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
