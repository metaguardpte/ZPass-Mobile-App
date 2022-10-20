import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

enum TextFieldType {
  text,
  email,
  selection,
  password,
}

class ZPassTextField extends StatefulWidget {
  const ZPassTextField({Key? key,
    this.title,
    this.hintText,
    this.textFieldTips,
    this.selectionText,
    this.suffixBtnTitle,
    this.textFieldHeight = 50.0,
    this.type = TextFieldType.text,
    this.loading = false,
    this.autoFocus = false,
    this.onTextChange,
    this.onEditingComplete,
    this.onSendCodeTap,
    this.onUnFocus,
    this.textInputType = TextInputType.text,
    this.onSelectionTap})
      : super(key: key);

  final String? title;
  final double? textFieldHeight;
  final String? hintText;
  final String? textFieldTips;
  final String? selectionText;
  final String? suffixBtnTitle;
  final TextFieldType? type;
  final TextInputType? textInputType;
  final bool? loading;
  final bool? autoFocus;
  final FunctionCallback<String>? onTextChange;
  final NullParamCallback? onEditingComplete;
  final NullParamCallback? onSendCodeTap;
  final NullParamCallback? onSelectionTap;
  final NullParamCallback? onUnFocus;

  @override
  _ZPassTextFieldState createState() => _ZPassTextFieldState();
}

class _ZPassTextFieldState extends State<ZPassTextField> {
  bool _isSecret = true;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _onListenFocus() {
    if (!_focusNode.hasFocus) {
      widget.onUnFocus?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onListenFocus);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onListenFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (widget.title ?? "").isNotEmpty ? _buildHeader() : Gaps.empty,
        _buildBody(),
        _buildTextFieldTips()
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        widget.title ?? "",
        style: const TextStyle(
            color: Color(0xFF16181A), fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      height: widget.textFieldHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(width: 1,color: const Color(0xFFEBEBEE)),
        ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.type == TextFieldType.selection ? _buildSelectionText() : _buildTextField(),
            ),
          ),
          _buildSuffixWidget(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autoFocus!,
      style: const TextStyle(fontSize: 16, color: Color(0xFF16181A)),
      enabled: !widget.loading!,
      onChanged: _onChange,
      onEditingComplete: _onEditingComplete,
      keyboardType: widget.textInputType,
      obscureText: widget.type == TextFieldType.password ? _isSecret : false,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText ?? "",
        hintStyle: const TextStyle(color: Color(0xFF93979D), fontSize: 13),
        suffixIcon: _buildCleanBtn(),
        suffixIconConstraints: const BoxConstraints(maxWidth: 34, maxHeight: 34),
      ),
    );
  }

  Widget _buildCleanBtn() {
    return _controller.text.isNotEmpty ? GestureDetector(
      onTap: _onCleanTextTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: const Icon(ZPassIcons.icTextFieldClean, size: 17, color: Color(0xFF959BA7),),
      ),
    ) : Gaps.empty;
  }

  Widget _buildSelectionText() {
    bool hasText = (widget.selectionText ?? "").isNotEmpty;
    Color textColor = Color(hasText ? 0xFF16181A : 0xFF93979D);
    return GestureDetector(
      onTap: widget.onSelectionTap,
      child: Text(
          hasText ? widget.selectionText! : (widget.hintText ?? ""),
          style: TextStyle(fontSize: hasText ? 16 : 13, color: textColor),
      ),
    );
  }

  Widget _buildSuffixWidget() {
    if (widget.loading!) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: CupertinoActivityIndicator(
          radius: 8,
        ),
      );
    }

    if (widget.type == TextFieldType.email) {
      return GestureDetector(
        onTap: widget.onSendCodeTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Text(
            widget.suffixBtnTitle ?? S.current.sendCode,
            style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4954FF),
                fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    if (widget.type == TextFieldType.selection) {
      return GestureDetector(
        onTap: widget.onSelectionTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 30,
          height: 30,
          padding: const EdgeInsets.all(10.5),
          child: const Icon(ZPassIcons.icSelectionArrow, size: 10, color: Color(0xFF16181A),),
        ),
      );
    }

    if (widget.type == TextFieldType.password) {
      return GestureDetector(
        onTap: _switchPassword,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(9),
          child: Icon(_isSecret ? ZPassIcons.icNoSecret : ZPassIcons.icSecret, color: const Color(0xFF959BA7), size: 17,),
        ),
      );
    }
    return Gaps.empty;
  }

  Widget _buildTextFieldTips() {
    return (widget.textFieldTips ?? "").isNotEmpty ? Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Text(
        widget.textFieldTips ?? "",
        style: const TextStyle(fontSize: 12, color: Color(0xFF16181A), height: 1.3),
      ),
    ) : Gaps.empty;
  }

  _switchPassword() {
    setState(() {
      _isSecret = !_isSecret;
    });
  }

  _onChange(value) {
    if (widget.onTextChange != null) {
      widget.onTextChange!.call(value);
    }
    setState(() {});
  }

  _onEditingComplete() {
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!.call();
    }
  }

  _onCleanTextTap() {
    _controller.clear();
    if (widget.onTextChange != null) {
      widget.onTextChange!.call("");
    }
    setState(() {});
  }
}
