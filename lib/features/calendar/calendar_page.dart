// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ing_mobile/configs/constants.dart';
import 'package:ing_mobile/features/bottom_navigation_bar.dart';
import 'package:ing_mobile/models/transaction.dart';
import 'package:ing_mobile/utilities/animation/slideleft_toright.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DateTime? _selectedDay;
  int? _selectedCheckbox;

  final user = FirebaseAuth.instance.currentUser!;

  void submit(BuildContext context) async {

    loadingDialog(context);

    final userCollection = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: user.uid).get();
    final userDoc = userCollection.docs[0];

    int totalPoints = userDoc.get('TotalPoints');
    totalPoints += 10;

    await userCollection.docs.first.reference.update({'TotalPoints': totalPoints});

    TransactionModel transaction = TransactionModel(
      value: 5,
      userUid: user.uid,
      timestamp: DateTime.now(),
      type: 'work from home',
      voucherId: null,
    );

    await FirebaseFirestore.instance.collection('Transactions').add(transaction.toMap());

    Navigator.push(context, SlideLeftToRight(page: const BottomNavBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        title:const Text(
          'Work Type',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2024, 4, 30),
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _selectedCheckbox = null; // Reset checkbox selection on day change
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
            ),
            if (_selectedDay != null) ...[
              _buildCheckbox(1, 'Work from home', Icons.home),
              _buildCheckbox(2, 'Work in office', Icons.apartment),
              if (_selectedCheckbox == 1)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You will gain 10 points!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 96, 174, 98),
                      fontSize: 18,
                    ),
                  ),
                ),
              if (_selectedCheckbox == 2)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You won\'t gain any points.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 198, 67, 67),
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 30),
            if (_selectedCheckbox != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity, // Makes the button take the full width
                  height: 50, // Set the height of the button
                  child: ElevatedButton(
                    onPressed: () {
                      submit(context);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 50, 69, 146), // Background color
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(int checkboxValue, String title, IconData iconData) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 0.3),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 181, 181, 181).withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
      color: Colors.white,
    ),
    child: CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      secondary: Icon(iconData, color: const Color.fromARGB(255, 50, 69, 146)),
      value: _selectedCheckbox == checkboxValue,
      onChanged: (bool? newValue) {
        setState(() {
          if (newValue == true) {
            _selectedCheckbox = checkboxValue;
          } else {
            _selectedCheckbox = null;
          }
        });
      },
      activeColor: const Color.fromARGB(255, 50, 69, 146),
      checkColor: Colors.white,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      controlAffinity: ListTileControlAffinity.trailing, // Aligns the checkbox to the right
    ),
  );
}
}
