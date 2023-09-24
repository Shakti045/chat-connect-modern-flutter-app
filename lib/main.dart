// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:chatconnect/screens/auth.dart';
import 'package:chatconnect/screens/home.dart';
import 'firebase_options.dart';

final kdarkcolorscheeme =
    ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.black);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then((value) {
    ///  Call the `useSystemCallingUI` method
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(ProviderScope(child: MyApp(navigatorKey: navigatorKey)));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: kdarkcolorscheeme,
          scaffoldBackgroundColor: const Color.fromARGB(255, 17, 16, 16),
          appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: const Color.fromARGB(255, 17, 16, 16))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot.hasData) {
            onUserLogin();
            return const HomeScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}


void onUserLogin() async{
  // final currentuser=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

  /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
  /// when app's user is logged in or re-logged in
  /// We recommend calling this method as soon as the user logs in to your app.
  ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1490707843 /*input your AppID*/,
      appSign:
          "51531ef72fd9d57af8e8d79856f3a517b5b3bf686d68e276cf4bed0cb7a72a26" /*input your AppSign*/,
      userID: FirebaseAuth.instance.currentUser!.uid,
      userName: FirebaseAuth.instance.currentUser!.phoneNumber!,
      notifyWhenAppRunningInBackgroundOrQuit:true,
      plugins: [ZegoUIKitSignalingPlugin()],
      // requireConfig: (ZegoCallInvitationData data) {
      //   var config = (data.invitees.length > 1)
      //       ? ZegoCallType.videoCall == data.type
      //           ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
      //           : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
      //       : ZegoCallType.videoCall == data.type
      //           ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      //           : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      //   config.avatarBuilder = (BuildContext context, Size size,
      //       ZegoUIKitUser? user, Map extraInfo) {
      //     return user != null
      //         ? Container(
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               image: DecorationImage(
      //                 image: NetworkImage(
      //                   currentuser.exists?currentuser['profilephoto']:null,
      //                 ),
      //               ),
      //             ),
      //           )
      //         : const SizedBox();
      //   };
      //   return config;
      // }
      );
}

/// on App's user logout
void onUserLogout() {
  /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
  /// when app's user is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
