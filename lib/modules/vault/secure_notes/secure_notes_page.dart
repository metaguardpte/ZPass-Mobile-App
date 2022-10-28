import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';

class SecureNotesPage extends StatefulWidget {
  const SecureNotesPage({Key? key}) : super(key: key);

  @override
  State<SecureNotesPage> createState() => _SecureNotesPageState();
}

class _SecureNotesPageState extends State<SecureNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Container(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 30,
                  child: Icon(
                    ZPassIcons.icNoteCheck,
                    color: Color.fromRGBO(73, 84, 255, 1),
                    size: 20,
                  ),
                )),
          ),
          Container(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 30,
                  child: Icon(
                    ZPassIcons.icMenu,
                    color: Color.fromRGBO(73, 84, 255, 1),
                    size: 20,
                  ),
                )),
          )
        ],
        title: Text(
          S.current.DataRoaming,
          style: const TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.goBack(context);
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              ZPassIcons.icNavBack,
              color: Color.fromRGBO(94, 99, 103, 1),
              size: 16,
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 18),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 18, bottom: 18),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(11))),
              child: Column(
                children: [
                  Row(
                    children:  [
                      const Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      Gaps.hGap4,
                      Text(
                        S.current.title,
                        style:const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  Gaps.vGap8,
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7.5)),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(235, 235, 238, 1))),
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          hintText: S.current.none,
                          labelStyle: const TextStyle(
                            color: Color.fromRGBO(147, 151, 157, 1),
                          ),
                          prefixIcon: Container(
                            width: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                    color: Color.fromRGBO(0, 122, 249, 1),
                                  ),
                                  child: const Icon(
                                    ZPassIcons.favNotes,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                Gaps.hGap10,
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: const Color.fromRGBO(235, 235, 238, 1),
                                )
                              ],
                            ),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  Gaps.vGap16,
                  Row(
                    children: [
                     const Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      Gaps.hGap4,
                      Text(
                        S.current.note,
                        style:const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  Gaps.vGap8,
                  Container(
                    padding:const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(7.5)),
                        border: Border.all(
                            width: 1, color:const Color.fromRGBO(235, 235, 238, 1))),
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          hintText: S.current.none,
                          labelStyle:const TextStyle(
                            color: Color.fromRGBO(147, 151, 157, 1),
                          ),
                          // prefixIconConstraints: BoxConstraints(
                          //   maxWidth:
                          // ),
                          border: InputBorder.none),
                          maxLines: null,
                          minLines: 4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
