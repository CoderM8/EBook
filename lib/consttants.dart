import 'dart:math';

import 'package:elearn/generated/l10n.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Admin Panel Url

const apiLink = "https://vocsyinfotech.in/envato/cc/flutter_ebook/";

String? privacypolicy;
RxBool mode = false.obs;
String? userId;
String? type;
bool guest = false;
RxBool inAsyncCall = false.obs;
Color buttonColorAccent = Color(0xff2055AD);
const Color kLightThemeBackGroundColor = Color(0xFFFFFFFF);
const Color kDarkThemeBackGroundColor = Color(0xFF000000);
const String prefixLink = 'https://audible.page.link';

Future<Uri> createDynamicLink(
    {id, required String path, required String image}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: prefixLink,
    link: Uri.parse(id == null
        ? '$prefixLink$path'
        : "$prefixLink$path?id=$id&second=$image"),
    androidParameters: const AndroidParameters(
      packageName: 'com.flutter.audiobook.audible',
    ),
    iosParameters: const IOSParameters(
      appStoreId: "1669453557",
      bundleId: 'com.flutter.audiobook.audible',
    ),
  );
  final dynamicLink = await FirebaseDynamicLinks.instance
      .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);

  return dynamicLink.shortUrl;
}

Color comboBlackAndWhite() {
  return mode.value == false
      ? kLightThemeBackGroundColor
      : kDarkThemeBackGroundColor;
}

Color comboWhiteAndBlack() {
  return mode.value == false
      ? kDarkThemeBackGroundColor
      : kLightThemeBackGroundColor;
}

Color comboToggleButtonColor() {
  return mode.value == false ? kLightThemeBackGroundColor : Color(0xFf34323d);
}

Color comboToggleBackgroundColor() {
  return mode.value == false ? Color(0xFFe7e7e8) : Color(0xFF222029);
}

Color comboLightGreyAndGrey() {
  return mode.value == false ? Color(0xffb3b2b6) : Color(0xff8c8989);
}

Color comboGreyAndBlack() {
  return mode.value == false ? Color(0xff0000008A) : Color(0xffFFFFFF8A);
}

Color comboWhiteAndLightViolet() {
  return mode.value == false ? Color(0xFF26242e) : kLightThemeBackGroundColor;
}

Color shimmerBaseColor() {
  return mode.value == false
      ? Colors.grey.shade300
      : Colors.white.withOpacity(0.1);
}

Color shimmerHighlightColor() {
  return mode.value == false
      ? Colors.grey.shade100
      : Colors.black.withOpacity(0.8);
}

class Constants {
  static String appName = 'Flutter Ebook App';

  static formatBytes(bytes, decimals) {
    // if (value.isNaN || value.isInfinite) {
    //   // Handle the invalid value appropriately
    //   print("Cannot convert NaN or infinity to integer");
    // } else {
    //   int intValue = value.toInt();
    // Proceed with using intValue
    // }
    if (bytes == 0) return 0.0;
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = (log(bytes) / log(k)).floor();
    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }
}

/// app share link
const String appShareAndroid = "https://play.google.com/store";
const String appShareIOS = "https://www.apple.com/in/app-store/";

const String appShareTextAndroid =
    "Please share app with you friend. here is download app link : ";
const String appShareTextIOS =
    "Please share app with you friend. here is download app link : ";

getUserId() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  guest = sharedPreferences.getBool('guest') ?? false;
  userId = sharedPreferences.getString('userId');
  type = sharedPreferences.getString('type');

  mode.value = sharedPreferences.getBool("isDark") ?? false;

  print("UserId $userId");
}

String htmlString({required String html}) {
  final document = parse(html);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

void customSnackBar(context, {String? title}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: comboWhiteAndBlack(),
      content: Text(
        title ?? S.of(context).loginPage_login_to_continue,
        style: TextStyle(
            color: comboBlackAndWhite(),
            fontFamily: "Gilroy-SemiBold",
            fontSize: 15.sp),
      ),
      duration: Duration(milliseconds: 1500),
    ),
  );
}

showToast({required String msg}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: comboWhiteAndBlack(),
    textColor: comboBlackAndWhite(),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.sp,
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
