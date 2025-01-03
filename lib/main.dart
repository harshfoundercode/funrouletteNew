import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funroullete_new/Constant/shared_preference.dart';
import 'package:funroullete_new/Provider/profile_provider.dart';
import 'package:funroullete_new/Provider/result_history_provider.dart';
import 'package:funroullete_new/Provider/result_provider.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Views/splash_screen.dart';
import 'package:funroullete_new/api/auth-service-.dart';
import 'package:funroullete_new/api/bet-service.dart';
import 'package:funroullete_new/api/take-winning-amount-service.dart';
import 'package:provider/provider.dart';


double height = 360.0;
double width = 720.0;
double ratio = 2;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  _initializeSharedPreferences();
  runApp(const MyApp());
}

Future<void> _initializeSharedPreferences() async {
  try {
    await SharedPreferencesUtil.init();

  } catch (e) {
    print("Error initializing SharedPreferences: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double heightRatio = MediaQuery.of(context).size.height;
    double widthRatio = MediaQuery.of(context).size.width;
    ratio = widthRatio / heightRatio;
    height = heightRatio;
    width = widthRatio;
    // width = heightRatio * double.parse(ratio.toStringAsFixed(1));
    final userId= SharedPreferencesUtil.getUserId();
    print("userid:$userId");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_)=>AuthService()),
        ChangeNotifierProvider(create: (context)=>UserProvider(context.read<AuthService>())),
        ChangeNotifierProvider(create: (context)=>BetService()),
        ChangeNotifierProvider(create: (context)=>ResultHistoryProvider()),
        ChangeNotifierProvider(create: (context)=>ResultProvider()),
        ChangeNotifierProvider(create: (context)=>ProfileProvider()),
        ChangeNotifierProvider(create: (context)=>WinningAmountService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FunRoulette',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}