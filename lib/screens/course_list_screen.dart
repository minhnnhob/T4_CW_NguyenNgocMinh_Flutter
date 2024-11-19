import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_center_app/providers/course_provider.dart';
import 'package:yoga_center_app/screens/cart_screen.dart';
import 'package:yoga_center_app/screens/booking_history_screen.dart';
import 'package:yoga_center_app/models/course.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<Course> _filteredCourses = [];
  String _emailError = '';

  @override
  void initState() {
    super.initState();
    _initializeCourses();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _initializeCourses() async {
    await Provider.of<CourseProvider>(context, listen: false).fetchCourses();
    _filterCourses();
  }

  void _filterCourses() {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    setState(() {
      _filteredCourses = provider.courses.where((course) {
        final query = _searchController.text.toLowerCase();
        return course.dayOfWeek.toLowerCase().contains(query) ||
            course.time.toLowerCase().contains(query);
      }).toList();
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _showEmailDialog(Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter your email'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_emailError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _emailError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isNotEmpty) {
                      if (_isValidEmail(_emailController.text)) {
                        bool isInCart = await Provider.of<CourseProvider>(context, listen: false).isCourseInCart(_emailController.text, course);
                        if (!isInCart) {
                          Provider.of<CourseProvider>(context, listen: false).addToCart(course);
                          Provider.of<CourseProvider>(context, listen: false).checkout(_emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.classType} added to cart')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.classType} is already in the cart')),
                          );
                        }
                      } else {
                        setState(() {
                          _emailError = 'Please enter a valid email address';
                        });
                      }
                    } else {
                      setState(() {
                        _emailError = 'Please enter your email';
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Set the height you want
        child: AppBar(
          title: const Text('Universal Yoga',style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),),
          centerTitle: true,

          backgroundColor: Colors.purple,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yoga Center Courses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by day or time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  if (_filteredCourses.isEmpty) {
                    return const Center(child: Text('No courses available.'));
                  }
                  return ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      Course course = _filteredCourses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(course.classType, style: TextStyle(
                          fontWeight: FontWeight.bold,)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Day: ${course.dayOfWeek}'),
                              Text('Time: ${course.time}'),
                              Text('Capacity: ${course.capacity}'),
                              Text('Duration: ${course.duration} minutes'),
                              Text('Price: \$${course.price}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              _showEmailDialog(course);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}