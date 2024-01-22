class Car {
  Car({required this.brand, required this.model, required this.expences, required this.registration_num});

  final String brand;
  final String model;
  final String registration_num;
  final double expences;

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'registration_num': registration_num,
      'expences': expences,
    };
  }

  factory Car.fromMap(String title, Map<String, dynamic> map) {
    return Car(
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      expences: map['expences'] ?? 0,
      registration_num: title,
    );
  }
  @override
  String toString() {
    return '$brand $model $expences $registration_num ';
  }
}
