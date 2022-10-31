import 'package:flutter/material.dart';

class RowData {
  Widget? icon;
  dynamic text;
  String? path;
  Widget? right;
  RowData({this.icon, this.text, this.path, this.right});
}

class ListWidget extends StatefulWidget {
  const ListWidget({Key? key, required this.rows, this.withIcon = true,this.flex})
      : super(key: key);
  final List<RowData> rows;
  final bool withIcon;
  final int? flex;
  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  List<Widget> MapColumnChild(List<RowData> rows) {
    List<Widget> output = [];
    for (var i = 0; i < rows.length; i++) {
      output.add(Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              width: widget.withIcon ? 44 : 0,
              alignment: Alignment.center,
              child: rows[i].icon != null ? rows[i].icon! : const Text(''),
            ),
            Expanded(
                child: Container(
              height: 51.5,
              alignment: Alignment.centerLeft,
              decoration: i < rows.length - 1
                  ? const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(233, 234, 238, 1),
                              width: 1)))
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    child: Container(
                      margin: EdgeInsets.only(left: widget.withIcon ? 0 : 12),
                      child: rows[i].text is Widget
                          ? rows[i].text
                          : Text(
                              rows[i].text,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              maxLines: 1,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 12),
                      alignment: Alignment.centerRight,
                      child: rows[i].right,
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(11)),
      child: Column(
        children: MapColumnChild(widget.rows),
      ),
    );
  }
}
