

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Download {




  static Future<void> requestDownload(String _url, String _name) async {
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
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = await getDownloadsDirectory();
        }else {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }

        final savedDir = downloadsDirectory?.path;
        if (savedDir != null) {
          String? _taskid = await FlutterDownloader.enqueue(
            url: _url,
            fileName: _name,
            savedDir: savedDir,
            showNotification: true,
            openFileFromNotification: true,
          );
          print('id0 ${_taskid}');
          if (_taskid != null) {
            FlutterDownloader.registerCallback(
                downloadCallback); //output: /storage/emulated/0/Download
          }
        } else {
          print("No download folder found.");
        }
      }
    }else {
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getDownloadsDirectory();
      }else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      final savedDir = downloadsDirectory?.path;
      if (savedDir != null) {
        String? _taskid = await FlutterDownloader.enqueue(
          url: _url,
          fileName: _name,
          savedDir: savedDir,
          showNotification: true,
          openFileFromNotification: true,
        );
        print('id0 ${_taskid}');
        if (_taskid != null) {
          FlutterDownloader.registerCallback(
              downloadCallback); //output: /storage/emulated/0/Download
        }
      } else {
        print("No download folder found.");
      }
    }
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);

    if(progress <= 10){
      EasyLoading.showSuccess('Hello');
    }
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

}

