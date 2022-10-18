import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/widgets/custom/gradient_circular_progress_indicator.dart';

Widget commonLoading(BuildContext context, {String? tips}) {
  final text = tips ?? S.of(context).tipsLoading;
  return Center(
    child: Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints.expand(width: 120, height: 120),
      decoration: BoxDecoration(
          color: Colours.mask,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GradientCircularProgressIndicator(),
          Gaps.vGap16,
          Text(text, style: TextStyles.textSize12.copyWith(color: Colors.white))
        ],
      ),
    ),
  );
}