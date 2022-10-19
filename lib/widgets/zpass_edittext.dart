import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/load_image.dart';

class ZPassEditText extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool enableClear;
  final bool enablePrefix;
  final TextInputAction action;
  final double borderRadius;
  final Widget? prefix;
  final String? initialText;
  final bool autofocus;
  final double textSize;
  final int? maxLength;
  final Color? bgColor;
  final Color? focusBgColor;

  const ZPassEditText(
      {this.hintText,
      this.initialText,
      this.prefix,
      this.height = 45,
      this.borderRadius = 8,
      this.enableClear = true,
      this.enablePrefix = true,
      this.action = TextInputAction.done,
      this.onChanged,
      this.onSubmitted,
      this.autofocus = false,
      this.textSize = 13,
      this.maxLength,
      this.bgColor,
      this.focusBgColor,
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
    final prefixIcon = widget.prefix ?? const Icon(ZPassIcons.icSearch);
    final suffixIcon = GestureDetector(
      child: const LoadAssetImage("ic_clean", width: 17, height: 17,),
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
    final prefixIconWidget = Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: prefixIcon,
    );

    var bgColor = widget.bgColor ?? Colours.bg_gray;
    if (_hasFocus) bgColor = widget.focusBgColor ?? Colours.bg_gray;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      height: widget.height,
      decoration: BoxDecoration(
        color: context.isDark ? Colours.dark_material_bg : bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: _hasFocus ? context.primaryColor : Colors.transparent)
      ),
      child: TextField(
        key: const Key('search_text_field'),
        controller: _controller,
        focusNode: _focus,
        autofocus: widget.autofocus,
        maxLines: 1,
        textInputAction: widget.action,
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
        style: TextStyle(fontSize: widget.textSize,),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: widget.enablePrefix ? prefixIconWidget : Gaps.empty,
          hintText: widget.hintText,
          hintStyle: TextStyles.textGray12,
          suffixIcon: widget.enableClear ? (_controller.text.isNotEmpty ? suffixIcon : null) : null,
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 20,
            maxHeight: 20
          ),
          isDense: true,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength)
        ],
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
