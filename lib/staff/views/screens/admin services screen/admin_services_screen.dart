import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Icon(Icons.menu, color: prim),
        ],
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/icons/BigCircleLeft.png'), // Background image
            fit: BoxFit.fitWidth, // Make the image cover the entire background
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(
                  color: prim, fontWeight: FontWeight.bold, fontSize: 26),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HaircutWidget(
                    label: 'Hair-cut', pathh: "assets/icons/haircut2.png"),
                HaircutWidget(
                    label: 'Shaving', pathh: "assets/icons/shaving2.png"),
                HaircutWidget(
                    label: 'Hair Color', pathh: "assets/icons/color2.png"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HaircutWidget(
                    label: 'Threading', pathh: "assets/icons/threading2.png"),
                HaircutWidget(label: 'Perms', pathh: "assets/icons/perms2.png"),
                HaircutWidget(
                    label: 'Facial', pathh: "assets/icons/facial2.png"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HaircutWidget(
                    label: 'Massasge', pathh: "assets/icons/massage2.png"),
                HaircutWidget(
                    label: 'Body waxing', pathh: "assets/icons/waxing2.png"),
                HaircutWidget(
                    label: 'Wig services', pathh: "assets/icons/wig2.png"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HaircutWidget(
                    label: 'Make up', pathh: "assets/icons/makeup2.png"),
                HaircutWidget(label: 'Laser', pathh: "assets/icons/laser2.png"),
                HaircutWidget(
                    label: 'Advance moisture',
                    pathh: "assets/icons/moisture2.png"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HaircutWidget(
                    label: 'Scalp treatment', pathh: "assets/icons/scalp2.png"),
                HaircutWidget(
                    label: 'Hair protection',
                    pathh: "assets/icons/protection2.png"),
                AddAppointmentWidget()
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape:
            const CircularNotchedRectangle(), // Makes room for the floating button
        color: Colors.transparent,
        child: Container(
          height: 60.0, // Adjust height
          decoration: BoxDecoration(
            color: prim,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/icons/CalenderBotom.png",
              ),
              SizedBox(width: 20),
              Image.asset(
                "assets/icons/ScissorBottom.png",
              ),
              SizedBox(width: 20),

              Image.asset(
                "assets/icons/HaircutBottom.png",
              ),
              SizedBox(width: 20), // Space in the middle for the FAB
              Image.asset(
                "assets/icons/BeardBottom.png",
              ),
              //SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class HaircutWidget extends StatelessWidget {
  final String label;
  final String pathh;
  const HaircutWidget({super.key, required this.label, required this.pathh});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 100,

        padding: EdgeInsets.all(10), // Padding inside the container
        decoration: BoxDecoration(
          color: Colors.transparent, // Background color
          borderRadius: BorderRadius.circular(8), // Circular corners
          border: Border.all(
            color: prim, // Border color
            width: 1.5, // Border width
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(pathh),
            SizedBox(height: 5), // Spacing between icon and text
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        left: 55,
        top: -3,
        child: Row(
          children: [
            Icon(Icons.edit,color: Colors.white,),
            Icon(Icons.delete,color: Colors.pink,)
          ],
        ),
      )
    ]);
  }
}

class AddAppointmentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
            onPressed: () {
              // Your onPressed action
            },
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Adjust the radius as needed
            ),
            backgroundColor: prim,
            child: Image.asset('assets/icons/pluss.png')),
        SizedBox(height: 10), // Space between the button and text
        Text(
          "Add a service",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
