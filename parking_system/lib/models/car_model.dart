class Car {
  Car({required this.brand, required this.model, required this.registration_num});

  final String brand;
  final String model;
  final String registration_num;

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'registration_num': registration_num,
    };
  }

  factory Car.fromMap(String title, Map<String, dynamic> map) {
    return Car(
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      registration_num: title,
    );
  }
  @override
  String toString() {
    return '$brand $model $registration_num';
  }
}
