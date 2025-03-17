import 'dart:convert';
import 'package:epic/consts/colors.dart';
import 'package:epic/user%20decide%20screen/user_type_decide_screen.dart';
import 'package:epic/user/views/screens/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final startupScreenProvider = FutureProvider<Widget>((ref) async {
  // Get SharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if token exists
  String? token = prefs.getString('userToken');

  // const token = userToken;
  // log(token.toString());

  if (token != null && token.isNotEmpty) {
    // Decode the token to get the payload
    final parts = token.split('.');
    if (parts.length == 3) {
      // Decode base64-encoded payload
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decodedPayload = jsonDecode(payload);

      // Check if the role is 'staff'
      final role = decodedPayload['role'];
      bool isStaff = role == 'staff';

      // Navigate to SplashScreen with the correct isStaff value
      return SplashScreen(isStaff: isStaff);
    } else {
      // Token is invalid, navigate to UserTypeDecideScreen
      return const UserTypeDecideScreen();
    }
  } else {
    // No token, navigate to UserTypeDecideScreen
    return const UserTypeDecideScreen();
  }
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupScreen = ref.watch(startupScreenProvider);
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Change the status bar color
      statusBarIconBrightness:
          Brightness.light, // Use light icons for better contrast
    ));
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return startupScreen.when(
          data: (screen) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Epic Hair Studio',
            theme: ThemeData(
              fontFamily: 'Crimson',
              useMaterial3: true,
            ),
            home: screen, // Show the screen returned by the provider
          ),
          loading: () => MaterialApp(
            color: background,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: background,
              body: Center(
                child: CircularProgressIndicator(
                  color: red,
                ),
              ),
            ),
          ),
          error: (err, stack) => MaterialApp(
            color: background,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: background,
              body: Center(
                child: Text('Try again error: $err'),
              ),
            ),
          ),
        );
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return ResponsiveSizer(builder: (context, orientation, screenType) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           fontFamily: 'Aboreto',
//           useMaterial3: true,
//         ),
//         home: BottomNavBarClient(),
//       );
//     });
//   }
// }
