import 'package:elearn/screens/details_screen.dart';
import 'package:elearn/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

import '../appAds.dart';
import '../consttants.dart';

class BestOfTheDay extends StatelessWidget {
  BestOfTheDay(
      {required this.index,
      required this.image,
      required this.bookDescription,
      required this.rate,
      required this.bookTitle,
      required this.authorDescription,
      required this.authorName,
      required this.fileUrl,
      required this.catId});

  final int index;
  final String image;
  final String fileUrl;
  final String bookDescription;
  final String authorDescription;
  final String bookTitle;
  final String authorName;
  final int catId;
  final String rate;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color(0xffffffff).withOpacity(0.9),
      Color(0xffffffff).withOpacity(0.5)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showInterstitialAdOnClickEvent();
        Get.to(() => DetailsScreen(
            authorName: authorName,
            authorDescription: bookDescription,
            bookCoverImg: image,
            bookDescription: authorDescription,
            id: catId,
            rating: rate,
            bookTitle: bookTitle));
      },
      child: GlassContainer(
        height: 250.h,
        width: 360.w,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20.w),
        borderRadius: BorderRadius.circular(25.r),
        color: Colors.teal,
        borderColor: Colors.transparent,
        gradient: LinearGradient(
          colors: [
            Color(0xffea990e).withOpacity(0.8),
            Color(0xff36363d).withOpacity(0.6),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: image,
                  child: Imageview(
                    image: image,
                    height: 240.r,
                    width: 160.r,
                    radius: 8.0.r,
                  ),
                ),
                Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: index + 1 > 9 ? 150.sp : 200.sp,
                      fontFamily: "Gilroy-Bold",
                      foreground: Paint()..shader = linearGradient),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bookTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: comboWhiteAndBlack(),
                      fontFamily: "Gilroy-Bold",
                    ),
                  ),
                  SizedBox(height: 15.0.h),
                  Text(
                    authorName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: comboWhiteAndBlack(),
                      fontFamily: "Gilroy-Bold",
                    ),
                  ),
                  Flexible(
                    child: Text(
                      htmlString(html: bookDescription),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: comboWhiteAndBlack(),
                        fontFamily: "Gilroy-SemiBold",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
