import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/exploreauthor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../consttants.dart';
import 'explore.dart';

class AllAuthors extends StatelessWidget {
  const AllAuthors({Key? key, required this.bookAuthor}) : super(key: key);
  final ExploreAuthor? bookAuthor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: comboBlackAndWhite(),
      appBar: AppBar(
        backgroundColor: comboBlackAndWhite(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: comboWhiteAndBlack(),
        ),
        title: Text(S.of(context).explore_AUTHOR, style: TextStyle(color: comboWhiteAndBlack(), fontFamily: "Gilroy-Medium")),
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: bookAuthor!.ebookApp.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 10.w, mainAxisSpacing: 10.w, crossAxisCount: 2, childAspectRatio: 0.840.h),
          itemBuilder: (context, index) {
            return AuthorView(
              authorName: bookAuthor!.ebookApp[index].authorName,
              authorImage: bookAuthor!.ebookApp[index].authorImage,
              authid: int.parse(bookAuthor!.ebookApp[index].authorId),
              authorDescription: bookAuthor!.ebookApp[index].authorDescription,
            );
          },
        ),
      ),
    );
  }
}
