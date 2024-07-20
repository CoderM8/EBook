import 'dart:math';

import 'package:elearn/appAds.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/getsinglecategorybyid.dart';
import 'package:elearn/screens/details_screen.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/service/httpservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../consttants.dart';

class SingleAuthorView extends StatefulWidget {
  SingleAuthorView(
      {required this.catId,
      required this.title,
      required this.id,
      required this.image,
      required this.name,
      required this.authorDescription});

  final int catId;
  final String title;
  final int id;
  final String image;
  final String name;
  final String authorDescription;

  @override
  _SingleAuthorViewState createState() => _SingleAuthorViewState();
}

class _SingleAuthorViewState extends State<SingleAuthorView> {
  @override
  void initState() {
    showInterstitialAdOnClickEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: comboBlackAndWhite(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: comboBlackAndWhite(),
          leadingWidth: 40,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            S.of(context).cat_Author,
            style: TextStyle(
                color: comboWhiteAndBlack(), fontFamily: "Gilroy-Medium"),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: comboWhiteAndBlack(),
                  ),
                )),
          )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: PhysicalModel(
                elevation: 13,
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                shadowColor: comboWhiteAndBlack(),
                child: Imageview(
                  image: widget.image,
                  radius: 10.r,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '${widget.name}',
              maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Gilroy-Medium',
                  fontSize: 20.sp,
                  color: comboWhiteAndBlack()),
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0.h.w),
                child: Text(
                  htmlString(html: widget.authorDescription),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: comboWhiteAndBlack(),
                    fontFamily: "Gilroy-SemiBold",
                  ),
                ),
              ),
            ),
            AdmobAds().bannerAds(),
            FutureBuilder<GetSingleCategoryById?>(
              future: HttpService().getSingleAuthorById(authId: widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.ebookApp.isNotEmpty) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8.r),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            crossAxisCount: 2,
                            childAspectRatio: 0.68),
                        itemCount: snapshot.data!.ebookApp.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showInterstitialAdOnClickEvent();
                              Get.to(() => DetailsScreen(
                                    rating:
                                        snapshot.data!.ebookApp[index].rateAvg,
                                    bookDescription: snapshot
                                        .data!.ebookApp[index].bookDescription,
                                    id: int.parse(
                                        snapshot.data!.ebookApp[index].id),
                                    bookTitle: snapshot
                                        .data!.ebookApp[index].bookTitle,
                                    bookCoverImg: snapshot
                                        .data!.ebookApp[index].bookCoverImg,
                                    authorDescription: snapshot
                                        .data!.ebookApp[index].bookDescription,
                                    authorName: snapshot
                                        .data!.ebookApp[index].authorName,
                                  ));
                            },
                            child: Imageview(
                              radius: 10.r,
                              image:
                                  snapshot.data!.ebookApp[index].bookCoverImg,
                            ),
                          );
                        });
                  } else {
                    return Text(
                      S.of(context).search_NO_BOOKS_FOUND,
                      style: TextStyle(
                          color: comboWhiteAndBlack(),
                          fontFamily: "Gilroy-Medium"),
                    );
                  }
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        crossAxisCount: 2,
                        childAspectRatio: 0.68),
                    itemCount: Random().nextInt(5),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: shimmerBaseColor(),
                        highlightColor: shimmerHighlightColor(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
