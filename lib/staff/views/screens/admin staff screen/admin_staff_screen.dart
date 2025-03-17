import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/icons/LogoBackground.png'), // Background image
              fit: BoxFit.fitWidth, // Make the image cover the entire background
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                "Staff",
                style: TextStyle(
                    color: prim, fontSize: 26, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 30,
              ),
              ProfileDetailCard(),
              SizedBox(height: 30,),
              ProfileDetailCard(),
              SizedBox(height: 30,),
              ProfileDetailCard(),
              SizedBox(height: 30,),
              AddAppointmentWidget(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Makes room for the floating button
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
              Image.asset("assets/icons/CalenderBotom.png",),
              SizedBox(width: 20),
              Image.asset("assets/icons/ScissorBottom.png",),
              SizedBox(width: 20),
              
              Image.asset("assets/icons/HaircutBottom.png",),
              SizedBox(width: 20),// Space in the middle for the FAB
              Image.asset("assets/icons/BeardBottom.png",),
              //SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
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
                  BorderRadius.circular(30), // Adjust the radius as needed
            ),
            backgroundColor: prim,
            child: Image.asset('assets/icons/pluss.png')),
        SizedBox(height: 10), // Space between the button and text
        Text(
          "Add a staff",
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

class ProfileDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
      
      Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          border: Border.all(
            color: prim,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Image and Name
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/icons/avatar2.png'), // Replace with actual image
                  radius: 30,
                ),
                //SizedBox(width: 10),
                Positioned(
                  bottom: 7,
                  left: 10,
                  child: Text(
                    'Jake P',
                    style: TextStyle(
                      color: prim,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(width: 10),
            // Expanded Section for the Information Columns
            _buildInfoColumn("Clients", "18 nos"),
            _buildInfoColumn("Shift", "10am-7pm"),
            _buildInfoColumn("1st Client", "10 am"),
            _buildInfoColumn("Last Client", "6 pm"),
            _buildInfoColumn("Break", "2 PM"),

            // Edit and Refresh Icons
          ],
        ),
      ),
      Positioned(
        right: 0,
        top: -25,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: white,
              ),
              onPressed: () {
                // Edit action
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: white,
              ),
              onPressed: () {
                // Refresh action
              },
            ),
          ],
        ),
      ),
    ]);
  }

  // Helper function to create columns with label and value
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: prim,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
