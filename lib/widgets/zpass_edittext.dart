import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';

class ZPassEditText extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool enableInput;
  final bool enableClear;
  final bool enablePrefix;
  final bool enableCopy;
  final TextInputAction action;
  final double borderRadius;
  final Widget? prefix;
  final String? initialText;
  final bool autofocus;
  final double textSize;
  final int? maxLength;
  final Color? bgColor;
  final Color? focusBgColor;
  final Color? borderColor;
  final bool obscureText;
  final int maxLines;

  const ZPassEditText({this.hintText,
    this.initialText,
    this.prefix,
    this.height = 45,
    this.borderRadius = 8,
    this.enableInput = true,
    this.enableClear = true,
    this.enablePrefix = true,
    this.enableCopy = false,
    this.action = TextInputAction.done,
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
    Key? key})
      : super(key: key);

  @override
  ZPassEditTextState createState() => ZPassEditTextState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class ZPassEditTextState extends State<ZPassEditText> {
  final FocusNode _focus = FocusNode();
  late final TextEditingController _controller;
  var _hasFocus = false;
  bool _isSecret = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focus.addListener(() => setState(() {
      _hasFocus = _focus.hasFocus;
    }));
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcon = widget.prefix ?? const Icon(ZPassIcons.icSearch, color: Colors.grey,);
    final suffixChildren = [
      Visibility(
        visible: widget.enableClear,
        child: _controller.text.isNotEmpty ? _buildClear() : Gaps.empty,
      ),
      widget.obscureText ? _buildSecret() : Gaps.empty,
      widget.enableCopy ? _buildCopy() : Gaps.empty,
    ];
    final suffixIcon = Row(mainAxisSize: MainAxisSize.min,children: suffixChildren,);
    final prefixIconWidget = Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: prefixIcon,
    );

    var bgColor = widget.bgColor ?? Colours.bg_gray;
    if (_hasFocus) bgColor = widget.focusBgColor ?? Colours.bg_gray;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: widget.height,
      decoration: BoxDecoration(
        color: context.isDark ? Colours.dark_material_bg : bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: _hasFocus && widget.enableInput ? context.primaryColor : widget.borderColor!, width: 0.5)
      ),
      child: TextField(
        key: const Key('search_text_field'),
        controller: _controller,
        focusNode: _focus,
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText ? _isSecret : false,
        textInputAction: widget.action,
        readOnly: !widget.enableInput,
        onSubmitted: (String val) {
          _focus.unfocus();
          widget.onSubmitted?.call(val);
        },
        onChanged: (text) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(text);
          }
          setState(() {});
        },
        style: TextStyle(
          fontSize: widget.textSize,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: widget.enablePrefix ? prefixIconWidget : null,
          hintText: widget.hintText,
          hintStyle: TextStyles.textGray12,
          suffixIcon: suffixIcon,
          suffixIconConstraints: BoxConstraints(
              maxWidth: widget.height * suffixChildren.length, maxHeight: widget.height - 5),
          isDense: true,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength)
        ],
      ),
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
  }
}
