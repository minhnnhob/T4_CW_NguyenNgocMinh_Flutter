import 'package:flutter/material.dart';
import 'package:yoga_center_app/models/course.dart';
import 'package:yoga_center_app/services/firebase_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  List<Course> _cart = [];
  final FirebaseService _firebaseService = FirebaseService();

  List<Course> get courses => _courses;
  List<Course> get cart => _cart;

  Future<void> fetchCourses() async {
    _courses = await _firebaseService.getCourses();
    notifyListeners();
  }

  void addToCart(Course course) {
    _cart.add(course);
    notifyListeners();
  }

  Future<void> removeFromCart(String email, Course course) async {
    _cart.remove(course);
    await _firebaseService.removeCourseFromCart(email, course);
    notifyListeners();
  }

  Future<void> checkout(String email) async {
    await _firebaseService.addCourseToCart(email, _cart);
    _cart.clear();
    notifyListeners();
  }

  Future<void> fetchUserCourses(String email) async {
    _cart = await _firebaseService.getUserCourses(email);
    notifyListeners();
  }

  Future<bool> isCourseInCart(String email, Course course) async {
    List<Course> userCourses = await _firebaseService.getUserCourses(email);
    return userCourses.any((c) => c.id == course.id);
  }
}