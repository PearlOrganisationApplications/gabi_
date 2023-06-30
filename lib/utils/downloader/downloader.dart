

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDownloader {

  static late final ReceivePort port;

  static Future<void> requestDownload(String url, String name) async {
    if (await Permission.storage.status != PermissionStatus.granted) {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.denied) {
        EasyLoading.showError(
            'Permission required! to download file!', dismissOnTap: true,
            duration: Duration(seconds: 3));
      } else if (status == PermissionStatus.permanentlyDenied) {
        EasyLoading.showError(
            'Permission required to download this file!', dismissOnTap: true,
            duration: Duration(seconds: 3));
        Future.delayed(Duration(seconds: 3), () {
          openAppSettings();
        });
      }
      else {
        _startDownload(url: url, name: name);
      }
    }else {
      _startDownload(url: url, name: name);
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }


  static Future<void> clearDownloadTasks() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    if(tasks != null){
      for (DownloadTask task in tasks) {
        await FlutterDownloader.cancel(taskId: task.taskId);
        await FlutterDownloader.remove(taskId: task.taskId, shouldDeleteContent: false);
      }
    }
  }

  static Future<void> _startDownload({required String url, required String name}) async {
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await getExternalStorageDirectory();
    }else {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    final savedDir = Platform.isAndroid?'${downloadsDirectory?.path}/Downloads':downloadsDirectory?.path;
    if (savedDir != null) {
      String? _taskid = await FlutterDownloader.enqueue(
        url: url,
        fileName: name,
        savedDir: savedDir,
        showNotification: true,
        openFileFromNotification: true,
      );
      print('id0 ${_taskid}, $savedDir');
      if (_taskid != null) {
        //FlutterDownloader.registerCallback(downloadCallback);
      }
    } else {
      print("No download folder found.");
    }
  }

  static void init() {
    port = ReceivePort();
    IsolateNameServer.registerPortWithName(MyDownloader.port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(MyDownloader.downloadCallback);
  }
}

