class Course {
  int id;
  String dayOfWeek;
  String time;
  int capacity;
  int duration;
  double price;
  String classType;
  String description;

  Course({
    required this.id,
    required this.dayOfWeek,
    required this.time,
    required this.capacity,
    required this.duration,
    required this.price,
    required this.classType,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      time: json['time'],
      capacity: json['capacity'],
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      classType: json['classType'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'capacity': capacity,
      'duration': duration,
      'price': price,
      'classType': classType,
      'description': description,
    };
  }
}