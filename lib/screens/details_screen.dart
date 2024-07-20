import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearn/databasefavourite/db.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/main.dart';
import 'package:elearn/model/allcomments.dart';
import 'package:elearn/model/detailsProvider.dart';
import 'package:elearn/model/singlebookbyid.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/service/httpservice.dart';
import 'package:elearn/widgets/download_alert.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../appAds.dart';
import '../consttants.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    required this.bookCoverImg,
    required this.bookTitle,
    required this.bookDescription,
    required this.rating,
    required this.id,
    required this.authorDescription,
    required this.authorName,
  });

  final String bookCoverImg;
  final String bookDescription;
  final String authorDescription;
  final String rating;
  final int id;
  final String bookTitle;
  final String authorName;

  @override
  _DetailsScreenState createState() =>
      _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController commentController =
      TextEditingController();
  bool fav = false;
  bool read = false;
  RxBool isComment = false.obs;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    Future.wait([getDatabase(), getBookData()])
        .whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  Future getDatabase() async {
    fav = await DatabaseHelper.instance
        .likeOrNot(widget.id.toString());
    read = await DatabaseHelper.instance
        .retrieveDownloadID(id: widget.id);
  }

  SingleBookById? singleBookById;

  Future getBookData() async {
    await HttpService()
        .getSingleBookById(bookId: widget.id)
        .then((value) {
      return singleBookById = value;
    });
  }

  sendComment() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      isComment.value = false;
      return;
    }
    _form.currentState!.save();
    var response = await http.get(Uri.parse(
        "$apiLink/api_comment.php?user_id=$userId&book_id=${widget.id}&comment_text=${commentController.text}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["EBOOK_APP"][0]['success'] == "1") {
        setState(() {
          getBookData();
        });
        commentController.clear();
        focusNode.unfocus();
        isComment.value = false;
      }
    } else {
      throw "Fail To Get Comments !1!";
    }
  }

  Future<AllComments?> getAllComments() async {
    try {
      var response = await http.get(Uri.parse(
        "$apiLink/api.php?method_name=get_all_comments&books_id=${widget.id}",
      ));
      if (response.statusCode == 200) {
        return allCommentsFromJson(response.body);
      }
    } catch (e) {}
    return null;
  }

  Future deleteComment(id) async {
    var response = await http.get(Uri.parse(
        "$apiLink/api.php?method_name=removecomment&comment_id=$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsProvider>(builder:
        (BuildContext context,
            DetailsProvider detailsProvider, child) {
      return Scaffold(
        backgroundColor: comboBlackAndWhite(),
        appBar: AppBar(
          backgroundColor: comboBlackAndWhite(),
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.bookTitle,
            style: TextStyle(
              color: comboWhiteAndBlack(),
              fontFamily: "Gilroy-SemiBold",
            ),
          ),
          leading: IconButton(
            splashRadius: 10.r,
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: comboWhiteAndBlack(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Stack(
                        alignment: Alignment.center,
                        children: [
                          Imageview(
                            image: widget.bookCoverImg,
                            height: 350.w,
                            width: 250.w,
                            radius: 10.0.r,
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 40.0, sigmaY: 40.0),
                            child: Column(
                              children: [
                                Hero(
                                  tag: widget.bookCoverImg,
                                  child: Imageview(
                                    image:
                                        widget.bookCoverImg,
                                    height: 275.0.w,
                                    width: 170.0.w,
                                    radius: 10.0,
                                  ),
                                ),
                                SizedBox(height: 35.0.h),
                                GlassContainer(
                                  borderRadius:
                                      BorderRadius.circular(
                                          15.0.r),
                                  opacity: 0.4,
                                  border: Border(
                                      top: BorderSide.none,
                                      bottom:
                                          BorderSide.none,
                                      left: BorderSide.none,
                                      right:
                                          BorderSide.none),
                                  blur: 5.0,
                                  height: 50.h,
                                  width: 250.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceAround,
                                    children: [
                                      Obx(() {
                                        detailsProvider
                                            .barrierDismissible
                                            .value;
                                        return GestureDetector(
                                          onTap: () async {
                                            if (userId !=
                                                null) {
                                              if (singleBookById !=
                                                      null &&
                                                  singleBookById!
                                                      .ebookApp
                                                      .isNotEmpty) {
                                                Directory?
                                                    appDocDir =
                                                    Platform.isAndroid
                                                        ? await getExternalStorageDirectory()
                                                        : await getApplicationDocumentsDirectory();
                                                String path;

                                                if (singleBookById!
                                                    .ebookApp[
                                                        0]
                                                    .bookFileUrl
                                                    .toString()
                                                    .contains(
                                                        "epub")) {
                                                  path = Platform
                                                          .isIOS
                                                      ? appDocDir!.path +
                                                          '/${widget.id}.epub'
                                                      : appDocDir!.path +
                                                          '/Ebook/${widget.id}.epub';
                                                } else {
                                                  Directory?
                                                      appDocDir =
                                                      Platform.isAndroid
                                                          ? await getExternalStorageDirectory()
                                                          : await getApplicationDocumentsDirectory();
                                                  path = Platform
                                                          .isIOS
                                                      ? appDocDir!.path +
                                                          '/${widget.id}.pdf'
                                                      : appDocDir!.path +
                                                          '/Ebook/${widget.id}.pdf';
                                                }

                                                if (read) {
                                                  print(
                                                      "Book Is Readable");
                                                  if (singleBookById!
                                                      .ebookApp[
                                                          0]
                                                      .bookFileUrl
                                                      .toString()
                                                      .contains(
                                                          'epub')) {
                                                    Get.to(() => EpuB(
                                                        id: widget
                                                            .id,
                                                        path:
                                                            path));
                                                  } else {
                                                    Get.to(
                                                      () {
                                                        return PdfViewerPage(
                                                          bookid: widget.id,
                                                          bookTitle: widget.bookTitle,
                                                          image: widget.bookCoverImg,
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  down.value =
                                                      false;
                                                  if (isAndroidVersionUp13 ==
                                                      true) {
                                                    await detailsProvider
                                                        .downloadFile(
                                                      context,
                                                      url: singleBookById!
                                                          .ebookApp[0]
                                                          .bookFileUrl,
                                                      filename: widget
                                                          .id
                                                          .toString(),
                                                      id: widget
                                                          .id,
                                                      img: widget
                                                          .bookCoverImg,
                                                    );
                                                    if (down
                                                        .value) {
                                                      DatabaseHelper
                                                          .instance
                                                          .insertDownLoad(
                                                        DownloadModel(
                                                          id: widget.id,
                                                          link: path,
                                                          image: widget.bookCoverImg,
                                                          title: widget.bookTitle,
                                                        ),
                                                      );
                                                      getDatabase().whenComplete(() =>
                                                          setState(() {}));
                                                    }
                                                  } else {
                                                    if (await Permission
                                                        .storage
                                                        .request()
                                                        .isGranted) {
                                                      await detailsProvider
                                                          .downloadFile(
                                                        context,
                                                        url:
                                                            singleBookById!.ebookApp[0].bookFileUrl,
                                                        filename:
                                                            widget.id.toString(),
                                                        id: widget.id,
                                                        img:
                                                            widget.bookCoverImg,
                                                      );
                                                      if (down
                                                          .value) {
                                                        DatabaseHelper.instance.insertDownLoad(
                                                          DownloadModel(
                                                            id: widget.id,
                                                            link: path,
                                                            image: widget.bookCoverImg,
                                                            title: widget.bookTitle,
                                                          ),
                                                        );
                                                        getDatabase().whenComplete(() =>
                                                            setState(() {}));
                                                      }
                                                    } else if (await Permission
                                                        .storage
                                                        .request()
                                                        .isDenied) {
                                                      await Permission
                                                          .storage
                                                          .request();
                                                    }
                                                  }
                                                }
                                              } else {
                                                customSnackBar(
                                                    context,
                                                    title: S
                                                        .of(context)
                                                        .no_book_url_found);
                                              }
                                            } else {
                                              customSnackBar(
                                                  context);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                read
                                                    ? S
                                                        .of(
                                                            context)
                                                        .detail_screen_READ
                                                    : S
                                                        .of(context)
                                                        .setting_DOWNLOAD,
                                                style:
                                                    TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontSize:
                                                      20.0.sp,
                                                  fontFamily:
                                                      "Gilroy-Bold",
                                                ),
                                              ),
                                              read
                                                  ? Icon(
                                                      Icons
                                                          .menu_book_outlined,
                                                      color: Colors
                                                          .black)
                                                  : Icon(
                                                      Icons
                                                          .download_rounded,
                                                      color:
                                                          Colors.black)
                                            ],
                                          ),
                                        );
                                      }),

                                      /// Like With database
                                      userId == null
                                          ? GestureDetector(
                                              onTap:
                                                  () async {
                                                customSnackBar(
                                                    context);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(S.of(context).detail_screen_LIKES,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0.sp,
                                                          fontFamily: "Gilroy-Bold")),
                                                  Icon(
                                                    Icons
                                                        .bookmark_border,
                                                    color: Colors
                                                        .black,
                                                  )
                                                ],
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap:
                                                  () async {
                                                if (fav) {
                                                  await DatabaseHelper
                                                      .instance
                                                      .deleteTodo(
                                                          id: widget.id);
                                                } else {
                                                  await DatabaseHelper
                                                      .instance
                                                      .insertTodo(
                                                    Todo(
                                                      id: widget
                                                          .id,
                                                      rating: widget
                                                          .rating
                                                          .toString(),
                                                      authorDescription:
                                                          widget.authorDescription,
                                                      bookDescription:
                                                          widget.bookDescription,
                                                      image:
                                                          widget.bookCoverImg,
                                                      authorName:
                                                          widget.authorName,
                                                      bookid:
                                                          widget.id,
                                                      title:
                                                          widget.bookTitle,
                                                    ),
                                                  );
                                                  showToast(
                                                      msg: S
                                                          .of(context)
                                                          .detail_screen_ADD_FAVOURITE);
                                                }
                                                getDatabase()
                                                    .whenComplete(
                                                        () {
                                                  setState(
                                                      () {});
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(S.of(context).detail_screen_LIKES,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0.sp,
                                                          fontFamily: "Gilroy-Bold")),
                                                  Icon(
                                                    fav
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    color: Colors
                                                        .black,
                                                  )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Center(child: AdmobAds().bannerAds()),
              SizedBox(height: 15.h),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  htmlString(html: widget.bookDescription),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: comboWhiteAndBlack(),
                    fontFamily: "Gilroy-SemiBold",
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  "By ${widget.authorName}",
                  style: TextStyle(
                      fontSize: 15.0.sp,
                      color: comboWhiteAndBlack(),
                      fontFamily: "Gilroy-Bold"),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  htmlString(
                      html: widget.authorDescription),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: comboWhiteAndBlack(),
                    fontFamily: "Gilroy-SemiBold",
                  ),
                ),
              ),
              if (singleBookById != null &&
                  singleBookById!.ebookApp.isNotEmpty)
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.w, top: 10.0.h),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: comboWhiteAndBlack(),
                              fontSize: 20.0.sp,
                              fontFamily: "Gilroy-Bold"),
                          children: [
                            TextSpan(
                              text: S
                                  .of(context)
                                  .detail_screen_YOU_MIGHT_ALSO,
                            ),
                            TextSpan(
                              text: S
                                  .of(context)
                                  .detail_screen_LIKE,
                              style: TextStyle(
                                  fontFamily:
                                      "Gilroy-Bold"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 300.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: singleBookById!
                              .ebookApp[0]
                              .relatedBooks!
                              .length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showInterstitialAdOnClickEvent();
                                Get.to(
                                  () {
                                    return DetailsScreen(
                                      authorName:
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .authorName,
                                      authorDescription:
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .authorDescription,
                                      bookCoverImg:
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .bookCoverImg,
                                      bookTitle:
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .bookTitle,
                                      bookDescription:
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .bookDescription,
                                      id: int.parse(
                                          singleBookById!
                                              .ebookApp[0]
                                              .relatedBooks![
                                                  index]
                                              .id),
                                      rating: singleBookById!
                                          .ebookApp[0]
                                          .relatedBooks![
                                              index]
                                          .rateAvg,
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.all(8.r),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Expanded(
                                      child: Imageview(
                                        image: singleBookById!
                                            .ebookApp[0]
                                            .relatedBooks![
                                                index]
                                            .bookCoverImg,
                                        radius: 10.r,
                                        width: 153.w,
                                      ),
                                    ),
                                    SizedBox(height: 7.h),
                                    Text(
                                      singleBookById!
                                          .ebookApp[0]
                                          .relatedBooks![
                                              index]
                                          .bookTitle,
                                      maxLines: 1,
                                      textAlign:
                                          TextAlign.start,
                                      style: TextStyle(
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        fontFamily:
                                            "Gilroy-Bold",
                                        fontSize: 16.sp,
                                        color:
                                            comboWhiteAndBlack(),
                                      ),
                                    ),
                                    Text(
                                      singleBookById!
                                          .ebookApp[0]
                                          .relatedBooks![
                                              index]
                                          .authorName,
                                      textAlign:
                                          TextAlign.left,
                                      style: TextStyle(
                                        fontFamily:
                                            "Gilroy-Medium",
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        fontSize: 12.0.sp,
                                        color:
                                            comboWhiteAndBlack(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).details_screen_COMMENTS,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Gilroy-SemiBold',
                          color: comboWhiteAndBlack()),
                    ),
                  ],
                ),
              ),
              if (userId != null)
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 5.h),
                  child: Form(
                    key: _form,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return S
                                    .of(context)
                                    .details_screen_comments_textField_validation;
                              else
                                return null;
                            },
                            controller: commentController,
                            autofocus: false,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(
                                      left: 10.w),
                              hintText: S
                                  .of(context)
                                  .details_screen_comments_textField_hint_text,
                              hintStyle: TextStyle(
                                  fontSize: 15.sp,
                                  color:
                                      comboWhiteAndBlack(),
                                  fontFamily:
                                      "Gilroy-Medium"),
                              fillColor:
                                  comboWhiteAndBlack(),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10.r),
                                borderSide: BorderSide(
                                    color:
                                        comboWhiteAndBlack(),
                                    width: 1.w),
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10.r),
                                borderSide: BorderSide(
                                    color:
                                        comboWhiteAndBlack(),
                                    width: 1.w),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10.r),
                                borderSide: BorderSide(
                                    color:
                                        comboWhiteAndBlack(),
                                    width: 1.w),
                              ),
                              errorBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10.r),
                                borderSide: BorderSide(
                                    color:
                                        comboWhiteAndBlack(),
                                    width: 1.w),
                              ),
                            ),
                            keyboardType:
                                TextInputType.text,
                            style: TextStyle(
                              color: comboWhiteAndBlack(),
                              fontFamily: "Gilroy-Medium",
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Obx(() {
                          return IconButton(
                            splashRadius: 10.r,
                            onPressed: () {
                              isComment.value = true;
                              sendComment();
                            },
                            icon: Center(
                              child: isComment.value ==
                                      false
                                  ? SvgPicture.asset(
                                      "assets/images/send.svg",
                                      colorFilter:
                                          ColorFilter.mode(
                                              comboWhiteAndBlack(),
                                              BlendMode
                                                  .srcIn),
                                      fit: BoxFit.cover,
                                      height: 30.h,
                                      width: 25.w,
                                    )
                                  : SizedBox(
                                      width: 25.w,
                                      height: 25.w,
                                      child:
                                          CircularProgressIndicator()),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
              FutureBuilder<AllComments?>(
                future: getAllComments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    if (snapshot.data != null &&
                        snapshot
                            .data!.ebookApp!.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot
                              .data!.ebookApp!.length,
                          physics:
                              NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String bookUserId = snapshot
                                .data!
                                .ebookApp![index]
                                .userId!;
                            return ListTile(
                              visualDensity: VisualDensity(
                                  vertical: 4),
                              title: Text(
                                snapshot
                                    .data!
                                    .ebookApp![index]
                                    .userName!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color:
                                      comboWhiteAndBlack(),
                                  fontFamily: "Gilroy-Bold",
                                  fontSize: 17.sp,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data!.ebookApp![index].commentText}",
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      comboWhiteAndBlack(),
                                  fontFamily:
                                      "Gilroy-SemiBold",
                                  fontSize: 14.sp,
                                ),
                              ),
                              leading: Container(
                                decoration: BoxDecoration(
                                  border: bookUserId ==
                                          userId
                                      ? Border.all(
                                          width: 2,
                                          color: Colors.red)
                                      : Border(),
                                  borderRadius:
                                      BorderRadius.circular(
                                          80.r),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                          80.r),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!
                                        .ebookApp![index]
                                        .userImage!,
                                    fit: BoxFit.cover,
                                    width: 60.w,
                                    height: 60.w,
                                    placeholder: (context,
                                            url) =>
                                        Shimmer.fromColors(
                                            baseColor:
                                                shimmerBaseColor(),
                                            highlightColor:
                                                shimmerHighlightColor(),
                                            child:
                                                Container(
                                              width: 60.w,
                                              height: 60.w,
                                              color:
                                                  comboBlackAndWhite(),
                                            )),
                                    placeholderFadeInDuration:
                                        Duration(
                                            seconds: 2),
                                    errorWidget: (context,
                                            url, error) =>
                                        Image.asset(
                                      "assets/images/noimagefound.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              trailing: Text(
                                snapshot.data!
                                    .ebookApp![index].dtRate
                                    .toString(),
                                style: TextStyle(
                                  color:
                                      comboWhiteAndBlack(),
                                  fontFamily:
                                      "Gilroy-SemiBold",
                                  fontSize: 12.sp,
                                ),
                              ),
                              onTap: bookUserId == userId
                                  ? () {
                                      if (userId != null) {
                                        showDialog(
                                                context:
                                                    context,
                                                builder:
                                                    (BuildContext
                                                        context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Delete Comment ??"),
                                                    content:
                                                        SingleChildScrollView(
                                                            child: ListBody(children: [
                                                      Text(
                                                        "${snapshot.data!.ebookApp![index].commentText}",
                                                      ),
                                                    ])),
                                                    actions: [
                                                      TextButton(
                                                        child:
                                                            Text("Cancel"),
                                                        onPressed:
                                                            () {
                                                          Get.back();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            Text("Delete"),
                                                        onPressed:
                                                            () {
                                                          Get.back();
                                                          deleteComment(snapshot.data!.ebookApp![index].id);
                                                          focusNode.unfocus();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                })
                                            .whenComplete(() =>
                                                setState(
                                                    () {}));
                                      } else {
                                        customSnackBar(
                                            context);
                                      }
                                    }
                                  : null,
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                          S
                              .of(context)
                              .details_screen_comments_NO_COMMENTS_FOUND,
                          style: TextStyle(
                            color: comboWhiteAndBlack(),
                            fontFamily: "Gilroy-SemiBold",
                            fontSize: 15.sp,
                          ),
                        ),
                      );
                    }
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(),
                      itemCount: Random().nextInt(5),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: shimmerBaseColor(),
                          highlightColor:
                              shimmerHighlightColor(),
                          child: Container(
                            width: double.infinity,
                            height: 60.w,
                            margin: EdgeInsets.all(20),
                            color: Colors.white,
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
    });
  }
}
