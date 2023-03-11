// import 'package:apivideo_live_stream/apivideo_live_stream.dart';
// import 'package:flutter/material.dart';

// class LiveStreaming extends StatefulWidget {
//   const LiveStreaming({super.key});

//   @override
//   State<LiveStreaming> createState() => _LiveStreamingState();
// }

// class _LiveStreamingState extends State<LiveStreaming> {
//   final ApiVideoLiveStreamController _controller = ApiVideoLiveStreamController(
//     initialAudioConfig: AudioConfig(),
//     initialVideoConfig: VideoConfig.withDefaultBitrate(),
//   );
//   void initState() {
//     WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
//     _controller.initialize().catchError((e) {
//       showInSnackBar(e.toString());
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }

//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }
// }
