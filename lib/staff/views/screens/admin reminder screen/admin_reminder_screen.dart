import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

class AdminReminderScreen extends StatefulWidget {
  const AdminReminderScreen({super.key});

  @override
  State<AdminReminderScreen> createState() => _AdminReminderScreenState();
}

class _AdminReminderScreenState extends State<AdminReminderScreen> {
   bool isAutomatedReminderOn = true;
  bool isRemindAdminOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black, // Background color to match the image
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
            color: Color.fromARGB(255, 56, 55, 55),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // General padding for the screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: prim),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Client SMS Reminder Title
                Text(
                  "Client SMS Reminder",
                  style: TextStyle(
                    color: prim,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Reminder Message Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D2C2A), // Dark background color
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: prim),
                  ),
                  child: Text(
                    'Hello *{Customercode}, This is a gentle reminder that your appointment for "{Servicecode}" is scheduled for "DD-MM-YY" at "HH:MM".',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                // Send For Dropdown
                Text(
                  "Send for",
                  style: TextStyle(color: prim, fontSize: 18),
                ),
                SizedBox(height: 10),
                // Dropdown Menu for Appointments
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: prim),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    value: "All appointments", // Default value
                    items: [
                      DropdownMenuItem(
                        child: Text("All appointments", style: TextStyle(color: Colors.white)),
                        value: "All appointments",
                      ),
                      DropdownMenuItem(
                        child: Text("Specific appointments", style: TextStyle(color: Colors.white)),
                        value: "Specific appointments",
                      ),
                    ],
                    onChanged: (value) {},
                    dropdownColor: Colors.black,
                    iconEnabledColor: prim,
                  ),
                ),
                SizedBox(height: 20),
                // Send Reminder Dropdown
                Text(
                  "Send reminder",
                  style: TextStyle(color: prim, fontSize: 18),
                ),
                SizedBox(height: 10),
                // Dropdown Menu for Reminder
                Row(
                  children: [
                    // Hour Picker
                    Container(
                      width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: prim),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: "01", // Default value
                        items: [
                          DropdownMenuItem(
                            child: Text("01", style: TextStyle(color: Colors.white)),
                            value: "01",
                          ),
                          DropdownMenuItem(
                            child: Text("02", style: TextStyle(color: Colors.white)),
                            value: "02",
                          ),
                        ],
                        onChanged: (value) {},
                        dropdownColor: Colors.transparent,
                        iconEnabledColor: prim,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Time Unit Picker
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: prim),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(),
                          value: "Hour/s before", // Default value
                          items: [
                            DropdownMenuItem(
                              child: Text("Hour/s before", style: TextStyle(color: Colors.white)),
                              value: "Hour/s before",
                            ),
                            DropdownMenuItem(
                              child: Text("Minutes before", style: TextStyle(color: Colors.white)),
                              value: "Minutes before",
                            ),
                          ],
                          onChanged: (value) {},
                          dropdownColor: Colors.transparent,
                          iconEnabledColor: prim,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Automated reminder toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Automated reminder",
                      style: TextStyle(color: prim, fontSize: 16),
                    ),
                    Switch(
                      //value: true,
                      value: isAutomatedReminderOn,
                      onChanged: (value) {
                        setState(() {
                          isAutomatedReminderOn = value;
                        });
                      },
                      activeColor: prim,
                    ),
                  ],
                ),
                // Remind Admin toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remind Admin",
                      style: TextStyle(color: prim, fontSize: 16),
                    ),
                    Switch(
                      value: isRemindAdminOn,
                      onChanged: (value) {
                        setState(() {
                          isRemindAdminOn = value;
                        });
                      },
                      activeColor: prim,
                    ),
                  ],
                ),
              ],
            ),
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