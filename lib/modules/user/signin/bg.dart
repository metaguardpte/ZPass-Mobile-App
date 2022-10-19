import 'package:flkv/flkv.dart';
import 'package:flutter/material.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/routers/fluro_navigator.dart';

import 'package:zpass/routers/routers.dart';

import '../../../widgets/load_image.dart';

class BackWithLogo extends StatelessWidget {
  const BackWithLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
            padding: EdgeInsets.zero,
            color: Colors.cyan,
            height: 400,
            alignment: Alignment.topCenter,
            child: const LoadAssetImage(
              'signin/background@2x',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )),
        Positioned(
          left: 10,
          top: 30,
          child: IconButton(
            icon:const Icon(ZPassIcons.icNavBack, color: Colors.white, size: 16),
            padding:const EdgeInsets.all(0),
            onPressed: () {
              NavigatorUtils.push(
                  context, Routers.loginOrNew, clearStack: true);
            },),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 92.5, 0, 0),
          child: const LoadAssetImage(
            'signin/logo@2x',
            width: 187,
          ),
        )
      ],
    );
  }
}
