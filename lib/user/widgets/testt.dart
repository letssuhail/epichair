// import 'package:epic/providers/signup_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SignupScreen extends ConsumerWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final signupState = ref.watch(signupProvider);

//     return Scaffold(
//       appBar: AppBar(title: Text('Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final email = emailController.text;
//                 final password = passwordController.text;
//                 ref.read(signupProvider.notifier).signup(email, password);
//               },
//               child: Text('Signup'),
//             ),
//             SizedBox(height: 20),
//             if (signupState)
//               Text(
//                 'Signup successful!',
//                 style: TextStyle(color: Colors.green),
//               ),
//             if (!signupState && emailController.text.isNotEmpty)
//               Text(
//                 'Signup failed. Please try again.',
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
