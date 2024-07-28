import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/auth/bloc/user_role/user_role_cubit.dart';
import 'package:house/auth/methods/auth/auth_platform_factory.dart';
import 'package:house/auth/methods/loacl_auth/local_auth_methods.dart';
import 'package:house/bootstrap.dart';

import 'package:house/firestore/firestore_repo.dart';
import 'package:house/router/router.dart';
import 'package:local_auth/local_auth.dart';

final auth = FirebaseAuth.instance;
final store = FirebaseFirestore.instance;

final firestoreRepo = FireStoreRepo();

Future<void> main() async {
  await bootstrap();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          lazy: false,
          create: (context) => AuthRepo(
            authMethods: AuthPlatformFactory.get(),
          ),
        ),
        RepositoryProvider(
          lazy: false,
          create: (context) =>
              LocalAuthMethods(localAuth: LocalAuthentication()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserRoleCubit()..init(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (__, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Colors.indigoAccent)),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

// Future<void> setupFirebaseMessaging() async {
//   // 獲取 FCM token
//   String? token = await fcm.getToken();
//   if (token != null) {
//     try {
//       await store
//           .collection('userRoles')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update({'fcmToken': token});
//     } catch (e) {
//       print('Error saving FCM token: $e');
//     }
//   }

//   // 監聽 token 刷新
//   fcm.onTokenRefresh.listen((newToken) async {
//     debugPrint('New FCM token: $newToken');
//     await firestoreRepo.saveFcmToken(newToken); // 注意這裡
//   });

//   // 處理前台消息
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Received message while in foreground: ${message.messageId}');
//     // 這裡你可以顯示通知或更新UI
//   });

//   // 處理背景消息
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// }

// 背景消息處理函數
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }

// 調整畫面可以用這個

// Future<void> main() async {
//   await bootstrap();
//   const method = int.fromEnvironment('method', defaultValue: 1);
 

//   runApp(DevicePreview(
//       enabled: kDebugMode && kIsWeb,
//       tools: const [
//         ...DevicePreview.defaultTools,
//       ],
//       builder: (context) => const App()));
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routerConfig: router,
//       builder: DevicePreview.appBuilder,
//       locale: DevicePreview.locale(context),
//       title: '居家媒合APP',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//     );
//   }
// }