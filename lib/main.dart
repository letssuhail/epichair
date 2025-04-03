import 'package:epic/consts/colors.dart';
import 'package:epic/user/views/screens/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _hasCheckedForUpdates = false;

  Future<void> _checkForUpdates(BuildContext context) async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Show the update prompt based on the update type
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate();
          });
        }
      }
    } catch (e) {
      // Handle error, e.g., show a toast
      Fluttertoast.showToast(msg: "Failed to check for updates: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedForUpdates) {
      _hasCheckedForUpdates = true; // Prevent multiple calls
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForUpdates(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          builder: (context, child) {
            return Scaffold(
                backgroundColor: black,
                body: Center(
                  child: Container(
                    width: 420,
                    constraints: BoxConstraints(maxWidth: 420),
                    child: child,
                  ),
                ));
          },
          home: SplashScreen(),
        );
      },
    );
  }
}
