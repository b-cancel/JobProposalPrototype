//Golden Ratio naturally looks nice so I'm using it wherever I can
const int smallNumber = 42219911;
const int largeNumber = 68313251;
const double goldenRatio = largeNumber / smallNumber;
const double total = (smallNumber + largeNumber) * 1.0;
const double smallFraction = smallNumber / total;
const double largeFraction = largeNumber / total;

//used to make things look nicely scaled
//copies patterns reflected in nature

//grab larger bit
double toGoldenRatioBig(double number){
  double b = number / (goldenRatio + 1);
  return number - b;
}

//grab smaller it
double toGoldenRatioSmall(double number){
  double b = number / (goldenRatio + 1);
  return b;
}