import 'dart:convert';
// import 'dart:isolate';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../consttants.dart';

const debug = true;

class PdfViewerPage extends StatefulWidget {
  PdfViewerPage(
      {required this.bookid, required this.bookTitle, required this.image});

  final int bookid;
  final String bookTitle;
  final String image;

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;

  Future loadPDF() async {
    var response = await http.get(Uri.parse(
        "$apiLink/api.php?method_name=book_id&book_id=${widget.bookid}"));
    var jsonResponse = jsonDecode(response.body);
    localPath = jsonResponse["EBOOK_APP"][0]["book_file_url"];
    setState(() {});
  }

  @override
  void initState() {
    loadPDF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: comboBlackAndWhite(),
      appBar: AppBar(
        backgroundColor: comboBlackAndWhite(),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.h.w,
              color: comboWhiteAndBlack(),
            ),
            onPressed: () {
              Get.back();
            }),
        title: Text(
          "${widget.bookTitle}",
          style:
              TextStyle(fontFamily: 'Gilroy-Bold', color: comboWhiteAndBlack()),
        ),
      ),

      ///progress bar with colored indicator
      body: localPath != null
          ? SfPdfViewer.network(localPath!)
          : Container(color: Colors.grey.shade300),
    );
  }

  // static void downloadCallback(String id, int status, int progress) {
  //   if (debug) {}
  //   final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }
}
