import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elearn/databasefavourite/db.dart';
import 'package:elearn/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../consttants.dart';

RxBool down = false.obs;

class DownloadAlert extends StatefulWidget {
  final String url;
  final String path;
  final int id;

  DownloadAlert(
      {Key? key, required this.url, required this.path, required this.id})
      : super(key: key);

  @override
  _DownloadAlertState createState() => _DownloadAlertState();
}

class _DownloadAlertState extends State<DownloadAlert> {
  Dio dio = Dio();
  int received = 0;
  String progress = '0';
  int total = 0;
  CancelToken cancelToken = CancelToken();

  download() async {
    try {
      await dio.download(
        widget.url,
        widget.path,
        options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
        deleteOnError: true,
        cancelToken: cancelToken,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print('receivedBytes :: $receivedBytes');
          print('totalBytes :: $totalBytes');

          setState(() {
            received = receivedBytes;
            total = totalBytes != -1
                ? totalBytes
                : receivedBytes; // Handle unknown totalBytes
            progress = (received / total * 100).toStringAsFixed(0);
            down.value = true;
          });

          // setState(() {
          //   if (totalBytes != -1) {
          //     received = receivedBytes;
          //     total = totalBytes;
          //     progress = (received / total * 100).toStringAsFixed(0);
          //     down.value = true;
          //   }
          // });
          // if (receivedBytes == totalBytes) {
          //   Navigator.pop(context, '${Constants.formatBytes(total, 1)}');
          // }
        },
      );
      _onDownloadComplete(received);
    } on DioException catch (e) {
      print("HELLO ${e.error}  ${e.message}");
      cancelToken.cancel("Error");
      down.value = false;
      DatabaseHelper.instance.deleteDownLoad(widget.id);
      customSnackBar(context, title: "${e.message}");
      Get.back();
    }
  }

  void _onDownloadComplete(int totalBytes) {
    // Update UI or perform any actions after download success
    // Navigator.pop(context, '${Constants.formatBytes(totalBytes, 1)}');
    // Additional actions like saving to database can be done here
    // print('Download completed: ${Constants.formatBytes(totalBytes, 1)}');
    // Optionally, show a success message
    Get.back();
    customSnackBar(context, title: "Download completed successfully");
  }

  downl() async {
    await download();
  }

  @override
  void initState() {
    downl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => Future.value(false),
      child: CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20.0.h.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Downloading...',
                style: TextStyle(fontSize: 15.0, fontFamily: "Gilroy-Bold"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20.0.h),
              Center(
                child: CircularProgressIndicator(),
              )
              // Container(
              //   height: 5.h,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(10.r),
              //     ),
              //   ),
              //   child: LinearProgressIndicator(
              //     value: double.parse(progress) / 100.0,
              //     valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
              //     backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              //   ),
              // ),
              // SizedBox(height: 5.0.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       '$progress %',
              //       style: TextStyle(fontSize: 13.0.sp, fontFamily: "Gilroy-Medium"),
              //       maxLines: 2,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //     // Text(
              //     //   '${Constants.formatBytes(received, 1)} '
              //     //   'of ${Constants.formatBytes(total, 1)}',
              //     //   style: TextStyle(fontSize: 13.0.sp, fontFamily: "Gilroy-Medium"),
              //     //   maxLines: 2,
              //     //   overflow: TextOverflow.ellipsis,
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
