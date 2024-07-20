import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elearn/widgets/download_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DetailsProvider extends ChangeNotifier {
  bool loading = true;
  RxBool barrierDismissible = false.obs;

  Future<void> downloadFile(BuildContext context,
      {required String url,
      required String filename,
      required int id,
      required String img}) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory(appDocDir!.path + '/Ebook').create();
    }
    try {
      String path = Platform.isIOS
          ? '${appDocDir!.path}/$filename.epub'
          : appDocDir!.path + '/Ebook/$filename.epub';
      File file = File(path);
      if (!await file.exists()) {
        await file.create();
      } else {
        await file.delete();
        await file.create();
      }
      print('file path :: ${file.path}');
      print('file url :: ${url}');

      try {
        await showDialog(
          barrierDismissible: barrierDismissible.value,
          context: context,
          builder: (context) => PopScope(
              canPop: barrierDismissible.value,
              child: DownloadAlert(url: url, path: path, id: id)),
        ).then((v) {
          if (v != null) {
            barrierDismissible.value = true;
            notifyListeners();
          }
        });
      } catch (e) {
        print('download error :: $e');
      }
      ;
    } on DioException catch (e) {
      print('DioException $e');
      print('DioException ${e.message}');
    }
    notifyListeners();
  }
}
