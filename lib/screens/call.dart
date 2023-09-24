// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:flutter/material.dart';

// const int appid = 1490707843;
// const String appsign =
//     "51531ef72fd9d57af8e8d79856f3a517b5b3bf686d68e276cf4bed0cb7a72a26";

// class CallPage extends StatelessWidget {
//   const CallPage({Key? key, required this.callID,required this.userid,required this.username}) : super(key: key);
//   final String callID;
//   final String userid;
//   final String username;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID:
//           appid, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign:
//           appsign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: userid,
//       userName: username,
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//         ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
//     );
//   }
// }
