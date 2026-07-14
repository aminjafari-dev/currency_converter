import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/widgets/currency_flag.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_text.dart';

/// Single currency row used on the Home list.
///
/// In normal mode every row shows an editable amount. Tapping focuses the
/// field; siblings realign via local conversion.
///
/// In edit mode ([isEditing] = true) the amount field is replaced by a remove
/// button and a drag handle so the user can delete or reorder cards.
///
/// Example:
/// ```dart
/// CurrencyRow(
///   code: 'EUR',
///   name: 'Euro',
///   amountText: '1,142.30',
///   isEditing: false,
///   onAmountChanged: (value) {},
/// );
///
/// // Edit mode — pass [dragIndex] for ReorderableDragStartListener:
/// CurrencyRow(
///   code: 'EUR',
///   name: 'Euro',
///   amountText: '1,142.30',
///   isEditing: true,
///   dragIndex: 0,
///   onRemove: () {},
/// );
/// ```
class CurrencyRow extends StatefulWidget {
  final String code;
  final String name;
  final String amountText;
  final VoidCallback? onLongPress;
  final ValueChanged<String>? onAmountChanged;

  /// When true, shows remove + drag icons instead of the amount field.
  final bool isEditing;

  /// Index required by [ReorderableDragStartListener] while editing.
  final int? dragIndex;

  /// Called when the user taps the remove icon in edit mode.
  final VoidCallback? onRemove;

  const CurrencyRow({
    super.key,
    required this.code,
    required this.name,
    required this.amountText,
    this.onLongPress,
    this.onAmountChanged,
    this.isEditing = false,
    this.dragIndex,
    this.onRemove,
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
    // Leaving edit mode or syncing from BLoC: keep controller in sync only when
    // this field is not being typed into — otherwise rebuilds fight the keyboard.
    if (!_focusNode.hasFocus &&
        widget.amountText != oldWidget.amountText &&
        _controller.text != widget.amountText) {
      // Detach listener while assigning so we do not call setState during
      // didUpdateWidget; the upcoming build already reads the new text.
      _controller.removeListener(_onAmountTextChanged);
      _controller.text = widget.amountText;
      _controller.addListener(_onAmountTextChanged);
    }

    // Entering edit mode — drop keyboard focus so drag/remove are the only actions.
    // Useful when the user taps the pen while an amount field is still focused.
    if (widget.isEditing && !oldWidget.isEditing && _focusNode.hasFocus) {
      _focusNode.unfocus();
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
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    // Persian (`fa`) is RTL — keep amounts physically left-aligned so rates
    // hug the outer edge instead of sitting toward the row center.
    final isPersian = Localizations.localeOf(context).languageCode == 'fa';
    // Green border only while this row's amount field is focused (not in edit mode).
    // Useful so tapping EUR clears the highlight from USD immediately.
    final isHighlighted = !widget.isEditing && _hasFocus;
    final amountColor =
        isHighlighted ? colors.primary : colors.onSurfaceVariant;
    final amountFontSize =
        _adaptiveAmountFontSize(_controller.text, amountColor);

    return Material(
      color:
          isHighlighted ? colors.surfaceContainer : colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: BorderSide(
          color:
              isHighlighted ? colors.primary : colors.surfaceContainerHighest,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        // In edit mode, taps do nothing — remove/drag icons own the interaction.
        onTap: widget.isEditing
            ? null
            : () {
                // Tap anywhere on the row opens the amount keyboard immediately.
                _focusNode.requestFocus();
                _controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controller.text.length,
                );
              },
        onLongPress: widget.isEditing ? null : widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Remove affordance — only visible while editing the list.
              // Useful so the user can delete a currency without swipe gestures.
              if (widget.isEditing) ...[
                IconButton(
                  tooltip: l10n.removeCurrency,
                  onPressed: widget.onRemove,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                  color: colors.error,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                GGap.hSm,
              ],
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
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Edit mode: drag handle. Normal mode: editable amount field.
              if (widget.isEditing)
                ReorderableDragStartListener(
                  index: widget.dragIndex ?? 0,
                  child: Tooltip(
                    message: l10n.reorderCurrency,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        Icons.drag_handle,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: _amountFieldWidth,
                  // Force LTR digit order; align left in Persian so amounts
                  // stick to the physical left edge of the amount column.
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textAlign: isPersian ? TextAlign.left : TextAlign.right,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      // Scale numeralXl down when the typed/converted value no longer
                      // fits at 40px — keeps short amounts bold and long ones readable.
                      style:
                          AppTextStyles.numeralXl(color: amountColor).copyWith(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
