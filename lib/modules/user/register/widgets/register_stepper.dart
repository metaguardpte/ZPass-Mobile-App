import 'package:flutter/material.dart';
import 'package:zpass/util/theme_utils.dart';

class RegisterStepper extends StatelessWidget {
  const RegisterStepper({Key? key, this.index = 0, this.count = 3}): super(key: key);

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: _buildStepItem(context, count, index),
      ),
    );
  }
  
  List<Widget> _buildStepItem(BuildContext context, int count, int index) {
    List<Widget> steps = [];
    for(int i = 0; i < count; i++) {
      final item = Expanded(
        child: Container(
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.5),
            color: i <= index ? context.primaryColor : const Color(0xFFE8E8EA),
          ),
        ),
      );
      steps.add(item);
    }
    return steps;
  }

}