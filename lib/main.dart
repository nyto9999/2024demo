import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/auth/usecases/auth_usecases.dart';
import 'package:house/bootstrap.dart';
import 'package:house/router.dart';

Future<void> main() async {
  await bootstrap();

  runApp(
    RepositoryProvider(
      lazy: false,
      create: (context) => AuthRepo(
          authUsecases: AuthUsecases(
        firebaseAuth: FirebaseAuth.instance,
      )),
      child: const App(),
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
        );
      },
    );
  }
}

 

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