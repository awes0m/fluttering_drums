import 'package:fluttering_drums/utils/utils.dart';

// music constants
int index = 100;
int fps = 60;
int beats = 8;
int instruments = 6;
int activeLength = 0;
int activeBeat = 1;

// Screen Area
double kScreenWidth = ScrnSizer.screenWidth();
double kScreenHeight = ScrnSizer.screenHeight();

//instruments title area
double instrumentsColumnWidth = kScreenWidth / 8 * 1.5;
double instrumentsColumnHeight =
    kScreenHeight / (instruments + 1) * instruments;

//Grid area
double gridWidth = kScreenWidth - instrumentsColumnWidth - (2 * beats);
double gridHeight = instrumentsColumnHeight;

//Grid button area
double gridButtonWidth = ((gridWidth - 12) / (beats));
double gridButtonHeight = ((gridHeight + 12) / instruments);

//Buttom area
double bottomAreaHeight = kScreenHeight - instrumentsColumnHeight - 6;
double bottomAreaWidth =
    instrumentsColumnWidth + gridWidth - (ScrnSizer.screenWidth() * 0.01);
