// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:epic/components/custom_text.dart';
// import 'package:epic/components/custom_text_field.dart';
// import 'package:epic/consts/colors.dart';
// import 'package:epic/user/providers/logout_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path/path.dart'; // For getting file names
// import 'package:path_provider/path_provider.dart'; // Persistent storage
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../user/models/user_profile_model.dart';

// final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
//   return LogoutNotifier(ref);
// });

// class StaffProfileScreen extends ConsumerStatefulWidget {
//   const StaffProfileScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _StaffProfileScreenState();
// }

// class _StaffProfileScreenState extends ConsumerState<StaffProfileScreen> {
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController _startTimeController = TextEditingController();
//   final TextEditingController _endTimeController = TextEditingController();
//   XFile? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//   bool _isOnHoliday = false;
//   String? _username;
//   String? _profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData();
//     _loadProfileData();
//   }

//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? name = prefs.getString('userName');
//     String? imagePath = prefs.getString('staffImagePath');
//     if (name != null) nameController.text = name;
//     if (imagePath != null) {
//       setState(() {
//         _profileImage = XFile(imagePath);
//       });
//     }
//   }

//   Future<void> _fetchProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('userToken');
//     if (token != null) {
//       const url = 'https://epichair.vercel.app/api/staff/profile';
//       try {
//         final response = await http.get(
//           Uri.parse(url),
//           headers: {'Authorization': 'Bearer $token'},
//         );
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           final userProfile = StaffProfile.fromJson(data['user']);
//           prefs.setString(
//               'username', userProfile.username ?? 'Enter your name');
//           prefs.setString('profileImageUrl', userProfile.imageUrl ?? '');
//           prefs.setBool('isOnHoliday', userProfile.isOnHoliday ?? false);
//           if (userProfile.workingHours != null) {
//             prefs.setString(
//                 'workingHours', jsonEncode(userProfile.workingHours));
//           }
//           setState(() {
//             _username = prefs.getString('username');
//             _profileImageUrl = prefs.getString('profileImageUrl');
//             _isOnHoliday = prefs.getBool('isOnHoliday') ?? false;
//             final workingHoursStr = prefs.getString('workingHours');
//             if (workingHoursStr != null) {
//               final workingHours =
//                   jsonDecode(workingHoursStr) as Map<String, dynamic>;
//               _startTimeController.text = workingHours['start'] ?? '09:00';
//               _endTimeController.text = workingHours['end'] ?? '18:00';
//             }
//           });
//         }
//       } catch (_) {}
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage == null) return;
//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = basename(pickedImage.path);
//     final savedImage =
//         await File(pickedImage.path).copy('${appDir.path}/$fileName');

//     setState(() {
//       _profileImage = XFile(savedImage.path);
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('staffImagePath', savedImage.path);
//   }

//   Future<void> _selectTime(
//       BuildContext context, TextEditingController controller) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: const TimeOfDay(hour: 10, minute: 0),
//     );
//     if (picked != null) {
//       controller.text = picked.format(context);
//     }
//   }

//   Future<void> _updateProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('userToken');

//     setState(() {
//       _isLoading = true;
//     });

//     String name = nameController.text;
//     String url = 'https://epichair.vercel.app/api/staff/profile';

//     try {
//       var request = http.MultipartRequest('PATCH', Uri.parse(url));

//       request.headers['Authorization'] = 'Bearer $token';
//       request.headers['Content-Type'] = 'multipart/form-data';

//       request.fields['name'] = name;
//       request.fields['isOnHoliday'] = _isOnHoliday.toString();

//       Map<String, String> workingHours = {
//         'start': _startTimeController.text,
//         'end': _endTimeController.text,
//       };
//       request.fields['workingHours'] = jsonEncode(workingHours);

//       if (_profileImage != null) {
//         var file = await http.MultipartFile.fromPath(
//           'image',
//           _profileImage!.path,
//           filename: basename(_profileImage!.path),
//         );
//         request.files.add(file);
//       }

//       var response = await request.send();

//       log('response ${response}');

//       if (response.statusCode == 200) {
//         prefs.setString('staffName', name);
//         if (_profileImage != null) {
//           prefs.setString('staffImagePath', _profileImage!.path);
//         }
//         _scaffoldMessengerKey.currentState?.showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully')),
//         );
//       } else {
//         var responseBody = await response.stream.bytesToString();
//         _scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(content: Text('Failed to update profile: $responseBody')),
//         );
//       }
//     } catch (e) {
//       _scaffoldMessengerKey.currentState?.showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _showLogoutConfirmationDialog(
//       BuildContext context, WidgetRef ref) async {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         double screenWidth = MediaQuery.of(context).size.width;
//         return AlertDialog(
//           backgroundColor: background,
//           title: Text(
//             'Logout',
//             style: TextStyle(
//               color: black,
//               fontSize: screenWidth > 360 ? 18 : 14,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to log out?',
//             style:
//                 TextStyle(color: black, fontSize: screenWidth > 360 ? 16 : 12),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel',
//                   style: TextStyle(
//                       color: black, fontSize: screenWidth > 360 ? 16 : 12)),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: Text('Yes',
//                   style: TextStyle(
//                       color: black, fontSize: screenWidth > 360 ? 16 : 12)),
//               onPressed: () async {
//                 ref.read(logoutProvider.notifier).logout(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return ScaffoldMessenger(
//       key: _scaffoldMessengerKey,
//       child: Scaffold(
//         backgroundColor: background,
//         appBar: AppBar(
//           backgroundColor: background,
//           title: customTextOne(
//             text: 'Profile',
//             fontweight: FontWeight.bold,
//             fontsize: screenWidth > 360 ? 18 : 14,
//             textcolor: newGrey,
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 _showLogoutConfirmationDialog(context, ref);
//               },
//               icon: Icon(Icons.logout, color: black),
//             ),
//           ],
//         ),
//         body: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey.shade300,
//                         backgroundImage: _profileImage != null
//                             ? FileImage(File(_profileImage!.path))
//                             : (_profileImageUrl != null &&
//                                     _profileImageUrl!.isNotEmpty
//                                 ? NetworkImage(_profileImageUrl!)
//                                 : null) as ImageProvider?,
//                         child: (_profileImage == null &&
//                                 (_profileImageUrl == null ||
//                                     _profileImageUrl!.isEmpty))
//                             ? Icon(Icons.person, color: Colors.white, size: 60)
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration:
//                               BoxDecoration(shape: BoxShape.circle, color: red),
//                           child: IconButton(
//                             onPressed: _pickImage,
//                             icon: Icon(Icons.add, size: 25, color: white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   customTextField(
//                     backgroundColor: grey.withOpacity(.3),
//                     labeltext: 'Name',
//                     keyboardtype: TextInputType.text,
//                     obscureText: false,
//                     controller: nameController,
//                     hinttext: _username ?? 'New Name',
//                     context: context,
//                     textcolor: black,
//                     hintcolor: black,
//                     borderColor: grey,
//                     fontsize: 12,
//                     textfieldfontsize: 12,
//                     fontWeight: FontWeight.bold,
//                     textalign: TextAlign.center,
//                   ),
//                   SizedBox(height: 10.sp),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Is on Holiday?',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Switch(
//                         value: _isOnHoliday,
//                         activeColor: white,
//                         activeTrackColor: red,
//                         onChanged: (val) {
//                           setState(() {
//                             _isOnHoliday = val;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   TextFormField(
//                     controller: _startTimeController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Working Start Time',
//                       labelStyle: TextStyle(color: Colors.grey),
//                       suffixIcon: Icon(Icons.access_time),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Colors.grey), // also grey on focus
//                       ),
//                     ),
//                     onTap: () => _selectTime(context, _startTimeController),
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     controller: _endTimeController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Working End Time',
//                       labelStyle: TextStyle(color: Colors.grey),
//                       suffixIcon: Icon(Icons.access_time),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                             color: Colors.grey), // also grey on focus
//                       ),
//                     ),
//                     onTap: () => _selectTime(context, _endTimeController),
//                   ),
//                   SizedBox(height: 20.sp),
//                   SizedBox(
//                     height: 40,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(13),
//                         ),
//                       ),
//                       onPressed: _isLoading ? null : _updateProfile,
//                       child: customTextWithAlignment(
//                           text: _isLoading ? 'Updating...' : 'Update',
//                           fontweight: FontWeight.bold,
//                           fontsize: 12,
//                           textcolor: white,
//                           textalign: TextAlign.center),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Full Working Code with Dynamic Holiday Dates and Custom Available Support

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:epic/components/custom_text_field.dart';
// import 'package:epic/consts/colors.dart';
// import 'package:epic/user/providers/logout_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../user/models/user_profile_model.dart';

// final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
//   return LogoutNotifier(ref);
// });

// class StaffProfileScreen extends ConsumerStatefulWidget {
//   const StaffProfileScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _StaffProfileScreenState();
// }

// class _StaffProfileScreenState extends ConsumerState<StaffProfileScreen> {
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController _startTimeController = TextEditingController();
//   final TextEditingController _endTimeController = TextEditingController();
//   XFile? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//   bool _isOnHoliday = false;
//   String? _username;
//   String? _profileImageUrl;

//   List<Map<String, String>> holidayDates = [];
//   List<Map<String, String>> customAvailable = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData();
//     _loadProfileData();
//   }

//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? name = prefs.getString('userName');
//     String? imagePath = prefs.getString('staffImagePath');
//     if (name != null) nameController.text = name;
//     if (imagePath != null) {
//       setState(() {
//         _profileImage = XFile(imagePath);
//       });
//     }
//   }

//   Future<void> _fetchProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('userToken');
//     if (token != null) {
//       const url = 'https://epichair.vercel.app/api/staff/profile';
//       try {
//         final response = await http.get(
//           Uri.parse(url),
//           headers: {'Authorization': 'Bearer $token'},
//         );
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           final userProfile = StaffProfile.fromJson(data['user']);
//           prefs.setString(
//               'username', userProfile.username ?? 'Enter your name');
//           prefs.setString('profileImageUrl', userProfile.imageUrl ?? '');
//           prefs.setBool('isOnHoliday', userProfile.isOnHoliday ?? false);
//           if (userProfile.workingHours != null) {
//             prefs.setString(
//                 'workingHours', jsonEncode(userProfile.workingHours));
//           }
//           setState(() {
//             _username = prefs.getString('username');
//             _profileImageUrl = prefs.getString('profileImageUrl');
//             _isOnHoliday = prefs.getBool('isOnHoliday') ?? false;
//             final workingHoursStr = prefs.getString('workingHours');
//             if (workingHoursStr != null) {
//               final workingHours =
//                   jsonDecode(workingHoursStr) as Map<String, dynamic>;
//               _startTimeController.text = workingHours['start'] ?? '09:00';
//               _endTimeController.text = workingHours['end'] ?? '18:00';
//             }

//             if (userProfile.customAvailableHours != null) {
//               customAvailable = userProfile.customAvailableHours!
//                   .map((e) => {
//                         'date': e.date ?? '',
//                         'start': e.start ?? '',
//                         'end': e.end ?? '',
//                       })
//                   .toList();
//             }

//             if (userProfile.holidayDates != null) {
//               holidayDates = userProfile.holidayDates!
//                   .map((e) => {
//                         'from': e.from ?? '',
//                         'to': e.to ?? '',
//                       })
//                   .toList();
//             }
//           });
//         }
//       } catch (_) {}
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage == null) return;
//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = basename(pickedImage.path);
//     final savedImage =
//         await File(pickedImage.path).copy('${appDir.path}/$fileName');
//     setState(() {
//       _profileImage = XFile(savedImage.path);
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('staffImagePath', savedImage.path);
//   }

//   Future<String?> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       return picked.toIso8601String().split('T')[0];
//     }
//     return null;
//   }

//   Future<String?> _select24HourTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       return '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
//     }
//     return null;
//   }

//   Future<void> _updateProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('userToken');
//     setState(() => _isLoading = true);

//     try {
//       var request = http.MultipartRequest(
//           'PATCH', Uri.parse('https://epichair.vercel.app/api/staff/profile'));
//       request.headers['Authorization'] = 'Bearer $token';
//       request.fields['name'] = nameController.text;
//       request.fields['isOnHoliday'] = _isOnHoliday.toString();
//       request.fields['workingHours'] = jsonEncode({
//         'start': _startTimeController.text,
//         'end': _endTimeController.text,
//       });
//       request.fields['holidayDates'] = jsonEncode(holidayDates);
//       request.fields['customAvailable'] = jsonEncode(customAvailable);

//       if (_profileImage != null) {
//         var file =
//             await http.MultipartFile.fromPath('image', _profileImage!.path);
//         request.files.add(file);
//       }

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         _scaffoldMessengerKey.currentState?.showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully')),
//         );
//       } else {
//         var body = await response.stream.bytesToString();
//         _scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(content: Text('Failed: $body')),
//         );
//       }
//     } catch (e) {
//       _scaffoldMessengerKey.currentState
//           ?.showSnackBar(SnackBar(content: Text('Error: $e')));
//     }

//     setState(() => _isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: _scaffoldMessengerKey,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Profile')),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(File(_profileImage!.path))
//                       : (_profileImageUrl != null &&
//                               _profileImageUrl!.isNotEmpty)
//                           ? NetworkImage(_profileImageUrl!) as ImageProvider
//                           : null,
//                   child: (_profileImage == null &&
//                           (_profileImageUrl == null ||
//                               _profileImageUrl!.isEmpty))
//                       ? const Icon(Icons.person, size: 60)
//                       : null,
//                 ),
//                 TextButton(
//                     onPressed: _pickImage, child: const Text("Change Photo")),
//                 customTextField(
//                   backgroundColor: grey.withOpacity(.3),
//                   labeltext: 'Name',
//                   keyboardtype: TextInputType.text,
//                   obscureText: false,
//                   controller: nameController,
//                   hinttext: _username ?? 'New Name',
//                   context: context,
//                   textcolor: black,
//                   hintcolor: black,
//                   borderColor: grey,
//                   fontsize: 12,
//                   textfieldfontsize: 12,
//                   fontWeight: FontWeight.bold,
//                   textalign: TextAlign.center,
//                 ),
//                 SwitchListTile(
//                   title: const Text("Is on Holiday"),
//                   value: _isOnHoliday,
//                   onChanged: (val) => setState(() => _isOnHoliday = val),
//                 ),
//                 TextFormField(
//                   controller: _startTimeController,
//                   readOnly: true,
//                   onTap: () async {
//                     String? time = await _select24HourTime(context);
//                     if (time != null) _startTimeController.text = time;
//                   },
//                   decoration: const InputDecoration(labelText: 'Start Time'),
//                 ),
//                 TextFormField(
//                   controller: _endTimeController,
//                   readOnly: true,
//                   onTap: () async {
//                     String? time = await _select24HourTime(context);
//                     if (time != null) _endTimeController.text = time;
//                   },
//                   decoration: const InputDecoration(labelText: 'End Time'),
//                 ),
//                 const Divider(),
//                 const Text('Holiday Dates',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...holidayDates.map((e) => ListTile(
//                       title: Text('From: ${e['from']} To: ${e['to']}'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => setState(() => holidayDates.remove(e)),
//                       ),
//                     )),
//                 ElevatedButton(
//                   onPressed: () async {
//                     String? from = await _selectDate(context);
//                     String? to = await _selectDate(context);
//                     if (from != null && to != null) {
//                       setState(
//                           () => holidayDates.add({'from': from, 'to': to}));
//                     }
//                   },
//                   child: const Text("Add Holiday"),
//                 ),
//                 const Divider(),
//                 const Text('Custom Available',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...customAvailable.map((e) => ListTile(
//                       title:
//                           Text('${e['date']} - ${e['start']} to ${e['end']}'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () =>
//                             setState(() => customAvailable.remove(e)),
//                       ),
//                     )),
//                 ElevatedButton(
//                   onPressed: () async {
//                     String? date = await _selectDate(context);
//                     String? start = await _select24HourTime(context);
//                     String? end = await _select24HourTime(context);
//                     if (date != null && start != null && end != null) {
//                       setState(() => customAvailable.add({
//                             'date': date,
//                             'start': start,
//                             'end': end,
//                           }));
//                     }
//                   },
//                   child: const Text("Add Availability"),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _updateProfile,
//                   child: Text(_isLoading ? 'Updating...' : 'Update'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epic/components/custom_text_field.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/logout_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

  List<Map<String, String>> holidayDates = [];
  List<Map<String, String>> customAvailable = [];

  // Single holiday period (from-to)
  Map<String, String>? singleHoliday;

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

          // Store data in SharedPreferences
          prefs.setString(
              'username', userProfile.username ?? 'Enter your name');
          prefs.setString('profileImageUrl', userProfile.imageUrl ?? '');
          prefs.setBool('isOnHoliday', userProfile.isOnHoliday ?? false);

          if (userProfile.workingHours != null) {
            prefs.setString(
                'workingHours', jsonEncode(userProfile.workingHours));
          }

          // Store holiday dates and custom availability
          if (userProfile.holidayDates != null) {
            prefs.setString(
                'holidayDates', jsonEncode(userProfile.holidayDates));
          }

          if (userProfile.customAvailableHours != null) {
            prefs.setString('customAvailable',
                jsonEncode(userProfile.customAvailableHours));
          }

          setState(() {
            _username = prefs.getString('username');
            _profileImageUrl = prefs.getString('profileImageUrl');
            _isOnHoliday = prefs.getBool('isOnHoliday') ?? false;
            nameController.text = _username ?? '';

            // Load working hours
            final workingHoursStr = prefs.getString('workingHours');
            if (workingHoursStr != null) {
              final workingHours =
                  jsonDecode(workingHoursStr) as Map<String, dynamic>;
              _startTimeController.text = workingHours['start'] ?? '09:00';
              _endTimeController.text = workingHours['end'] ?? '18:00';
            }

            // Load and pre-fill custom availability (multiple entries allowed)
            if (userProfile.customAvailableHours != null) {
              customAvailable = userProfile.customAvailableHours!
                  .map((e) => {
                        'date': e.date ?? '',
                        'start': e.start ?? '',
                        'end': e.end ?? '',
                      })
                  .toList();
            }

            // Load and pre-fill holiday dates (single holiday period)
            if (userProfile.holidayDates != null &&
                userProfile.holidayDates!.isNotEmpty) {
              singleHoliday = {
                'from': userProfile.holidayDates!.first.from ?? '',
                'to': userProfile.holidayDates!.first.to ?? '',
              };
            }
          });
        }
      } catch (e) {
        log('Error fetching profile data: $e');
      }
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

  Future<String?> _selectDate(BuildContext context,
      {String? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          initialDate != null ? DateTime.parse(initialDate) : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // header background & active date
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return picked.toIso8601String().split('T')[0];
    }
    return null;
  }

  Future<String?> _select24HourTime(BuildContext context,
      {String? initialTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime != null
          ? TimeOfDay(
              hour: int.parse(initialTime.split(':')[0]),
              minute: int.parse(initialTime.split(':')[1]),
            )
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: Colors.red,
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dayPeriodColor: Colors.grey,
              backgroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // selected time color
              onSurface: Colors.black, // default text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
    return null;
  }

  void _editHoliday(BuildContext context) async {
    String? from =
        await _selectDate(context, initialDate: singleHoliday?['from']);
    String? to = await _selectDate(context, initialDate: singleHoliday?['to']);

    if (from != null && to != null) {
      setState(() {
        singleHoliday = {
          'from': from,
          'to': to,
        };
      });
    }
  }

  void _editCustomAvailable(int index, BuildContext context) async {
    final availability = customAvailable[index];
    String? date =
        await _selectDate(context, initialDate: availability['date']);
    String? start =
        await _select24HourTime(context, initialTime: availability['start']);
    String? end =
        await _select24HourTime(context, initialTime: availability['end']);

    if (date != null && start != null && end != null) {
      setState(() {
        customAvailable[index] = {
          'date': date,
          'start': start,
          'end': end,
        };
      });
    }
  }

  // Add or update custom availability by date
  void _addOrUpdateCustomAvailable(String date, String start, String end) {
    // Check if this date already exists
    int existingIndex =
        customAvailable.indexWhere((item) => item['date'] == date);

    if (existingIndex != -1) {
      // Update existing entry
      setState(() {
        customAvailable[existingIndex] = {
          'date': date,
          'start': start,
          'end': end,
        };
      });
    } else {
      // Add new entry
      setState(() {
        customAvailable.add({
          'date': date,
          'start': start,
          'end': end,
        });
      });
    }
  }

  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    if (token == null) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Error: No authentication token found')),
      );
      return;
    }

    // Validate holiday date range
    if (singleHoliday != null) {
      final fromDate = DateTime.tryParse(singleHoliday!['from'] ?? '');
      final toDate = DateTime.tryParse(singleHoliday!['to'] ?? '');
      if (fromDate == null || toDate == null || fromDate.isAfter(toDate)) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Error: Invalid holiday date range')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
          'PATCH', Uri.parse('https://epichair.vercel.app/api/staff/profile'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = nameController.text;
      request.fields['isOnHoliday'] = _isOnHoliday.toString();
      request.fields['workingHours'] = jsonEncode({
        'start': _startTimeController.text,
        'end': _endTimeController.text,
      });

      // Send single holiday period as an array
      if (singleHoliday != null) {
        request.fields['holidayDates'] = jsonEncode([singleHoliday]);
      } else {
        request.fields['holidayDates'] = jsonEncode([]);
      }

      // Send all custom availability (already in correct format)
      request.fields['customAvailable'] = jsonEncode(customAvailable);

      if (_profileImage != null) {
        var file =
            await http.MultipartFile.fromPath('image', _profileImage!.path);
        request.files.add(file);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        // Update local storage with new data
        await _fetchProfileData();

        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        var body = await response.stream.bytesToString();
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Failed: $body')),
        );
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : (_profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty)
                          ? NetworkImage(_profileImageUrl!) as ImageProvider
                          : null,
                  child: (_profileImage == null &&
                          (_profileImageUrl == null ||
                              _profileImageUrl!.isEmpty))
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      "Change Photo",
                      style: TextStyle(color: black),
                    )),
                customTextField(
                  backgroundColor: grey.withOpacity(.3),
                  labeltext: 'Name',
                  keyboardtype: TextInputType.text,
                  obscureText: false,
                  controller: nameController,
                  hinttext: _username ?? 'Enter your name',
                  context: context,
                  textcolor: black,
                  hintcolor: black,
                  borderColor: grey,
                  fontsize: 12,
                  textfieldfontsize: 12,
                  fontWeight: FontWeight.bold,
                  textalign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: white,
                  activeTrackColor: red,
                  title: const Text("Is on Holiday"),
                  value: _isOnHoliday,
                  onChanged: (val) => setState(() => _isOnHoliday = val),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startTimeController,
                  readOnly: true,
                  onTap: () async {
                    String? time = await _select24HourTime(context);
                    if (time != null) _startTimeController.text = time;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Start Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endTimeController,
                  readOnly: true,
                  onTap: () async {
                    String? time = await _select24HourTime(context);
                    if (time != null) _endTimeController.text = time;
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: black),
                    labelText: 'End Time',
                    suffixIcon: Icon(Icons.access_time),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text('Holiday Period',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                if (singleHoliday == null)
                  const Text('No holiday period set',
                      style: TextStyle(color: Colors.grey))
                else
                  Card(
                    child: ListTile(
                      title: Text(
                          'From: ${singleHoliday!['from']} To: ${singleHoliday!['to']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit_document, color: black),
                        onPressed: () => _editHoliday(context),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    String? from = await _selectDate(context);
                    if (from == null) return;
                    String? to = await _selectDate(context);
                    if (to != null) {
                      setState(() {
                        singleHoliday = {
                          'from': from,
                          'to': to,
                        };
                      });
                    }
                  },
                  icon: Icon(
                    singleHoliday == null ? Icons.add : Icons.edit_document,
                    color: black,
                  ),
                  label: Text(
                    singleHoliday == null
                        ? "Set Holiday Period"
                        : "Update Holiday Period",
                    style: TextStyle(color: black),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text('Custom Available Hours',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                if (customAvailable.isEmpty)
                  const Text('No custom availability added',
                      style: TextStyle(color: Colors.grey))
                else
                  ...customAvailable.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> availability = entry.value;
                    return Card(
                      child: ListTile(
                        title: Text('${availability['date']}'),
                        subtitle: Text(
                            '${availability['start']} - ${availability['end']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit_document, color: black),
                          onPressed: () => _editCustomAvailable(index, context),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    String? date = await _selectDate(context);
                    if (date == null) return;
                    String? start = await _select24HourTime(context);
                    if (start == null) return;
                    String? end = await _select24HourTime(context);
                    if (end != null) {
                      _addOrUpdateCustomAvailable(date, start, end);
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    color: red,
                  ),
                  label: Text(
                    "Add/Update Availability",
                    style: TextStyle(color: black),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _isLoading ? 'Updating...' : 'Update Profile',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
