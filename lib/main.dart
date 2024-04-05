import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ing_mobile/features/authentication/start_checks.dart';
import 'package:ing_mobile/main_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return ChangeNotifierProvider<MainProvider>(
          create: (context) => MainProvider(),
          builder: (context, child) => const MaterialApp(
            title: "ing_mobile",
            debugShowMaterialGrid: false,
            debugShowCheckedModeBanner: false,
            home: CheckLoginStatus(),
          ),
        );
      },
      designSize: const Size(375, 812),
    );
  }
}
