import 'package:firebase_database/firebase_database.dart';
import 'package:yoga_center_app/models/course.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();


  Future<List<Course>> getCourses() async {

    DatabaseEvent event = await _database.child('courses').once();
    DataSnapshot snapshot = event.snapshot;

    List<Course> courses = [];
    if (snapshot.value != null) {

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {

        courses.add(Course.fromJson(Map<String, dynamic>.from(value)));
      });
    } else {
      print('No data found.');
    }
    return courses;
  }


  Future<void> addCourseToCart(String email, List<Course> cart) async {
    await _database.child('carts').set({
      'email': email,
      'courses': cart.map((course) => course.toJson()).toList(),
    });
  }


  Future<List<Course>> getUserCourses(String email) async {
    DatabaseEvent event = await _database.child('carts').child('courses').once();
    DataSnapshot snapshot = event.snapshot;
    print('Snapshot value: ${snapshot.value}');
    List<Course> courses = [];
    if (snapshot.value != null) {
      List<dynamic> data = snapshot.value as List<dynamic>;
      for (var value in data) {
        courses.add(Course.fromJson(Map<String, dynamic>.from(value)));
      }
    } else {
      print('No data found.');
    }
    return courses;
  }


  Future<void> removeCourseFromCart(String email, Course course) async {
    DatabaseReference cartRef = _database.child('carts').child(email.replaceAll('.', ',')).child('courses');
    DatabaseEvent event = await cartRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      List<dynamic> data = List<dynamic>.from(snapshot.value as List<dynamic>);
      data.removeWhere((value) => Course.fromJson(Map<String, dynamic>.from(value)).id == course.id);

      await cartRef.set(data);
    }
  }

}