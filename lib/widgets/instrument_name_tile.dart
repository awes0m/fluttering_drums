import 'package:flutter/material.dart';
import 'package:fluttering_drums/utils/app_constants.dart';
import 'package:fluttering_drums/utils/text_styles.dart';


class InstrumentNameTile extends StatelessWidget {
  final String instrumentName;
  const InstrumentNameTile({
    Key? key,
    required this.instrumentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: instrumentsColumnHeight/instruments,
      width: instrumentsColumnWidth-4,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Center(
          child: Text(
        instrumentName,
        style: AppTextStyle.smallBold(color: Colors.black),
      )),
    );
  }
}
