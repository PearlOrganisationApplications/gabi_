


import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_status_notifier.dart';

class DownloadsNotifier extends StateNotifier<ConnectivityStatus> {

  List<Map> downloadsListMaps= [];

  DownloadsNotifier(super.state);


  Future getTasks() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    getTasks?.forEach((_task) {
      Map _map = Map();
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      downloadsListMaps.add(_map);
    });
  }
}