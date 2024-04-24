import 'package:hive/hive.dart';
import "car.dart";

part 'racetime.g.dart';

@HiveType(typeId:2)
class RaceTime {
  @HiveField(0)
  DateTime raceDate;
  @HiveField(1)
  double time;
  @HiveField(2)
  String country;
  @HiveField(3)
  String track;
  @HiveField(4)
  String carName;
  @HiveField(5)
  bool isAutomatic;
  @HiveField(6)
  bool steeringWheel;

  Car? car;

  RaceTime({
    required this.raceDate,
    required this.time,
    required this.country,
    required this.track,
    required this.carName,
    required this.isAutomatic,
    this.steeringWheel=true,
    this.car
  });

  bool equals(RaceTime rt) {
    return rt.raceDate == raceDate &&
        rt.time == time &&
        rt.country == country &&
        rt.track == track &&
        rt.carName == carName &&
        rt.isAutomatic == isAutomatic &&
        rt.steeringWheel == steeringWheel;
  }

  ///The minutes portion of the time
  int minutes() {
    return time~/60;
  }
  ///The seconds portion of the time
  double seconds() {
    double remain = time;
    int mins = remain~/60;
    remain -=mins*60;
    double secs = remain;
    return secs;
  }
  ///Time formatted like 9m 3.141s
  String timeFormatted() {
    double remain = time;
    int mins = remain~/60;
    remain -=mins*60;
    double secs = remain;
    return "${mins}m ${secs.toStringAsFixed(3)}s";
  }

  String carPerformanceClass(List<Car> cars) {
    Car? c = findCar(cars);
    if(c!=null) {
      return c.performanceClass;
    }
    return "";
  }

  Car? findCar(List<Car> cars) {
    if(car==null) {
      for(final c in cars) {
        if(c.name == carName) {
          car = c;
        }
      }
    }
    return car;
  }

  @override
  String toString() {
    return "$country, $track, $carName, ${isAutomatic?"automatic":"manual"}, ${timeFormatted()}";
  }
}
