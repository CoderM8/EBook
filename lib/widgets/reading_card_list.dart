import 'dart:convert';

import 'package:elearn/consttants.dart';
import 'package:elearn/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../epub_viewer_lib/epub_viewer.dart';
import '../epub_viewer_lib/model/epub_locator.dart';
import '../epub_viewer_lib/utils/util.dart';

class ReadingListCard extends StatelessWidget {
  final String bookImage;
  final VoidCallback onTap;

  ReadingListCard({Key? key, required this.bookImage, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: Imageview(
            image: bookImage,
            width: 160.r,
            height: 240.r,
            radius: 8.r,
          ),
        ));
  }
}

class EpuB extends StatefulWidget {
  EpuB({required this.id, required this.path});

  final int id;
  final String path;

  @override
  _EpuBState createState() => _EpuBState();
}

class _EpuBState extends State<EpuB> {
  EpubLocator? epubLocator;

  @override
  void initState() {
    Get.back();
    epubLocator = EpubLocator();
    EpubViewer.setConfig(
        themeColorMaterial: Colors.blue,
        identifier: "book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: true,
        enableTts: true,
        nightMode: mode.value == true ? true : false);
    open();
    super.initState();
  }

  open() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? locatorPref = pref.getString('locator');
    EpubViewer.locatorStream.listen((locator) {});
    try {
      if (locatorPref != null) {
        Map<String, dynamic> r = jsonDecode(locatorPref);
        setState(() {
          epubLocator = EpubLocator.fromJson(r);
        });
      }
    } on Exception catch (e, t) {
      print('EPUB Error ==== jsonDecode $e  $t');
      epubLocator = EpubLocator();
      pref.remove('locator');
    }

    try {
      EpubViewer.open(widget.path, lastLocation: epubLocator);
    } catch (e, t) {
      print('EPUB Error==== open $e  $t');
    }
    EpubViewer.locatorStream.listen((locator) {
      pref.clear();
      pref.remove('locator');
      pref.setString('locator', locator);
      print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
