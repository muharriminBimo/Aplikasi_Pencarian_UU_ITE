import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuite/app/shared/text_default.dart';

class TextFieldDefault extends StatelessWidget {
  const TextFieldDefault({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.autoCorrect,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.controller,
    this.autoFocus = false,
    this.maxLength,
    this.readOnly,
    this.onPressed,
    this.counterText,
    this.maxLines,
    this.minLines,
    this.height = 45,
    this.font,
    this.fontSize,
    this.fontWeight,
    this.showCursor,
    this.inputFormatters,
    this.text,
    this.textCapitalization,
    this.onSubmitted,
    this.errorText,
    this.enabled,
    this.textAlignVertical,
    this.fontSizeHint,
    this.labelText,
    this.labelStyle,
    this.color,
    this.borderRadius,
    this.padding,
    this.contentPadding,
    this.obscureText,
    this.validator,
    this.textInputAction,
    this.borderSide,
    this.fontColorHint,
    this.noPrefixPadding,
    this.errorColor,
    this.focusNode,
  });

  final String? hintText;
  final String? font;
  final String? text;
  final String? errorText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? autoCorrect;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? obscureText;
  final bool? counterText;
  final bool? showCursor;
  final bool? enabled;
  final bool? noPrefixPadding;
  final TextInputType? keyboardType;
  final void Function()? onPressed;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double height;
  final double? fontSize;
  final double? fontSizeHint;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? labelStyle;
  final Color? color;
  final Color? fontColorHint;
  final Color? errorColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final BorderSide? borderSide;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            child: TextFormField(
              focusNode: focusNode,
              enabled: enabled,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator,
              obscureText: obscureText ?? false,
              textAlignVertical: textAlignVertical,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              inputFormatters: inputFormatters,
              showCursor: showCursor,
              maxLines: maxLines ?? 1,
              minLines: minLines,
              onTap: onPressed,
              readOnly: readOnly ?? false,
              enableInteractiveSelection: readOnly,
              maxLength: maxLength,
              controller: controller,
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onSubmitted,
              autofocus: autoFocus ?? false,
              autocorrect: autoCorrect ?? false,
              enableSuggestions: false,
              keyboardType: keyboardType,
              textInputAction: textInputAction ?? TextInputAction.next,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: color ?? Colors.white,
                counterText: counterText == null ? '' : null,
                labelText: labelText,
                labelStyle: labelStyle,
                prefixIcon: Padding(
                  padding: noPrefixPadding ?? false
                      ? EdgeInsets.zero
                      : prefixIcon == null
                          ? const EdgeInsets.only(left: 20)
                          : const EdgeInsets.symmetric(horizontal: 20),
                  child: prefixIcon,
                ),
                suffixIcon: Padding(
                  padding: suffixIcon == null
                      ? const EdgeInsets.only(right: 20)
                      : const EdgeInsets.symmetric(horizontal: 20),
                  child: suffixIcon,
                ),
                hintText: hintText,
                errorStyle: const TextStyle(height: 0.1, fontSize: 0),
                contentPadding: contentPadding ?? const EdgeInsets.all(15),
                hintStyle: TextStyle(
                  fontSize: fontSizeHint ?? 14,
                  fontWeight: FontWeight.w400,
                  color: fontColorHint ?? Colors.black45,
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 1, maxHeight: 22),
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 1, maxHeight: 22),
                border: _buildBorder(),
                enabledBorder: _buildBorder(),
                disabledBorder: _buildBorder(),
                focusedBorder: _buildBorder(),
              ),
            ),
          ),
          if (errorText?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: TextDefault(
                errorText!,
                fontSize: 12,
                color: errorColor ?? Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: borderSide ?? const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(borderRadius ?? 5),
    );
  }
}
