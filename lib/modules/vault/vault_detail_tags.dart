import 'package:flutter/material.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/dialog/zpass_confirm_dialog.dart';

class VaultDetailTags extends StatefulWidget {
  const VaultDetailTags({
    Key? key,
    this.tags,
    this.editing = false,
    this.onTagChange,
  }) : super(key: key);
  final List<String>? tags;
  final bool? editing;
  final FunctionCallback<List<String>>? onTagChange;

  @override
  State<VaultDetailTags> createState() => VaultDetailTagsState();
}

class VaultDetailTagsState extends State<VaultDetailTags> {

  static const double itemHeight = 30, space = 12;
  List<String> _tags = [];
  bool get editing => widget.editing ?? false;

  @override
  void initState() {
    super.initState();
    _tags = [...widget.tags ?? []];
  }

  @override
  Widget build(BuildContext context) {
    return !editing && _tags.isEmpty
        ? Gaps.empty
        : Container(
            child: Column(
              children: [
                Gaps.vGap15,
                buildHint(context, "Tag"),
                Gaps.vGap12,
                _buildTags(),
              ],
            ),
          );
  }

  Widget _buildTags() {
    final items = <Widget>[];
    final tag = List.generate(
        _tags.length,
        (index) => _buildTagItem(context,
            text: _tags[index],
            editing: editing,
            onCloseTap: () => _removeTag(index),
        ),
    );
    items.addAll(tag);
    if (editing) {
      final createNew = _buildTagItem(
        context,
        text: "Add Tag",
        prefix: Icon(Icons.add, size: 15, color: context.primaryColor),
        color: context.primaryColor,
        bgColor: const Color(0XFFF1F2FF),
        onTap: _showAddTagDialog,
      );
      items.add(createNew);
    }
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: space,
        runSpacing: space,
        children: items,
      ),
    );
  }

  Widget _buildTagItem(
      BuildContext context,
      {required String text,
        bool editing = false,
        Widget? prefix,
        Color? color,
        Color? bgColor,
        NullParamCallback? onCloseTap,
        NullParamCallback? onTap,
      }) {
    final closeBtn = GestureDetector(
      onTap: onCloseTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // color: Colors.red,
        width: itemHeight,
        height: itemHeight,
        child: const Icon(ZPassIcons.icClose, size: 10,),
      ),
    );
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor ?? context.secondaryBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFEBEBEE), width: 0.5),
        ),
        child: Container(
          height: itemHeight,
          padding: EdgeInsets.fromLTRB(12,0,editing ? 0 : 12,0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              prefix ?? Gaps.empty,
              Flexible(
                child: Text(
                  text,
                  style: TextStyles.textSize14
                      .copyWith(color: color ?? context.textColor1, height: 1.1),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              editing ? closeBtn : Gaps.empty,
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    String newTagValue = "";
    ZPassConfirmDialog(
      isInput: true,
      onInputChange: (value) => newTagValue = value,
      onConfirmTap: () => _addTag(newTagValue),
    ).show(context);
  }

  void _removeTag(int index) {
    _tags.removeAt(index);
    if (widget.onTagChange != null) {
      widget.onTagChange!.call(_tags);
    }
    setState(() {});
  }

  void _addTag(String newTag) {
    _tags.add(newTag);
    if (widget.onTagChange != null) {
      widget.onTagChange!.call(_tags);
    }
    setState(() {});
  }

  void resetTag() {
    _tags = [...widget.tags ?? []];
    setState(() {});
  }
}
