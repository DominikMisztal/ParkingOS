class Car {
  String brand;
  String model;
  String registration_num;

  Car(this.brand, this.model, this.registration_num);

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'registration_num': registration_num,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      map['brand'] ?? '',
      map['model'] ?? '',
      map['registarion_num'] ?? '',
    );
  }
}
