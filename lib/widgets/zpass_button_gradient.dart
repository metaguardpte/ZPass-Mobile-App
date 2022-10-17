import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/util/callback_funcation.dart';

class ZPassButtonGradient extends StatelessWidget {
  const ZPassButtonGradient({
    Key? key,
    this.text,
    this.textStyle,
    this.onPress,
    this.width = 90,
    this.height = 35,
    this.borderRadius = 16.0,
    this.enableShadow = false,
    this.loading = false,
    this.startColor = const Color(0xFF468AFF),
    this.endColor = const Color(0xFF7BB8FE),
  }) : super(key: key);

  final Color startColor, endColor;
  final double width, height, borderRadius;
  final String? text;
  final TextStyle? textStyle;
  final NullParamCallback? onPress;
  final bool enableShadow;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    var shadows = <BoxShadow>[];
    if (enableShadow) {
      shadows.add(const BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0));
    }
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadows,
        gradient: LinearGradient(
          stops: const [0.0, 1.0],
          colors: [
            startColor,
            endColor,
          ],
        ),
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(width, height)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPress != null && !loading! ? () => onPress?.call() : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading! ?
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 8,
              ),
            ) : Gaps.empty,
            Text(text ?? "", style: textStyle ?? const TextStyle(fontSize: 15, color: Colors.white,),),
          ],
        ),
        ),

    );
  }
}
