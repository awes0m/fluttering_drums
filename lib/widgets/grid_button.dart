import 'package:flutter/material.dart';
import 'package:fluttering_drums/utils/colors.dart';

import '../utils/app_constants.dart';
import '../utils/text_styles.dart';

class GridButton extends StatelessWidget {
  final int index;
  const GridButton({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (TapDownDetails details) {
        print('index: ${(index / instruments * beats).floor()}');
      },
      child: Container(
        width: gridButtonWidth,
        height: gridButtonHeight,
        decoration: BoxDecoration(
          color: gray,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Center(
            child: Text(index.toString(),
                style: AppTextStyle.smallBold(color: Colors.white))),
      ),
    );
  }
}
