import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epic/components/custom_text.dart';
import 'package:epic/components/custom_text_field.dart';
import 'package:epic/consts/colors.dart';
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
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isOnHoliday = false;
  String? _username;
  String? _profileImageUrl;

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
    if (name != null) nameController.text = name;
    if (imagePath != null) {
      setState(() {
        _profileImage = XFile(imagePath);
      });
    }
  }

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
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
          prefs.setString(
              'username', userProfile.username ?? 'Enter your name');
          prefs.setString('profileImageUrl', userProfile.imageUrl ?? '');
          prefs.setBool('isOnHoliday', userProfile.isOnHoliday ?? false);
          if (userProfile.workingHours != null) {
            prefs.setString(
                'workingHours', jsonEncode(userProfile.workingHours));
          }
          setState(() {
            _username = prefs.getString('username');
            _profileImageUrl = prefs.getString('profileImageUrl');
            _isOnHoliday = prefs.getBool('isOnHoliday') ?? false;
            final workingHoursStr = prefs.getString('workingHours');
            if (workingHoursStr != null) {
              final workingHours =
                  jsonDecode(workingHoursStr) as Map<String, dynamic>;
              _startTimeController.text = workingHours['start'] ?? '09:00';
              _endTimeController.text = workingHours['end'] ?? '18:00';
            }
          });
        }
      } catch (_) {}
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(pickedImage.path);
    final savedImage =
        await File(pickedImage.path).copy('${appDir.path}/$fileName');

    setState(() {
      _profileImage = XFile(savedImage.path);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('staffImagePath', savedImage.path);
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    setState(() {
      _isLoading = true;
    });

    String name = nameController.text;
    String url = 'https://epichair.vercel.app/api/staff/profile';

    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['name'] = name;
      request.fields['isOnHoliday'] = _isOnHoliday.toString();

      Map<String, String> workingHours = {
        'start': _startTimeController.text,
        'end': _endTimeController.text,
      };
      request.fields['workingHours'] = jsonEncode(workingHours);

      if (_profileImage != null) {
        var file = await http.MultipartFile.fromPath(
          'image',
          _profileImage!.path,
          filename: basename(_profileImage!.path),
        );
        request.files.add(file);
      }

      var response = await request.send();

      log('response ${response}');

      if (response.statusCode == 200) {
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
        double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          backgroundColor: background,
          title: Text(
            'Logout',
            style: TextStyle(
              color: black,
              fontSize: screenWidth > 360 ? 18 : 14,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style:
                TextStyle(color: black, fontSize: screenWidth > 360 ? 16 : 12),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      color: black, fontSize: screenWidth > 360 ? 16 : 12)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      color: black, fontSize: screenWidth > 360 ? 16 : 12)),
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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: customTextOne(
            text: 'Profile',
            fontweight: FontWeight.bold,
            fontsize: screenWidth > 360 ? 18 : 14,
            textcolor: newGrey,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context, ref);
              },
              icon: Icon(Icons.logout, color: black),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : (_profileImageUrl != null &&
                                    _profileImageUrl!.isNotEmpty
                                ? NetworkImage(_profileImageUrl!)
                                : null) as ImageProvider?,
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
                            icon: Icon(Icons.add, size: 25, color: white),
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
                  SizedBox(height: 10.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Is on Holiday?',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Switch(
                        value: _isOnHoliday,
                        activeColor: white,
                        activeTrackColor: red,
                        onChanged: (val) {
                          setState(() {
                            _isOnHoliday = val;
                          });
                        },
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _startTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Working Start Time',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.access_time),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey), // also grey on focus
                      ),
                    ),
                    onTap: () => _selectTime(context, _startTimeController),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _endTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Working End Time',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.access_time),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey), // also grey on focus
                      ),
                    ),
                    onTap: () => _selectTime(context, _endTimeController),
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
                        ),
                      ),
                      onPressed: _isLoading ? null : _updateProfile,
                      child: customTextWithAlignment(
                          text: _isLoading ? 'Updating...' : 'Update',
                          fontweight: FontWeight.bold,
                          fontsize: 12,
                          textcolor: white,
                          textalign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
