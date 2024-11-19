import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_center_app/providers/course_provider.dart';
import 'package:yoga_center_app/models/course.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _fetchUserCourses() async {
    if (_emailController.text.isNotEmpty) {
      await Provider.of<CourseProvider>(context, listen: false).fetchUserCourses(_emailController.text);
      if (Provider.of<CourseProvider>(context, listen: false).cart.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect email or no courses found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart',style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yoga Center Cart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUserCourses,
              child: const Text('Fetch Courses'),

            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  if (courseProvider.cart.isEmpty) {
                    return const Center(child: Text('No courses available.'));
                  }
                  return ListView.builder(
                    itemCount: courseProvider.cart.length,
                    itemBuilder: (context, index) {
                      var course = courseProvider.cart[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(course.classType),
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
                            icon: const Icon(Icons.remove_shopping_cart),
                            onPressed: () {
                              courseProvider.removeFromCart(_emailController.text, course);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${course.classType} removed from cart')),
                              );
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