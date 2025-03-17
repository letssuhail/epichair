import 'dart:convert';
import 'dart:io';
import 'package:epic/components/custom_text.dart';
import 'package:epic/components/custom_text_field.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/consts/const.dart';
import 'package:epic/user/providers/logout_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart'; // For getting file names
import 'package:path_provider/path_provider.dart'; // Persistent storage
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../user/models/user_profile_model.dart';

// Define the provider for the LogoutNotifier
final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
  return LogoutNotifier(ref);
});

class StaffProfileScreen extends ConsumerStatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffProfileScreenState();
}

class _StaffProfileScreenState extends ConsumerState<StaffProfileScreen> {
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
    prefs.setString('staffImagePath', savedImage.path);
  }

  // Function to update profile
  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if token exists
    String? token = prefs.getString('userToken');
    // log(token.toString());

    // String token = userToken;
    setState(() {
      _isLoading = true;
    });

    String name = nameController.text;
    String url = 'https://epichair.vercel.app/api/staff/profile';

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
        prefs.setString('staffName', name);
        if (_profileImage != null) {
          prefs.setString('staffImagePath', _profileImage!.path);
        }
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        var responseBody = await response.stream.bytesToString();
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Failed to update profile: $responseBody')),
        );
      }
    } catch (e) {
      print(e);
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
            style: TextStyle(color: red),
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
    _fetchProfileData();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');
    String? imagePath = prefs.getString('staffImagePath');

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
      const url = 'https://epichair.vercel.app/api/staff/profile';

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final userProfile = StaffProfile.fromJson(data['user']);

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: customTextOne(
            text: 'Profile',
            fontweight: FontWeight.bold,
            fontsize: 16,
            textcolor: newGrey,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context, ref);
              },
              icon: Icon(
                Icons.logout,
                color: black,
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile picture and edit button
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          Colors.grey.shade300, // Fallback background color
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : (_profileImageUrl != null &&
                                  _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!) as ImageProvider
                              : null), // If no image, fallback to child
                      child: (_profileImage == null &&
                              (_profileImageUrl == null ||
                                  _profileImageUrl!.isEmpty))
                          ? Icon(Icons.person, color: Colors.white, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: red),
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.add,
                            size: 25,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                customTextField(
                  backgroundColor: grey.withOpacity(.3),
                  labeltext: 'Name',
                  keyboardtype: TextInputType.text,
                  obscureText: false,
                  controller: nameController,
                  hinttext: _username ?? 'New Name',
                  context: context,
                  textcolor: black,
                  hintcolor: black,
                  borderColor: grey,
                  fontsize: 12,
                  textfieldfontsize: 12,
                  fontWeight: FontWeight.bold,
                  textalign: TextAlign.center,
                ),
                SizedBox(height: 20.sp),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          )),
                      onPressed: _isLoading
                          ? null
                          : _updateProfile, // Update button action
                      child: customTextWithAlignment(
                          text: _isLoading ? 'Updating...' : 'Update',
                          fontweight: FontWeight.bold,
                          fontsize: 12,
                          textcolor: white,
                          textalign: TextAlign.center)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
