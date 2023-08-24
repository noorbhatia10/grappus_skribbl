import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;

class Assets {
  Assets() {
    if (kIsWeb) {
      imagesBasePath = 'images';
    } else {
      imagesBasePath = 'assets/images';
    }
  }

  late String imagesBasePath;

  late String avatar1 = '$imagesBasePath/1avatar.png';
  late String avatar2 = '$imagesBasePath/2avatar.png';
  late String avatar3 = '$imagesBasePath/3avatar.png';
  late String avatar4 = '$imagesBasePath/4avatar.png';
  late String avatar5 = '$imagesBasePath/5avatar.png';
  late String avatar6 = '$imagesBasePath/6avatar.png';
  late String avatar7 = '$imagesBasePath/7avatar.png';
  late String avatar8 = '$imagesBasePath/8avatar.png';
  late String avatar9 = '$imagesBasePath/9avatar.png';
  late String avatar10 = '$imagesBasePath/10avatar.png';
  late String avatar11 = '$imagesBasePath/11avatar.png';
  late String avatar12 = '$imagesBasePath/12avatar.png';
  late String avatar13 = '$imagesBasePath/13avatar.png';
  late String avatar14 = '$imagesBasePath/14avatar.png';
  late String avatar15 = '$imagesBasePath/15avatar.png';
  late String avatar16 = '$imagesBasePath/16avatar.png';
  late String avatar17 = '$imagesBasePath/17avatar.png';
  late String avatar18 = '$imagesBasePath/18avatar.png';
  late String avatar19 = '$imagesBasePath/19avatar.png';
  late String avatar20 = '$imagesBasePath/20avatar.png';
  late String avatar21 = '$imagesBasePath/21avatar.png';
  late String avatar22 = '$imagesBasePath/22avatar.png';
  late String avatar23 = '$imagesBasePath/23avatar.png';
  late String avatar24 = '$imagesBasePath/24avatar.png';
  late String avatar25 = '$imagesBasePath/25avatar.png';
  late String avatar26 = '$imagesBasePath/26avatar.png';
  late String avatar27 = '$imagesBasePath/27avatar.png';
  late String avatar28 = '$imagesBasePath/28avatar.png';
  late String avatar29 = '$imagesBasePath/29avatar.png';
  late String avatar30 = '$imagesBasePath/30avatar.png';

  String getRandomImage() {
    final random = Random();
    final randomAvatarNumber = random.nextInt(30) + 1;
    return '$imagesBasePath/${randomAvatarNumber}avatar.png';
  }
}
