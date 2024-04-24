import "package:flutter/foundation.dart";
import 'package:hive_flutter/hive_flutter.dart';
import "track_names.dart";
import "car_names.dart";
import "race_times.dart";
import "track.dart";
import "car.dart";
import "track.dart";
import "racetime.dart";

const DBNAME = "DirtRallyTimesDatabase";
const DBTIMES = "DBTIMES";
const DBTRACKS = "DBTRACKS";
const DBCARS = "DBCARS";
const DBPREVIOUSTIME = "DBLASTTIME";
const APP_TITLE = "Dirt Rally 2.0 Times";

List<String> countrys = [
  "",
  "Argentina",
  "Australia",
  "Belguim",
  "New Zealand",
  "Poland",
  "USA",
  "Spain",
  "Unknown",
];


class DirtDatabase {
  Box mybox = Hive.box(DBNAME);
  List<RaceTime> raceTimes = [];
  List<Track> tracks = [];
  List<Car> cars = [];
  RaceTime? previousTime;

  static String twoDigit(int n) {
    if(n<0) {
      if(n.toString().length < 3) {
        return "-0${n.abs()}";
      } else {
        return n.toString();
      }
    } else {
      if (n
          .toString()
          .length < 2)
        return '0$n';
      return n.toString();
    }
  }

  static String dateTimeFull(DateTime? dt) {
    if(dt == null) return "";
    String y = dt.year.toString();
    String m = twoDigit(dt.month);
    String d = twoDigit(dt.day);
    String h = twoDigit(dt.hour);
    String min = twoDigit(dt.minute);
    String sec = twoDigit(dt.second);
    return "$m/$d/$y $h:$min:$sec";
  }

  static String dateTimeShort(DateTime? dt) {
    if(dt == null) return "";
    String m = twoDigit(dt.month);
    String d = twoDigit(dt.day);
    String h = twoDigit(dt.hour);
    String min = twoDigit(dt.minute);
    String sec = twoDigit(dt.second);
    return "$m/$d $h:$min";
  }

  static String dateLong(DateTime? dt) {
    if(dt == null) return "";
    String y = dt.year.toString();
    String m = twoDigit(dt.month);
    String d = twoDigit(dt.day);
    return "$m/$d/$y";
  }

  static String dateShort(DateTime? dt) {
    if(dt == null) return "";
    String m = twoDigit(dt.month);
    String d = twoDigit(dt.day);
    return "$m/$d";
  }

  static String dateTimeYYYYMMDDHHMM(DateTime? dt) {
    if(dt==null) return "";
    String y = dt.year.toString();
    String m = twoDigit(dt.month);
    String d = twoDigit(dt.day);
    String h = twoDigit(dt.hour);
    String min = twoDigit(dt.minute);
    String sec = twoDigit(dt.second);
    return "$y-$m-$d $h:$min";
  }

  void createDefaultData() {
    createTracks();
    createCars();
    // createTimes();
  }

  void createCars() {
    for(final car in carNames) {
      Car c = Car(
        name:car[0],
        performanceClass:car[1],
        fwd:car[2]=="X",
        rwd:car[3]=="X",
        awd:car[4]=="X",
        horsepower:int.tryParse(car[5]) ?? 0,
        weight:int.tryParse(car[6]) ?? 0,
        notes:car[7]
      );
      cars.add(c);
    }
  }

  void createTracks() {
    int area=0;
    int name=1;
    int rallycross=2;
    int miles=3;
    int km=4;
    int notes=5;
    int country=6;
    for(final track in trackNames) {
      Track t = Track(
          area:track[area],
          name:track[name],
          miles:(double.tryParse(track[miles]) ?? 0),
          killometers:(double.tryParse(track[km]) ?? 0),
          isRallyCross:track[rallycross]=='Y' ? true:false,
          notes:track[notes],
          country:track[country]
      );
      tracks.add(t);
    }
  }

  void createTimes() {
    for(final time in raceTimeSamples) {
      RaceTime rt = RaceTime(
        raceDate: DateTime.parse(time[0]),
        time: (double.tryParse(time[6]) ?? 0) * 60 + (double.tryParse(time[7]) ?? 0),
        country: time[1],
        track: time[2],
        carName: time[3],
        isAutomatic: time[4]=="Y" || time[4]=='y',
        steeringWheel: time[5]=="Y" || time[5]=="y",
      );
      bool hasError = false;
      if(findCar(rt.carName) == null) {
        hasError = true;
        print("Error: Car ${rt.carName} not found");
      }
      if(findTrack(rt.track) == null) {
        hasError = true;
        print("Error: Track ${rt.track} not found");
      }
      if(!hasError) {
        raceTimes.add(rt);
        print("time=${rt.toString()}");
      }
    }
  }

  Car? findCar(String name) {
    for(final c in cars) {
      if(c.name == name)
        return c;
    }
    return null;
  }

  Track? findTrack(String name) {
    for(final t in tracks) {
      if(t.name == name) {
        return t;
      }
    }
    return null;
  }

  void appendRaceTime(RaceTime rt) {
    raceTimes.add(rt);
    previousTime = rt;
    updateData();
  }
  void loadData() {
    if(mybox.get(DBTRACKS)==null) {
      createDefaultData();
    } else {
      if (mybox.get(DBTIMES) != null) {
        raceTimes = mybox.get(DBTIMES).cast<RaceTime>();
      }
      if (mybox.get(DBCARS) != null) {
        cars = mybox.get(DBCARS).cast<Car>();
      }
      if (mybox.get(DBTRACKS) != null) {
        tracks = mybox.get(DBTRACKS).cast<Track>();
      }
      if(mybox.get(DBPREVIOUSTIME) != null) {
        previousTime = mybox.get(DBPREVIOUSTIME);
      }
    }
  }
  //update database
  void updateData() {
    mybox.put(DBTIMES,raceTimes);    //update today
    mybox.put(DBTRACKS,tracks);    //update today
    mybox.put(DBCARS,cars);    //update today
    mybox.put(DBPREVIOUSTIME,previousTime);    //update previously entered time
  }

  void delete(RaceTime rt) {
    raceTimes.remove(rt);
    updateData();
  }
}

