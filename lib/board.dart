import 'package:flutter/material.dart';
import 'package:fluttering_drums/utils/app_constants.dart';
import 'package:fluttering_drums/utils/utils.dart';
import 'package:fluttering_drums/widgets/instrument_name_tile.dart';

import 'widgets/grid_button.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: kScreenHeight,
          width: kScreenWidth,
          child: ListView(
            children: [
              ///instruments  and grid box
              Container(
                padding: const EdgeInsets.only(
                  top: 2,
                  left: 2,
                ),
                width: kScreenWidth,
                height: instrumentsColumnHeight,
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///instrument name tiles
                    SizedBox(
                      height: instrumentsColumnHeight,
                      width: instrumentsColumnWidth,
                      child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            InstrumentNameTile(instrumentName: 'Drums'),
                            InstrumentNameTile(instrumentName: 'Bass'),
                            InstrumentNameTile(instrumentName: 'Guitar'),
                            InstrumentNameTile(instrumentName: 'Piano'),
                            InstrumentNameTile(instrumentName: 'Saxophone'),
                            InstrumentNameTile(instrumentName: 'Trumpet'),
                          ]),
                    ),

                    ///space between instruments and board
                    SizedBox(
                      width: ScrnSizer.screenWidth() * 0.001,
                    ),

                    ///board grids
                    Container(
                      height: gridHeight,
                      width: gridWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: GridView.count(
                        childAspectRatio: (gridHeight / gridWidth) *
                            ((beats - 0.1) / instruments),
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: instruments,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          beats * instruments,
                          (index) => GridButton(index: index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///space between instruments and menu
              SizedBox(height: kScreenHeight * 0.01),

              ///bottom menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  height: bottomAreaHeight,
                  width: bottomAreaWidth,
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
