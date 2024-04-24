import 'package:hive/hive.dart';

part 'track.g.dart';

@HiveType(typeId:0)
class Track {
  @HiveField(0)
  String country;
  @HiveField(1)
  String area;
  @HiveField(2)
  String name;
  @HiveField(3)
  bool isRallyCross=false;
  @HiveField(4)
  double miles;
  @HiveField(5)
  double killometers=0;
  @HiveField(6)
  String notes="";

  Track({
    required this.country,
    required this.area,
    required this.name,
    required this.miles,
    this.killometers=0,
    this.isRallyCross=false,
    this.notes="",
  });

  String milesFormatted() {
    return miles.toStringAsFixed(2);
  }
  String kmFormatted() {
    if(killometers==0) {
      killometers = miles*1.6;  //convert miles to KM
    }
    return killometers.toStringAsFixed(2);
  }

  @override
  String toString() {
    return "name=$name,area=$area, country=$country, miles=${milesFormatted()} rallycross=$isRallyCross";
  }
}