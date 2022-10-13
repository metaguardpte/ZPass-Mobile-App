import 'package:flutter/material.dart';

import '../../../widgets/load_image.dart';

class BackWithLogo extends StatelessWidget{
  const BackWithLogo({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
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