import 'package:flutter/material.dart';

import 'package:yoga_center_app/models/course.dart';

import 'package:yoga_center_app/services/firebase_service.dart';

class BookingHistoryScreen extends StatelessWidget {
  final String email;

  const BookingHistoryScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: FutureBuilder(
        future: FirebaseService().getUserCourses(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Course> courses = snapshot.data as List<Course>;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                Course course = courses[index];
                return ListTile(
                  title: Text(course.classType),
                  subtitle: Text('${course.dayOfWeek} at ${course.time}'),
                );
              },
            );
          } else {
            return const Center(child: Text('No bookings found.'));
          }
        },
      ),
    );
  }
}