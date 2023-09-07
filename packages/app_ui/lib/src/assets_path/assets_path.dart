import 'dart:math';

class Assets {

  static const String imagesBasePath = 'packages/app_ui/assets/images';

  static const String icPencil = '$imagesBasePath/ic_pencil.svg';

  // new images
  static const String avatar01 = '$imagesBasePath/avatar1.svg';
  static const String avatar02 = '$imagesBasePath/avatar2.svg';
  static const String avatar03 = '$imagesBasePath/avatar3.svg';
  static const String avatar04 = '$imagesBasePath/avatar4.svg';
  static const String avatar05 = '$imagesBasePath/avatar5.svg';
  static const String avatar06 = '$imagesBasePath/avatar6.svg';
  static const String avatar07 = '$imagesBasePath/avatar7.svg';
  static const String gridBackground = '$imagesBasePath/grid_background.svg';
  static const String pencil = '$imagesBasePath/pencil.svg';
  static const String imgGoldMedal = '$imagesBasePath/img_gold_medal.svg';
  static const String imgSilverMedal = '$imagesBasePath/img_silver_medal.svg';
  static const String imgBronzeMedal = '$imagesBasePath/img_bronze_medal.svg';

  String getRandomImage() {
    final random = Random();
    final randomAvatarNumber = random.nextInt(30) + 1;
    return '$imagesBasePath/${randomAvatarNumber}avatar.png';
  }
}
