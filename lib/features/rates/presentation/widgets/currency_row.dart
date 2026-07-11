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
/// Base row shows an editable amount with lime border; other rows show
/// converted amounts and navigate to Detail on tap.
///
/// Example:
/// ```dart
/// CurrencyRow(code: 'EUR', name: 'Euro', amountText: '1,142.30', isBase: false);
/// ```
class CurrencyRow extends StatefulWidget {
  final String code;
  final String name;
  final String amountText;
  final bool isBase;
  final bool isEditMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRemove;
  final ValueChanged<String>? onAmountChanged;
  final double? amountValue;

  const CurrencyRow({
    super.key,
    required this.code,
    required this.name,
    required this.amountText,
    required this.isBase,
    this.isEditMode = false,
    this.onTap,
    this.onLongPress,
    this.onRemove,
    this.onAmountChanged,
    this.amountValue,
  });

  @override
  State<CurrencyRow> createState() => _CurrencyRowState();
}

class _CurrencyRowState extends State<CurrencyRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amountText);
  }

  @override
  void didUpdateWidget(covariant CurrencyRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when the formatted amount changes externally (base swap).
    if (widget.isBase &&
        widget.amountText != oldWidget.amountText &&
        _controller.text != widget.amountText) {
      _controller.text = widget.amountText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isBase
          ? AppColors.surfaceContainer
          : AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: BorderSide(
          color: widget.isBase
              ? AppColors.primaryFixed
              : AppColors.surfaceContainerHighest,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (widget.isEditMode) ...[
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.remove_circle, color: AppColors.error),
                ),
                GGap.hXs,
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
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isBase && widget.onAmountChanged != null)
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    style: AppTextStyles.numeralXl(color: AppColors.primaryFixed),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    onChanged: widget.onAmountChanged,
                  ),
                )
              else
                GText(
                  widget.amountText,
                  style: AppTextStyles.numeralXl(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
