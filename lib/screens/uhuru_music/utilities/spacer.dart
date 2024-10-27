import 'package:get/get.dart';

class SpacerClass {
  final height = Get.size.height;
  final width = Get.size.width;
  double getVerticalSize(double height) {
    return this.height * height;
  }

  double getHorizontalSize(double width) {
    return this.width * width;
  }
}
