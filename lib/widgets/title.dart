import 'package:elearn/consttants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TitleBar extends StatelessWidget {
  TitleBar({required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h, left: 5.w),
      child: Row(
        children: [
          Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r)),
            child: SvgPicture.asset(
              image,
              fit: BoxFit.cover,
              height: 30.h,
              colorFilter:
                  ColorFilter.mode(comboWhiteAndBlack(), BlendMode.srcIn),
              width: 30.w,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 25.sp,
              decoration: TextDecoration.none,
              color: comboWhiteAndBlack(),
              fontFamily: 'Gilroy-SemiBold',
            ),
          )
        ],
      ),
    );
  }
}
