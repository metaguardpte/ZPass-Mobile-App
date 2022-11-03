import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';

class ZPassFormEditText extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool enable;
  final bool enableClear;
  final bool enablePrefix;
  final bool enableCopy;
  final bool readOnly;
  final TextInputAction action;
  final TextInputType? keyboardType;
  final double? borderRadius;
  final Widget? prefix;
  final String? initialText;
  final bool autofocus;
  final double textSize;
  final int? maxLength;
  final Color? bgColor;
  final Color? focusBgColor;
  final Color borderColor;
  final bool obscureText;
  final int maxLines;
  final FunctionReturn<String?, dynamic>? validator;
  final bool filled;
  final EdgeInsets? contentPadding;

  const ZPassFormEditText({this.hintText,
    this.initialText,
    this.prefix,
    this.height = 45,
    this.borderRadius = 8,
    this.enableClear = true,
    this.enablePrefix = true,
    this.enableCopy = false,
    this.readOnly = false,
    this.action = TextInputAction.done,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textSize = 13,
    this.maxLength,
    this.bgColor,
    this.focusBgColor,
    this.borderColor = Colors.transparent,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.enable = true,
    this.filled = false,
    this.contentPadding,
    Key? key})
      : super(key: key);

  @override
  ZPassFormEditTextState createState() => ZPassFormEditTextState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class ZPassFormEditTextState extends State<ZPassFormEditText> {
  final FocusNode _focus = FocusNode();
  late final TextEditingController _controller;
  bool _isSecret = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcon = widget.prefix ?? const Icon(ZPassIcons.icSearch, color: Colors.grey, size: 19,);
    final suffixChildren = [
      Visibility(
          visible: widget.enableClear,
          child: _controller.text.isNotEmpty ? _buildClear() : Gaps.empty),
      Visibility(visible: widget.obscureText, child: _buildSecret()),
      Visibility(visible: widget.enableCopy, child: _buildCopy()),
    ];
    final suffixIcon = Row(
      mainAxisSize: MainAxisSize.min,
      children: suffixChildren,
    );

    return TextFormField(
      enabled: widget.enable,
      readOnly: widget.readOnly,
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText ? _isSecret : false,
      textInputAction: widget.action,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: (String val) {
        _focus.unfocus();
        widget.onSubmitted?.call(val);
      },
      onChanged: (text) {
        if (widget.onChanged != null) {
          widget.onChanged!.call(text);
        }
        setState(() {});
      },
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: widget.textSize,),
      decoration: InputDecoration(
        fillColor: widget.bgColor,
        enabledBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                    color: context.isDark
                        ? Colours.dark_material_bg
                        : widget.borderColor),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              )
            : null,
        focusedBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderSide: BorderSide(color: widget.readOnly ? widget.borderColor : context.primaryColor, width: 0.5,),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              )
            : null,
        border: widget.borderRadius != null ? OutlineInputBorder(
          borderSide: BorderSide(color: widget.readOnly ? widget.borderColor : context.primaryColor, width: 0.5,),
          borderRadius: BorderRadius.circular(widget.borderRadius!),
        ) : null,
        filled: widget.filled,
        prefixIcon: widget.enablePrefix ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: prefixIcon,
        ) : null,
        prefixIconConstraints: BoxConstraints(
          maxWidth: widget.height + 20,
          maxHeight: widget.height,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyles.textGray12,
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(
          maxWidth: widget.height * suffixChildren.length,
          maxHeight: widget.height - 5
        ),
        isDense: true,
        contentPadding: widget.contentPadding,
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength)
      ],
    );
  }

  Widget _buildClear() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Icon(
          ZPassIcons.icTextFieldClean,
          color: Colors.grey,
          size: 17,
        ),
      ),
      onTap: () {
        /// https://github.com/flutter/flutter/issues/35848
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _controller.text = '';
          if (widget.onChanged != null) {
            widget.onChanged!("");
          }
          setState(() {});
        });
      },
    );
  }

  Widget _buildSecret() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isSecret = !_isSecret;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          _isSecret ? ZPassIcons.icSecret : ZPassIcons.icNoSecret,
          color: const Color(0xFF959BA7),
          size: 17,
        ),
      ),
    );
  }

  Widget _buildCopy() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_controller.text.isEmpty) return;
        Clipboard.setData(ClipboardData(text: _controller.text));
      },
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Icon(
          ZPassIcons.icCopy,
          color: Color(0xFF959BA7),
          size: 17,
        ),
      ),
    );
  }

  void requestFocus() {
    _focus.requestFocus();
  }

  void unFocus() {
    _focus.unfocus();
  }

  void disableFocus() {
    _focus.canRequestFocus = false;
  }

  void enableFocus() {
    _focus.canRequestFocus = true;
  }

  void fillText(String keyword) {
    _controller.text = keyword;
  }

  String get text => _controller.text;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
  }
}
