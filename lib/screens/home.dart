// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/Profile.dart';
import 'package:elearn/model/allcategory.dart';
import 'package:elearn/model/besthomebook.dart';
import 'package:elearn/model/homecategory.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/service/httpservice.dart';
import 'package:elearn/widgets/beswtofday.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../appAds.dart';
import '../consttants.dart';
import '../model/categoryid.dart';
import '../widgets/title.dart';
import 'category.dart';
import 'details_screen.dart';
import 'griddview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getHomeBooks();
    super.initState();
  }

  RxList<Book> featuredBooks = <Book>[].obs;
  RxList<Book> latestBooks = <Book>[].obs;

  Future<BestHomeBook?> getHomeBooks() async {
    try {
      var response = await http.get(Uri.parse('$apiLink/api.php?method_name=home'));
      if (response.statusCode == 200) {
        var data = bestHomeBookFromJson(response.body);

        if (data.ebookApp != null) {
          latestBooks.value = data.ebookApp!.latestBooks!;
          featuredBooks.value = data.ebookApp!.featuredBooks!;
        }

        return data;
      } else {
        throw 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Request failed with status:$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: comboBlackAndWhite(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 18.0.h, left: 15.w, right: 15.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    userId != null
                        ? FutureBuilder<ProfileModel?>(
                            future: HttpService().getUserProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CustomRichText(
                                  context: context,
                                  fontsize1: 26.sp,
                                  fontsize2: 26.sp,
                                  txt1: "${S.of(context).home_GREETINGS}\n",
                                  txt2: "${snapshot.data!.ebookApp[0].name.toTitleCase()}",
                                );
                              } else {
                                return Container(
                                  height: 50,
                                  child: TitleBar(
                                    title: S.of(context).home_Hello,
                                    image: 'assets/images/Home.svg',
                                  ),
                                );
                              }
                            },
                          )
                        : CustomRichText(
                            context: context,
                            fontsize1: 26.sp,
                            fontsize2: 26.sp,
                            txt1: "${S.of(context).home_GREETINGS}\n",
                            txt2: "Hello Guest",
                          ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomRichText(
                  context: context,
                  fontsize1: 20.sp,
                  fontsize2: 20.sp,
                  txt2: S.of(context).home_CATEGORY,
                ),
              ),
              SizedBox(
                height: 250.h,
                child: FutureBuilder<AllCategory?>(
                    future: HttpService().getAllCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.ebookApp.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => NewCategoryScreen(
                                        catId: int.parse(snapshot.data!.ebookApp[index].cid),
                                        categoryName: snapshot.data!.ebookApp[index].categoryName));
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: 350.w,
                                          height: 300.w,
                                          imageUrl: snapshot.data!.ebookApp[index].categoryImage,
                                          placeholder: (context, url) => Shimmer.fromColors(
                                              baseColor: shimmerBaseColor(),
                                              highlightColor: shimmerHighlightColor(),
                                              child: Container(
                                                width: 350.w,
                                                height: 300.w,
                                                color: comboBlackAndWhite(),
                                              )),
                                          errorWidget: (context, url, error) => Image.asset(
                                            "assets/images/noimagefound.jpg",
                                            width: 350.w,
                                            height: 300.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 350.w,
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0.r),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.black12,
                                                Colors.black,
                                              ],
                                              begin: Alignment.center,
                                              end: Alignment.bottomCenter,
                                              // stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 15.h),
                                          child: Text(
                                            snapshot.data!.ebookApp[index].categoryName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.sp,
                                                fontFamily: "Gilroy-Bold"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text(S.of(context).search_NO_BOOKS_FOUND));
                        }
                      } else {
                        return Shimmer.fromColors(
                          child: Container(
                            width: 350.w,
                            height: 300.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          baseColor: shimmerBaseColor(),
                          highlightColor: shimmerHighlightColor(),
                        );
                      }
                    }),
              ),

              /// AD
              Center(child: AdmobAds().bannerAds()),

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.h),

                    /// What are you reading today
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomRichText(
                        context: context,
                        fontsize1: 18.sp,
                        fontsize2: 18.sp,
                        txt1: S.of(context).home_WHAT_ARE_YOU_READING,
                        txt2: S.of(context).home_TODAY,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// What are you reading today Data
                    Obx(() {
                      featuredBooks.value;
                      return Container(
                        height: 240.r,
                        child: featuredBooks.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: featuredBooks.length,
                                itemBuilder: (context, index) {
                                  return ReadingListCard(
                                    bookImage: featuredBooks[index].bookCoverImg ?? '',
                                    onTap: () {
                                      showInterstitialAdOnClickEvent();
                                      Get.to(
                                        () {
                                          return DetailsScreen(
                                            authorDescription:
                                                featuredBooks[index].authorDescription!,
                                            bookCoverImg: featuredBooks[index].bookCoverImg!,
                                            bookTitle: featuredBooks[index].bookTitle!,
                                            bookDescription: featuredBooks[index].bookDescription!,
                                            id: int.parse(featuredBooks[index].id!),
                                            rating: featuredBooks[index].rateAvg!,
                                            authorName: featuredBooks[index].authorName!,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              )
                            : Center(child: Text(S.of(context).search_NO_BOOKS_FOUND)),
                      );
                    }),

                    /// Best OF The Day
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w, top: 20.h),
                          child: CustomRichText(
                            context: context,
                            fontsize1: 20.sp,
                            fontsize2: 20.sp,
                            txt1: S.of(context).home_BEST_OF_THE,
                            txt2: S.of(context).home_DAY,
                          ),
                        ),
                        SizedBox(height: 20.0.h),
                        Obx(() {
                          latestBooks.value.shuffle();
                          return Container(
                            height: 250.h,
                            child: latestBooks.isNotEmpty
                                ? PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: latestBooks.length,
                                    itemBuilder: (context, index) {
                                      int num = Random().nextInt(latestBooks[index].catId!.length);
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: BestOfTheDay(
                                          index: index,
                                          image: latestBooks[index].bookCoverImg!,
                                          bookTitle: latestBooks[index].bookTitle!,
                                          authorName: latestBooks[index].authorName!,
                                          bookDescription: latestBooks[index].bookDescription!,
                                          fileUrl: latestBooks[index].bookFileUrl!,
                                          rate: latestBooks[index].rateAvg!,
                                          authorDescription: latestBooks[index].authorDescription!,
                                          catId: int.parse(latestBooks[index].catId![num]),
                                        ),
                                      );
                                    })
                                : Center(child: Text(S.of(context).search_NO_BOOKS_FOUND)),
                          );
                        }),

                        /// Home / Popular / Bast of the month / best of the day

                        FutureBuilder<CategoryId?>(
                            future: HttpService().getCatId(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.ebookApp.length,
                                      itemBuilder: (BuildContext context, index) {
                                        return FutureBuilder<CategoryById?>(
                                            future: HttpService().getCategoryById(
                                                bookId: snapshot.data!.ebookApp[index].id),
                                            builder: (context, bookData) {
                                              if (bookData.connectionState ==
                                                  ConnectionState.done) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.r,
                                                          top: 20.r,
                                                          left: 10.r,
                                                          right: 10.r),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:
                                                                MediaQuery.of(context).size.width *
                                                                    0.7,
                                                            child: Text(
                                                              '${snapshot.data!.ebookApp[index].sectionTitle}',
                                                              style: TextStyle(
                                                                  color: comboWhiteAndBlack(),
                                                                  fontSize: 18.sp,
                                                                  fontFamily: 'Gilroy-SemiBold'),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Get.to(() => ViewBookScreen(
                                                                  id: snapshot
                                                                      .data!.ebookApp[index].id,
                                                                  title: snapshot
                                                                      .data!
                                                                      .ebookApp[index]
                                                                      .sectionTitle));
                                                            },
                                                            child: Text(
                                                              S.of(context).home_SeeAll,
                                                              style: TextStyle(
                                                                color: comboWhiteAndBlack(),
                                                                fontFamily: "Gilroy-Medium",
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    if (bookData.data != null &&
                                                        bookData.data!.ebookApp.isNotEmpty)
                                                      SizedBox(
                                                        height: 240.r,
                                                        child: ListView.builder(
                                                          physics: BouncingScrollPhysics(),
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: bookData.data!.ebookApp.length,
                                                          itemBuilder: (context, index222) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                showInterstitialAdOnClickEvent();
                                                                Get.to(
                                                                  () {
                                                                    return DetailsScreen(
                                                                      authorName: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .authorName,
                                                                      authorDescription: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .authorDescription,
                                                                      bookCoverImg: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .bookCoverImg,
                                                                      bookTitle: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .bookTitle,
                                                                      bookDescription: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .bookDescription,
                                                                      id: int.parse(bookData.data!
                                                                          .ebookApp[index222].id),
                                                                      rating: bookData
                                                                          .data!
                                                                          .ebookApp[index222]
                                                                          .rateAvg,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 240.r,
                                                                width: 160.r,
                                                                margin: EdgeInsets.all(8.r),
                                                                child: Imageview(
                                                                    image: bookData
                                                                        .data!
                                                                        .ebookApp[index222]
                                                                        .bookCoverImg),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            });
                                      });
                                } else {
                                  return Center(child: Text(S.of(context).search_NO_BOOKS_FOUND));
                                }
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: shimmerBaseColor(),
                                  highlightColor: shimmerHighlightColor(),
                                  child: Center(
                                    child: Container(
                                      height: 240.w,
                                      width: 160.r,
                                      child: Icon(
                                        Icons.all_inclusive_outlined,
                                        size: 30.h.w,
                                        color: comboBlackAndWhite(),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ],
                ),
              ),
              Center(child: AdmobAds().bannerAds()),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
