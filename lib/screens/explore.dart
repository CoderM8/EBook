import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/exploreallbook.dart';
import 'package:elearn/model/exploreauthor.dart';
import 'package:elearn/model/explorelatest.dart';
import 'package:elearn/service/httpservice.dart';
import 'package:elearn/widgets/beswtofday.dart';
import 'package:elearn/widgets/cat.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:elearn/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../appAds.dart';
import '../consttants.dart';
import 'allauthor.dart';
import 'details_screen.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  ExploreLatestBook? latestBook;
  ExploreAuthor? bookAuthor;
  ExploreAllBook? allBooks;

  Future<void> latest() async {
    latestBook = await HttpService().getExploreLatestBook();
    bookAuthor = await HttpService().getExploreAuthor();
    allBooks = await HttpService().getExploreAllBooks();
  }

  @override
  void initState() {
    latest().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: comboBlackAndWhite(),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          TitleBar(
            image: 'assets/images/web-browser.svg',
            title: S.of(context).explore_EXPLORE,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 10.w),
            child: CustomRichText(
              context: context,
              txt1: "${S.of(context).explore_LATEST} ",
              txt2: S.of(context).explore_BOOKS,
              fontsize1: 26.sp,
              fontsize2: 26.sp,
            ),
          ),
          if (latestBook != null)
            Container(
              height: 310.r,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 8.w),
                  itemCount: latestBook!.ebookApp.length,
                  itemBuilder: (context, index) {
                    return LatestBookView(
                      bookDescription: latestBook!.ebookApp[index].bookDescription,
                      authorDescription: latestBook!.ebookApp[index].authorDescription,
                      bookImage: latestBook!.ebookApp[index].bookCoverImg,
                      authorName: latestBook!.ebookApp[index].authorName,
                      bookTitle: latestBook!.ebookApp[index].bookTitle,
                      id: int.parse(latestBook!.ebookApp[index].id),
                      rating: latestBook!.ebookApp[index].rateAvg,
                    );
                  }),
            ),
          AdmobAds().bannerAds(),

          /// author
          Padding(
            padding: EdgeInsets.only(top: 25.h, left: 15.w, right: 15.w),
            child: Row(children: [
              CustomRichText(
                context: context,
                txt1: "",
                txt2: S.of(context).explore_AUTHOR,
                fontsize1: 26.sp,
                fontsize2: 26.sp,
              ),
              Spacer(),
              if (bookAuthor != null)
                GestureDetector(
                    onTap: () {
                      Get.to(() => AllAuthors(bookAuthor: bookAuthor));
                    },
                    child: Text(
                      S.of(context).home_SeeAll,
                      style: TextStyle(fontFamily: "Gilroy-SemiBold", color: comboWhiteAndBlack()),
                    ))
            ]),
          ),
          if (bookAuthor != null)
            Container(
              height: 220.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookAuthor!.ebookApp.length,
                  itemBuilder: (context, index) {
                    return AuthorView(
                      authorName: bookAuthor!.ebookApp[index].authorName,
                      authorImage: bookAuthor!.ebookApp[index].authorImage,
                      authid: int.parse(bookAuthor!.ebookApp[index].authorId),
                      authorDescription: bookAuthor!.ebookApp[index].authorDescription,
                    );
                  }),
            ),
          AdmobAds().bannerAds(),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: CustomRichText(
              context: context,
              txt1: "${S.of(context).explore_ALL_AVAILABLE} ",
              txt2: S.of(context).explore_BOOKS_available,
              fontsize1: 26.sp,
              fontsize2: 26.sp,
            ),
          ),
          if (allBooks != null)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: allBooks!.ebookApp.length <= 10 ? allBooks!.ebookApp.length : 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.h),
                  child: BestOfTheDay(
                    index: index,
                    image: allBooks!.ebookApp[index].bookCoverImg,
                    authorDescription: allBooks!.ebookApp[index].authorDescription,
                    bookTitle: allBooks!.ebookApp[index].bookTitle,
                    fileUrl: allBooks!.ebookApp[index].bookFileUrl,
                    bookDescription: allBooks!.ebookApp[index].bookDescription,
                    authorName: allBooks!.ebookApp[index].authorName,
                    rate: allBooks!.ebookApp[index].rateAvg,
                    catId: int.parse(allBooks!.ebookApp[index].id),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class LatestBookView extends StatelessWidget {
  LatestBookView({required this.bookImage, required this.authorName, required this.bookTitle, required this.id, required this.rating, required this.bookDescription, required this.authorDescription});

  final String bookDescription;
  final String authorDescription;
  final String bookImage;
  final String bookTitle;
  final String authorName;
  final int id;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() {
          return DetailsScreen(
            authorName: authorName,
            authorDescription: authorDescription,
            bookCoverImg: bookImage,
            bookTitle: bookTitle,
            bookDescription: bookDescription,
            id: id,
            rating: rating,
          );
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: Column(
          children: [
            Container(
              child: Imageview(
                image: bookImage,
                width: 160.r,
                height: 240.r,
                radius: 10.r,
              ),
            ),
            Container(
              width: 160.r,
              margin: EdgeInsets.only(top: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$bookTitle",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      fontSize: 18.sp,
                      color: comboWhiteAndBlack(),
                      fontFamily: "Gilroy-Bold",
                    ),
                  ),
                  Text("$authorName", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(color: comboWhiteAndBlack(), fontSize: 15.sp, fontFamily: "Gilroy-Medium"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorView extends StatelessWidget {
  AuthorView({required this.authorImage, required this.authorName, required this.authid, required this.authorDescription});

  final int authid;
  final String authorImage;
  final String authorName;
  final String authorDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, top: 15.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() {
            return SingleAuthorView(
              title: authorName,
              catId: authid,
              id: authid,
              name: authorName,
              image: authorImage,
              authorDescription: authorDescription,
            );
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Imageview(
              image: authorImage,
              radius: 75.r,
              height: 150.h,
              width: 150.w,
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 150.w,
              child: Text(
                "$authorName\n",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decorationStyle: TextDecorationStyle.dotted,
                  fontSize: 14.sp,
                  color: comboWhiteAndBlack(),
                  fontFamily: "Gilroy-Bold",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Imageview extends StatelessWidget {
  const Imageview({required this.image, this.radius, this.height, this.width});

  final String image;
  final double? radius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 8.r),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        height: height,
        width: width,
        placeholder: (context, url) => Shimmer.fromColors(
            baseColor: shimmerBaseColor(),
            highlightColor: shimmerHighlightColor(),
            child: Container(
              height: height,
              width: width,
              color: comboBlackAndWhite(),
            )),
        imageUrl: "$apiLink/images/$image",
        errorWidget: (context, url, error) => Image.asset(
          "assets/images/noimagefound.jpg",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
