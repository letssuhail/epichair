import 'dart:convert';
import 'dart:io';
import 'package:epic/components/custom_text.dart';
import 'package:epic/components/custom_text_field.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user%20decide%20screen/user_type_decide_screen.dart';
import 'package:epic/user/models/user_profile_model.dart';
import 'package:epic/user/providers/logout_notifier.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/profile_screen/CommunityGuidelinesScreen/CommunityGuidelinesScreen.dart';
import 'package:epic/user/views/screens/profile_screen/about%20us/about_us_screen.dart';
import 'package:epic/user/views/screens/profile_screen/privacy%20policy/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the provider for the LogoutNotifier
final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
  return LogoutNotifier(ref);
});

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isHomeScreen;
  const ProfileScreen({super.key, required this.isHomeScreen});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController nameController = TextEditingController();
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    // Get the app's documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(pickedImage.path);
    final savedImage =
        await File(pickedImage.path).copy('${appDir.path}/$fileName');

    setState(() {
      _profileImage = XFile(savedImage.path); // Use the new saved path
    });

    // Save the path in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserImagePath', savedImage.path);
  }

  // Function to update profile
  Future<void> _updateProfile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    // const token = userToken;
    // log(token.toString());
    setState(() {
      _isLoading = true;
    });

    String name = nameController.text;
    String url = 'https://epichair.vercel.app/api/user/profile';

    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Adding Authorization Header (with token)
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Adding the name field
      request.fields['name'] = name;

      // Adding the image file if selected
      if (_profileImage != null) {
        var file = await http.MultipartFile.fromPath(
          'image',
          _profileImage!.path,
          filename: basename(_profileImage!.path),
        );
        request.files.add(file);
      }

      // Sending the request
      var response = await request.send();

      // Checking response status
      if (response.statusCode == 200) {
        // Update the saved user name and image path in local storage
        prefs.setString('UserName', name);
        if (_profileImage != null) {
          prefs.setString('UserImagePath', _profileImage!.path);
        }

        widget.isHomeScreen ? Navigator.pop(context) : null;

        Fluttertoast.showToast(msg: 'Profile updated successfully');
      } else {
        // var responseBody = await response.stream.bytesToString();

        Fluttertoast.showToast(msg: 'Failed to update profile:');
      }
    } catch (e) {
      // print(e);
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showLogoutConfirmationDialog(
      BuildContext context, WidgetRef ref) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          title: Text(
            'Logout',
            style: TextStyle(color: newGrey),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: black),
              ),
              onPressed: () async {
                ref.read(logoutProvider.notifier).logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _fetchProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');
    String? imagePath = prefs.getString('UserImagePath');

    if (name != null) {
      nameController.text = name;
    }
    if (imagePath != null) {
      setState(() {
        _profileImage = XFile(imagePath);
      });
    }
  }

  String? _username;
  String? _profileImageUrl;

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    // const token = userToken;

    if (token != null) {
      const url = 'https://epichair.vercel.app/api/user/profile';

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final userProfile = UserProfile.fromJson(data['user']);

          // Save profile data to local storage
          prefs.setString(
              'username', userProfile.username ?? 'Enter your name');
          prefs.setString('profileImageUrl', userProfile.imageUrl!);

          setState(() {
            _username = prefs.getString('username');
            _profileImageUrl = prefs.getString('profileImageUrl');
          });
        }
      } catch (e) {
        // log('Error fetching profile data: $e');
      }
    }
  }

  // API function to delete the account
  Future<void> _deleteAccount(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    // const token = userToken;
    const String apiUrl =
        'https://epichair.vercel.app/api/user/profile'; // Replace with your actual API URL

    try {
      // Making a DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Bearer $token', // Assuming you're using Bearer Token for authorization
        },
      );

      if (response.statusCode == 200) {
        // API response is successful, delete user data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear saved data

        Fluttertoast.showToast(msg: 'Account deleted successfully!');

        // After successful deletion, log the user out and navigate to login
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserTypeDecideScreen()),
          (route) => false,
        );
      } else {
        // Handle error response from API
        Fluttertoast.showToast(
            msg: 'Failed to delete account. Please try again later.');
      }
    } catch (e) {
      // Handle any errors that may occur during the API call
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          // automaticallyImplyLeading: false,
          backgroundColor: background,
          elevation: 0,
          title: customTextOne(
            text: 'PROFILE',
            fontweight: FontWeight.bold,
            fontsize: screenWidth > 360 ? 13 : 10,
            textcolor: black,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: blue,
                              backgroundImage: _profileImage != null
                                  ? FileImage(File(_profileImage!.path))
                                      as ImageProvider
                                  : (_profileImageUrl != null &&
                                          _profileImageUrl!.isNotEmpty
                                      ? NetworkImage(_profileImageUrl!)
                                      : null),
                              child: (_profileImage == null &&
                                      (_profileImageUrl == null ||
                                          _profileImageUrl!.isEmpty))
                                  ? const Icon(Icons.person,
                                      color: Colors.white, size: 60)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: red,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: _pickImage,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.add, color: white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 100,
                          width: 200,
                          child: customTextField(
                            backgroundColor: white,
                            labeltext: '',
                            hinttext: _username ?? 'New Name',
                            keyboardtype: TextInputType.text,
                            obscureText: false,
                            hintcolor: black,
                            controller: nameController,
                            context: context,
                            textcolor: black,
                            borderColor: lightfontgrey,
                            fontsize: screenWidth > 360 ? 13 : 10,
                            textfieldfontsize: screenWidth > 360 ? 13 : 10,
                            fontWeight: FontWeight.bold,
                            textalign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {
                            pushScreenTo(context, const AboutUsScreen());
                          },
                          title: customTextOne(
                            text: 'ABOUT US',
                            fontweight: FontWeight.bold,
                            fontsize: screenWidth > 360 ? 12 : 10,
                            textcolor: black,
                          ),
                          leading: const Icon(Icons.adb_outlined),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primary,
                            size: 14,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: lightfontgrey,
                        ),
                        ListTile(
                          onTap: () {
                            pushScreenTo(context, const PrivacyPolicyScreen());
                          },
                          title: customTextOne(
                            text: 'PRIVACY POLICY',
                            fontweight: FontWeight.bold,
                            fontsize: screenWidth > 360 ? 12 : 10,
                            textcolor: black,
                          ),
                          leading: const Icon(Icons.shield_outlined),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primary,
                            size: 14,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: lightfontgrey,
                        ),
                        ListTile(
                          onTap: () {
                            pushScreenTo(
                                context, const CommunityGuidelinesScreen());
                          },
                          title: customTextOne(
                            text: 'COMMUNITY GUIDELINES',
                            fontweight: FontWeight.bold,
                            fontsize: screenWidth > 360 ? 12 : 10,
                            textcolor: black,
                          ),
                          leading: const Icon(Icons.question_mark),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primary,
                            size: 14,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: lightfontgrey,
                        ),
                        ListTile(
                          onTap: () => _deleteAccount(context),
                          title: customTextOne(
                            text: 'DELETE ACCOUNT',
                            fontweight: FontWeight.bold,
                            fontsize: screenWidth > 360 ? 12 : 10,
                            textcolor: black,
                          ),
                          leading: const Icon(Icons.delete_forever),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primary,
                            size: 14,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: lightfontgrey,
                        ),
                        ListTile(
                          onTap: () {
                            _showLogoutConfirmationDialog(context, ref);
                          },
                          title: customTextOne(
                            text: 'LOG OUT',
                            fontweight: FontWeight.bold,
                            fontsize: screenWidth > 360 ? 12 : 10,
                            textcolor: black,
                          ),
                          leading: const Icon(Icons.logout_rounded),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: primary,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              )),
                          onPressed: _isLoading
                              ? null
                              : () => _updateProfile(
                                  context), // Update button action
                          child: customTextWithAlignment(
                              text: _isLoading ? 'Updating...' : 'Update',
                              fontweight: FontWeight.bold,
                              fontsize: 12,
                              textcolor: white,
                              textalign: TextAlign.center)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
