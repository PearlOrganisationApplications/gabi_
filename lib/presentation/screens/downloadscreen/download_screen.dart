import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';

import '../../../utils/systemuioverlay/full_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadScreen> {
  List<Map> downloadsListMaps= [];

  /*Future task() async {
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
    setState(() {});
  }*/

  @override
  void initState() {
    //_bindBackgroundIsolate();
    //FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    //_unbindBackgroundIsolate();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.amber);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        title: Text('Downloads', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Image.asset('assets/icons/everywhere_icon.png',)),
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<DownloadTask>?>(
          future: FlutterDownloader.loadTasks(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }else if(snapshot.data!.length == 0){
              return Center(child: Text('No Downloads yet'));
            }else{
              snapshot.data!.forEach((_task) {
                Map _map = Map();
                _map['status'] = _task.status;
                _map['progress'] = _task.progress;
                _map['id'] = _task.taskId;
                _map['filename'] = _task.filename;
                _map['savedDirectory'] = _task.savedDir;
                downloadsListMaps.add(_map);
              });

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int i) {

                  return StreamBuilder<DownloadTask?>(
                    stream: _downloadProgress(taskId: snapshot.data![i].taskId),
                    builder: (context, snapshot) {
                      if(snapshot.data != null){
                        return Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                                isThreeLine: false,
                                title: Text('${snapshot.data!.filename}'),
                                subtitle: downloadStatus(snapshot.data!.status),
                                trailing: SizedBox(
                                  child: buttons(snapshot.data!.status, snapshot.data!.taskId, i),
                                  width: 60,
                                ),
                              ),
                              snapshot.data!.status == DownloadTaskStatus.complete ? Container() : SizedBox(height: 5),
                              snapshot.data!.status == DownloadTaskStatus.complete ? Container() : Padding(padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${snapshot.data?.progress??0}%'),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: snapshot.data!.progress/ 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10)
                            ],
                          ),
                        );
                      }else{
                        return Container();
                      }
                  },);
                },
              );
            }
          },
        ),


      ),
    );
  }



  Widget downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? Text('Download canceled')
        : _status == DownloadTaskStatus.complete
        ? Text('Download completed')
        : _status == DownloadTaskStatus.failed
        ? Text('Download failed')
        : _status == DownloadTaskStatus.paused
        ? Text('Download paused')
        : _status == DownloadTaskStatus.running
        ? Text('Downloading..')
        : Text('Download waiting');
  }

  Widget buttons(DownloadTaskStatus _status, String taskid, int index) {
    void changeTaskID(String taskid, String newTaskID) {
      Map? task = downloadsListMaps?.firstWhere(
            (element) => element['taskId'] == taskid,

      );
      task!['taskId'] = newTaskID;
      setState(() {});
    }
    return _status == DownloadTaskStatus.canceled
        ? GestureDetector(
      child: Icon(Icons.cached, size: 20, color: Colors.green),
      onTap: () {
        FlutterDownloader.retry(taskId: taskid)
            .then((newTaskID) {
          changeTaskID(taskid, newTaskID!);
        });
      },
    )
        : _status == DownloadTaskStatus.failed
        ? GestureDetector(
      child: Icon(Icons.cached, size: 20, color: Colors.green),
      onTap: () {
        FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
          changeTaskID(taskid, newTaskID!);
        });
        setState(() {

        });
      },
    )
        : _status == DownloadTaskStatus.paused
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.play_arrow,
              size: 20, color: Colors.blue),
          onTap: () {
            FlutterDownloader.resume(taskId: taskid).then(
                  (newTaskID) => changeTaskID(taskid, newTaskID!),
            );
          },
        ),
        GestureDetector(
          child: Icon(Icons.close, size: 20, color: Colors.red),
          onTap: () {
            FlutterDownloader.cancel(taskId: taskid);
          },
        )
      ],
    )
        : _status == DownloadTaskStatus.running
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.pause,
              size: 20, color: Colors.green),
          onTap: () {
            FlutterDownloader.pause(taskId: taskid);
          },
        ),
        GestureDetector(
          child:
          Icon(Icons.close, size: 20, color: Colors.red),
          onTap: () {
            FlutterDownloader.cancel(taskId: taskid);
          },
        )
      ],
    )
        : _status == DownloadTaskStatus.complete
        ? GestureDetector(
      child:
      Icon(Icons.play_arrow_rounded, size: 20, color: Colors.green),
      onTap: () {
        /*downloadsListMaps.removeAt(index);
        FlutterDownloader.remove(
            taskId: taskid, shouldDeleteContent: true);
        setState(() {});*/
        OpenFile.open('${downloadsListMaps[index]['savedDirectory']}${Platform.pathSeparator}${downloadsListMaps[index]['filename']}');
      },
    )
        : Container();
  }

  Stream<DownloadTask?> _downloadProgress({required String taskId}) async* {
    while (true) {
      DownloadTask? task;
      try {
        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task');

        task = tasks?.firstWhere((task) => task.taskId == taskId);
      } catch (e) {
        print(e);
      }
      yield task;

      await Future.delayed(Duration(microseconds: 100));

    }
  }

}
