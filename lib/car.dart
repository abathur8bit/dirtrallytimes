import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId:1)
class Car {
  @HiveField(0)
  String name;
  @HiveField(1)
  String performanceClass;
  @HiveField(2)
  bool fwd;
  @HiveField(3)
  bool rwd;
  @HiveField(4)
  bool awd;
  @HiveField(5)
  int horsepower;
  @HiveField(6)
  int weight;
  @HiveField(7)
  String? notes;

  Car({
    required this.name,
    required this.performanceClass,
    required this.awd,
    required this.fwd,
    required this.rwd,
    required this.horsepower,
    required this.weight,
    this.notes
  });

  @override
  String toString() {
    return "$name, ${horsepower}hp";
  }
}

